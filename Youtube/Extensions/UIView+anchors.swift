//
//  UIView+anchors.swift
//  Youtube
//
//  Created by Junyu Lin on 23/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit
extension UIView{
    
    func anchors(visualFormat: String, views: UIView...){
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated(){
            let key = "v\(index)"
            viewsDictionary[key] = view
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat, options: [], metrics: nil, views: viewsDictionary))
    }
}
