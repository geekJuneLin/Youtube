//
//  SettingLanucher.swift
//  Youtube
//
//  Created by Junyu Lin on 28/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class SettingLanucher: NSObject{
    
    let blackView = UIView()
    let slideMenuView = SlideMenu()
    
    func showSettings(){
        print("menu button pressed")
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(slideMenuView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            let height: CGFloat = window.frame.height * 0.6
            let y: CGFloat = window.frame.height - height
    
            slideMenuView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)

            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
                self.slideMenuView.frame = CGRect(x: 0, y: y, width: window.frame.width, height: height)
            }
        }
    }
    
    @objc func handleDismiss(){
        if let window = UIApplication.shared.keyWindow{
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 0
                let height: CGFloat = window.frame.height * 0.6
                self.slideMenuView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: height)
                window.layoutIfNeeded()
            }
        }
    }
    
    override init() {
        super.init()
    }
}
