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
    
    // MARK: - Properties
    
    // variables
    var interacting: Interactor?
    
    var hideVideoPlayView = true
    
    private var player: AVPlayer?
    
    private var observerToken: Any?
    
    // UI variables
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
        slider.addTarget(self, action: #selector(handleSlideTap), for: .touchUpInside)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    let playView: VideoPlayView = {
        let view = VideoPlayView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let collectionView: VideoBottomView = {
       let cv = VideoBottomView()
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupPlayer()
        setupBottomCollectionViews()
    }
    
    // MARK: - set up methods
    
    // set up views
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
    
    // set up video player https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
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
    
    // set up video player observer
    private let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    
    fileprivate func setupVideoPlayerObserver(){
        let totalTime = player?.currentItem?.asset.duration.seconds
        let mini = Int(totalTime!) / 60
        let secs = Int(totalTime!) % 60
        var preTime: Float64 = 0
        self.playView.timingEndLabel.text = "\(mini):0\(secs)"
        observerToken =
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
                
            if (currentTime - preTime) > 3 && self.player?.rate == 1 {
                self.hideVideoPlayView = true
                self.playView.isHidden = true
                preTime = currentTime
            }
        })
    }
    
    // set up bottom collection view
    func setupBottomCollectionViews(){
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 10).isActive = true
        collectionView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - gestures handlers
    
    // pan gesture handler
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
                // TODO: - fix the bug
//                if let token = observerToken,
//                   let play = player{
//                    play.removeTimeObserver(token)
//                }
            default:
                break
            }
        }
    }
    
    // tap gesture handler
    @objc func handleTap(){
        videoView.bringSubviewToFront(playView)
        hideVideoPlayView = hideVideoPlayView ? false : true
        playView.isHidden = hideVideoPlayView
        print("\(hideVideoPlayView)")
    }
    
    // slide gesture handler
    @objc func handleSlide(){
        print("value changed")
        let time = CMTime(value: Int64(Float64(slider.value) * (player?.currentItem?.duration.seconds)!), timescale: 1)
        player?.seek(to: time, completionHandler: { (completed) in
            // do something after completion
        })
    }
    
    // slider tap gesture handler
    @objc func handleSlideTap(){
        print("slider tapped")
        if hideVideoPlayView {
            playView.isHidden = false
            hideVideoPlayView = false
        }
        videoView.bringSubviewToFront(playView)
    }
    
    // MARK: - play video delegate
    func playVideo() {
        player?.play()
    }
    
    func pauseVideo() {
        player?.pause()
    }
}
