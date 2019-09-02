//
//  VideoView.swift
//  Youtube
//
//  Created by Junyu Lin on 29/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit
import AVKit

class VideoViewController: UIViewController{
    
    // MARK: - variables
    var interacting: Interactor?
    
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
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePan))
        
        view.backgroundColor = .black
        
        view.addSubview(baseView)
        view.addSubview(videoView)
        
        view.addGestureRecognizer(gesture)

        baseView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        videoView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        videoView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        videoView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 6 / 19).isActive = true
    }
    
    // TODO: - video player
    // MARK: - set up video player https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4
    fileprivate func setupPlayer(){
        let url = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let player = AVPlayer(url: url!)
        let videoPlayer = VideoView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 6 / 19))
        videoPlayer.player = player
        if let layer = videoPlayer.layer as? AVPlayerLayer {
            layer.videoGravity = .resizeAspectFill
        }
        videoView.addSubview(videoPlayer)
        player.play()
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
            default:
                break
            }
        }
    }
    
}
