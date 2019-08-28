//
//  MenuCell.swift
//  Youtube
//
//  Created by Junyu Lin on 23/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class MenuCell: UICollectionViewCell{
    
    // MARK: - variables
    var images: String?{
        didSet{
            if let image = images{
                imageView.image = UIImage(named: image)?.withRenderingMode(.alwaysTemplate)
            }
        }
    }
    
    let imageView:UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.tintColor = UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override var isHighlighted: Bool{
        didSet{
            imageView.tintColor = isHighlighted ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        }
    }
    
    override var isSelected: Bool{
        didSet{
            imageView.tintColor = isSelected ? .white : UIColor(red: 91/255, green: 14/255, blue: 13/255, alpha: 1)
        }
    }
    
    
    // MARK: - inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(imageView)
        anchors(visualFormat: "H:[v0(28)]", views: imageView)
        anchors(visualFormat: "V:[v0(28)]", views: imageView)
        
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: imageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
