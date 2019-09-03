//
//  VideoView.swift
//  Youtube
//
//  Created by Junyu Lin on 29/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: UIViewController, videoPlayDelegate{
    
    // MARK: - variables
    var interacting: Interactor?
    
    var hideVideoPlayView = true
    
    private var player: AVPlayer?
    
    let baseView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let videoView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let slider: CustomSlider = {
       let slider = CustomSlider()
        let image = UIImage(named: "thumb")?.withRenderingMode(.alwaysOriginal)
        slider.setThumbImage(image, for: .normal)
        slider.addTarget(self, action: #selector(handleSlide), for: .valueChanged)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let playView: VideoPlayView = {
        let view = VideoPlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupPlayer()
    }
    
    // MARK: - set up views
    fileprivate func setupViews(){
        // set delegate
        playView.playVideoDelegate = self
        
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePan))
        
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleTap))
        
        view.backgroundColor = .black
        
        view.addSubview(baseView)
        view.addSubview(videoView)
        view.addSubview(slider)
        videoView.addSubview(playView)
        playView.isHidden = hideVideoPlayView
        
        videoView.addGestureRecognizer(gesture)
        videoView.addGestureRecognizer(tapGesture)

        baseView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        videoView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 6 / 19).isActive = true
        
        slider.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        slider.topAnchor.constraint(equalTo: videoView.bottomAnchor).isActive = true
        slider.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        
        playView.widthAnchor.constraint(equalTo: videoView.widthAnchor).isActive = true
        playView.heightAnchor.constraint(equalTo: videoView.heightAnchor).isActive = true
    }
    
    // TODO: - video player
    // MARK: - set up video player https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
    fileprivate func setupPlayer(){
        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        player = AVPlayer(url: url!)
        setupVideoPlayerObserver()
        let videoPlayer = VideoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 6 / 19))
        videoPlayer.player = player
        if let layer = videoPlayer.layer as? AVPlayerLayer {
            layer.videoGravity = .resizeAspectFill
        }
        videoView.addSubview(videoPlayer)
        player?.play()
        player?.pause()
    }
    
    // MARK: - video player observer
    private let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    
    fileprivate func setupVideoPlayerObserver(){
        let totalTime = player?.currentItem?.asset.duration.seconds
        let mini = Int(totalTime!) / 60
        let secs = Int(totalTime!) % 60
        self.playView.timingEndLabel.text = "\(mini):0\(secs)"
        player?.addPeriodicTimeObserver(forInterval: interval, queue: nil, using: { (time) in
            var currentTime: Float64, mini: Int, sec: Int
            currentTime = floor(CMTimeGetSeconds(time))
            mini = Int(currentTime / 60)
            sec = Int(currentTime)
            var time = ""
            DispatchQueue.main.async {
                time = mini > 0 ? "\(mini):" : "0:"
                time = sec > 10 ? time + "\(sec)" : time + "0\(sec)"
                self.playView.timingStartLabel.text = time
                self.slider.value = Float(currentTime / totalTime!)
            }
        })
    }
    
    // MARK: - pan gesuter handler
    @objc func handlePan(_ gesture: UIPanGestureRecognizer){
        let progess = gesture.translation(in: view).y
        let downward = max((progess / view.frame.height), 0)
        let percentage = CGFloat(min(downward, 1))

        if let inter = interacting {
            switch gesture.state {
            case .began:
                print("begin")
                inter.started = true
                dismiss(animated: true, completion: nil)
            case .changed:
                print("changing")
                inter.finished = percentage > CGFloat(0.1)
                inter.update(percentage)
            case .cancelled:
                print("cancel")
                inter.started = false
                inter.cancel()
            case .ended:
                print("end")
                inter.started = false
                inter.finished ? inter.finish() : inter.cancel()
                player?.pause()
            default:
                break
            }
        }
    }
    
    @objc func handleTap(){
        print("\(hideVideoPlayView)")
        videoView.bringSubviewToFront(playView)
        hideVideoPlayView = hideVideoPlayView ? false : true
        playView.isHidden = hideVideoPlayView
    }
    
    @objc func handleSlide(){
        print("value changed")
        let time = CMTime(value: Int64(Float64(slider.value) * (player?.currentItem?.duration.seconds)!), timescale: 1)
        player?.seek(to: time, completionHandler: { (completed) in
            // do something after completion
        })
    }
    
    // MARK: - play video delegate
    func playVideo() {
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
    }
}
