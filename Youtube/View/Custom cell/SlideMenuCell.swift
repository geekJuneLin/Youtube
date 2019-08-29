//
//  SlideMenuCell.swift
//  Youtube
//
//  Created by Junyu Lin on 29/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class SlideMenuCell: UICollectionViewCell{
    
    var setting: Setting?{
        didSet{
            if let image = setting?.imageName{
                iconView.image = UIImage(named: image)
            }
            if let title = setting?.title{
                titleLabel.text = title
            }
        }
    }
    
    override var isHighlighted: Bool{
        didSet{
            backgroundColor = isHighlighted ? .gray : .white
            titleLabel.textColor = isHighlighted ? .white : .gray
        }
    }
    
    let iconView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupViews(){
        addSubview(iconView)
        addSubview(titleLabel)
        
        iconView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        iconView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15).isActive = true
        iconView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        iconView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        titleLabel.leftAnchor.constraint(equalTo: iconView.rightAnchor, constant: 10).isActive = true
        titleLabel.topAnchor.constraint(equalTo: iconView.topAnchor, constant: 5).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
