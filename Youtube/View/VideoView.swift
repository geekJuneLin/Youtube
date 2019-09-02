//
//  VideoView.swift
//  Youtube
//
//  Created by Junyu Lin on 2/09/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit
import AVKit

class VideoView: UIView{
    
    var player: AVPlayer?{
        get{
            return playerLayer.player
        }
        
        set{
            playerLayer.player = newValue
        }
    }
    
    var playerLayer: AVPlayerLayer{
        return layer as! AVPlayerLayer
    }
    
    override static var layerClass: AnyClass{
        return AVPlayerLayer.self
    }
}
