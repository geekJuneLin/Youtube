//
//  VideoPlayView.swift
//  Youtube
//
//  Created by Junyu Lin on 3/09/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit
import AVKit

protocol videoPlayDelegate {
    func playVideo()
    func pauseVideo()
}

class VideoPlayView: UIView{
    
    // MARK: - properties
    var playVideoDelegate: videoPlayDelegate?
    
    private var playVideo = false
    
    let playView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timingStartLabel: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timingEndLabel: UILabel = {
        let label = UILabel()
        label.text = "5:00"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 5
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var playImage = UIImage(named: "playButton")?.withRenderingMode(.alwaysOriginal)
    
    private var stopImage = UIImage(named: "pauseButton")?.withRenderingMode(.alwaysOriginal)
    
    let playButton: UIButton = {
       let button = UIButton(type: .system)
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // MARK: - init methods
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - functions
    fileprivate func setupView(){
        addSubview(playView)
        addSubview(playButton)
        addSubview(timingStartLabel)
        addSubview(timingEndLabel)
        
        playButton.setImage(playImage, for: .normal)
        
        playView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        playView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        timingStartLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        timingStartLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        timingStartLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        timingStartLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
        timingEndLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -5).isActive = true
        timingEndLabel.heightAnchor.constraint(equalToConstant: 15).isActive = true
        timingEndLabel.widthAnchor.constraint(equalToConstant: 30).isActive = true
        timingEndLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12).isActive = true
        
        playButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playButton.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    
    @objc func handlePlay(){
        print("Play video")
        playVideo = playVideo ? false : true
        playVideo ? playVideoDelegate?.playVideo() : playVideoDelegate?.pauseVideo()
        
        UIView.animate(withDuration: 0.5) {
            self.playVideo ? self.playButton.setImage(self.stopImage, for: .normal) : self.playButton.setImage(self.playImage, for: .normal)
        }
    }
}
