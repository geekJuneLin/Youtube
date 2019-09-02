//
//  CustomCell.swift
//  Youtube
//
//  Created by Junyu Lin on 22/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class CustomCell: UICollectionViewCell{
    
    var estimatedFrame: CGRect?
    var video: Video? {
        didSet{
            
            loadImages()
            if let title = video?.title{
                titleView.text = title
                
                let size = CGSize(width: self.frame.width - 135, height: 1000)
                let attributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]
                estimatedFrame = NSString(string: title).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                
                if estimatedFrame!.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                }else{
                    titleLabelHeightConstraint?.constant = 20
                }
            }
            
            if let des = video?.des{
                descriptionView.text = des
            }
            
            if let time = video?.duration{
                print(time)
                var minSec = ""
                let min: Int = time / 60
                let sec = time % 60
                if min < 10 {
                    minSec.append(contentsOf: "0\(min):")
                } else {
                    minSec.append(contentsOf: "\(min):")
                }
                
                if sec < 10 {
                    minSec.append(contentsOf: "0\(sec)")
                } else {
                    minSec.append(contentsOf: "\(sec)")
                }
                
                timingLabel.text = minSec
            }
        }
    }
    
    fileprivate func loadProfileImages(){
        if let channelImage = video?.channel?.image{
            imageView.loadImages(string: channelImage)
        }
    }
    
    fileprivate func loadImages(){
        if let image = video?.imageName{
            videoView.loadImages(string: image)
        }
    }
    
    
    // MARK: - variables
    let videoView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .blue
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "dinosaur")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 22
        imageView.backgroundColor = .cyan
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let titleView: UILabel = {
        let textView = UILabel()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.numberOfLines = 2
        return textView
    }()
    
    let descriptionView: UITextView = {
       let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .lightGray
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isEditable = false
        return textView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1).cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let timingLabel: UILabel = {
        let label = UILabel()
        label.text = "03:20"
        label.textColor = .white
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 8
        label.backgroundColor = UIColor(white: 0, alpha: 0.5)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    // MARK: - init func
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - func setupViews
    fileprivate func setupViews(){
        addSubview(imageView)
        addSubview(videoView)
        addSubview(titleView)
        addSubview(descriptionView)
        addSubview(separatorView)
        addSubview(timingLabel)
        
        // place elements using anchors
//        videoView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
//        videoView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
//        videoView.topAnchor.constraint(equalTo: topAnchor).isActive = true
//        videoView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
//
//        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        imageView.topAnchor.constraint(equalTo: videoView.bottomAnchor, constant: 10).isActive = true
//
//        titleView.topAnchor.constraint(equalTo: imageView.topAnchor).isActive = true
//        titleView.leftAnchor.constraint(equalTo: imageView.rightAnchor, constant: 8).isActive = true
//        titleView.rightAnchor.constraint(equalTo: videoView.rightAnchor).isActive = true
//        titleView.heightAnchor.constraint(equalToConstant: 22.5).isActive = true
//
//        descriptionView.topAnchor.constraint(equalTo: titleView.bottomAnchor, constant: 5).isActive = true
//        descriptionView.leftAnchor.constraint(equalTo: titleView.leftAnchor).isActive = true
//        descriptionView.rightAnchor.constraint(equalTo: titleView.rightAnchor).isActive = true
//        descriptionView.bottomAnchor.constraint(equalTo: imageView.bottomAnchor).isActive = true
//
//        separatorView.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
//        separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
//        separatorView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
        
        // place elements using visual format languages
        anchors(visualFormat: "H:|-16-[v0]-16-|", views: videoView)
        anchors(visualFormat: "V:|-16-[v0]-8-[v1(44)]-40-[v2(1)]|", views: videoView, imageView, separatorView)
        anchors(visualFormat: "H:|[v0]|", views: separatorView)
        anchors(visualFormat: "H:|-16-[v0(44)]", views: imageView)
        
        // title label constraint, top left right height
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: videoView, attribute: .bottom, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: titleView, attribute: .right, relatedBy: .equal, toItem: videoView, attribute: .right, multiplier: 1, constant: 0))
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 20)
        addConstraint(titleLabelHeightConstraint!)
        
        
        // description label constraint, top left right height
        addConstraint(NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1, constant: 2))
        addConstraint(NSLayoutConstraint(item: descriptionView, attribute: .left, relatedBy: .equal, toItem: imageView, attribute: .right, multiplier: 1, constant: 8))
        addConstraint(NSLayoutConstraint(item: descriptionView, attribute: .right, relatedBy: .equal, toItem: videoView, attribute: .right, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 40))
        
        timingLabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        timingLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        timingLabel.rightAnchor.constraint(equalTo: videoView.rightAnchor, constant: -10).isActive = true
        timingLabel.bottomAnchor.constraint(equalTo: videoView.bottomAnchor, constant: -10).isActive = true
    }
}
