//
//  CustomSlider.swift
//  Youtube
//
//  Created by Junyu Lin on 3/09/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class CustomSlider: UISlider{
    
    override func trackRect(forBounds bounds: CGRect) -> CGRect {
        let customBounds = CGRect(origin: bounds.origin, size: CGSize(width: bounds.size.width
            , height: 4))
        super.trackRect(forBounds: customBounds)
        return customBounds
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.minimumTrackTintColor = .red
        self.maximumTrackTintColor = UIColor(white: 0.5, alpha: 0.1)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
