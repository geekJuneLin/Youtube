//
//  SlideMenu.swift
//  Youtube
//
//  Created by Junyu Lin on 28/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class SlideMenu: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    var settings: [Setting]?
    
    let cellId = "cellId"
    
    let menuCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.showsVerticalScrollIndicator = false
        cv.backgroundColor = .white
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        print(settings?.count)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView(){
        addSubview(menuCollectionView)
        
        menuCollectionView.delegate = self
        menuCollectionView.dataSource = self
        menuCollectionView.register(SlideMenuCell.self, forCellWithReuseIdentifier: cellId)
        
        menuCollectionView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        menuCollectionView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    // MARK: - delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SlideMenuCell
        cell.setting = settings?[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    
}
