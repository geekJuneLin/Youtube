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
    var slideMenuViewBottomConstraint: NSLayoutConstraint?
    
    func showSettings(){
        print("menu button pressed")
        if let window = UIApplication.shared.keyWindow{
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            window.addSubview(slideMenuView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            slideMenuView.translatesAutoresizingMaskIntoConstraints = false
            slideMenuView.heightAnchor.constraint(equalTo: window.heightAnchor, multiplier: 0.6).isActive = true
            slideMenuViewBottomConstraint = slideMenuView.bottomAnchor.constraint(equalTo: window.bottomAnchor, constant: window.frame.height * 0.6)
            slideMenuViewBottomConstraint?.isActive = true
            slideMenuView.widthAnchor.constraint(equalTo: window.widthAnchor).isActive = true
            
            UIView.animate(withDuration: 0.5) {
                self.blackView.alpha = 1
                self.slideMenuViewBottomConstraint?.constant = 0
                window.layoutIfNeeded()
            }
        }
    }
    
    @objc func handleDismiss(){
        UIView.animate(withDuration: 0.5) {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow{
                self.slideMenuViewBottomConstraint?.constant = window.frame.height * 0.6
                window.layoutIfNeeded()
            }
        }
    }
    
    override init() {
        super.init()
    }
}
