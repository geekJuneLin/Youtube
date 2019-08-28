//
//  MenuBar.swift
//  Youtube
//
//  Created by Junyu Lin on 23/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class MenuBar: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    //MARK: - variables
    let cellId = "cellId"
    
    let bottomIndicatorContraint: NSLayoutConstraint = {
       let contraint = NSLayoutConstraint()
        return contraint
    }()
    
    let images: [String] = {
        return ["shop", "video-camera", "reload", "heart"]
    }()
    
    let menuCollectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    let bottomIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.borderColor = UIColor.white.cgColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var leftContraint: NSLayoutConstraint?
    var mainController: MainController?
    
    // MARK: - inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        menuCollectionView.dataSource = self
        menuCollectionView.delegate = self
        menuCollectionView.register(MenuCell.self, forCellWithReuseIdentifier: cellId)
        menuCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: false, scrollPosition: [])
        
        
        addSubview(menuCollectionView)
        anchors(visualFormat: "H:|[v0]|", views: menuCollectionView)
        anchors(visualFormat: "V:|[v0]|", views: menuCollectionView)
        
        addSubview(bottomIndicator)
        leftContraint = bottomIndicator.leftAnchor.constraint(equalTo: menuCollectionView.leftAnchor)
        leftContraint?.isActive = true
        bottomIndicator.bottomAnchor.constraint(equalTo: menuCollectionView.bottomAnchor).isActive = true
        bottomIndicator.widthAnchor.constraint(equalTo: menuCollectionView.widthAnchor, multiplier: 0.25).isActive = true
        bottomIndicator.heightAnchor.constraint(equalTo: menuCollectionView.heightAnchor, multiplier: 0.1).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Datasource methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! MenuCell
        cell.images = images[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 4, height: frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let xTranslate = CGFloat(indexPath.item) * self.menuCollectionView.frame.width / 4
        print(xTranslate)
        leftContraint?.constant = xTranslate
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.layoutIfNeeded()
        }, completion: nil)
        if indexPath.item < 4{
            mainController?.scrollToViewAtIndex(index: indexPath.item)
        }
    }
}
