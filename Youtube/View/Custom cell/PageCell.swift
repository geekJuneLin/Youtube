//
//  PageCell.swift
//  Youtube
//
//  Created by Junyu Lin on 27/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class PageCell: UICollectionViewCell, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate{
    
    // MARK: - variables
    var videos: [Video]?
    var navigationBar: UINavigationController?
    
    let cellId = "cellId"
    var cv: UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: - delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! CustomCell
        if let video = videos?[indexPath.item]{
            cell.video = video
            return cell
        }else{
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cv.frame.width, height: (cv.frame.width - 32) * 12 / 16 + 92)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cv)
        anchors(visualFormat: "H:|[v0]|", views: cv)
        anchors(visualFormat: "V:|[v0]|", views: cv)
        
        // register the UICollectionViewCell
        cv.register(CustomCell.self, forCellWithReuseIdentifier: cellId)
        
        // set the delegate and datasource
        cv.delegate = self
        cv.dataSource = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - when each page is scrolled by users, hide the navigation bar
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView.panGestureRecognizer.translation(in: scrollView).y < 0{
            self.navigationBar?.setNavigationBarHidden(true, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }else{
            self.navigationBar?.setNavigationBarHidden(false, animated: true)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                self.layoutIfNeeded()
            }, completion: nil)
        }
    }
}
