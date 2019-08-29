//
//  ViewController.swift
//  Youtube
//
//  Created by Junyu Lin on 22/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: - variables
    let cellId = "cellId"
    
    var videos: [Video]?
    

    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello world")
        
        fetchData()
        
        setupNavigation()
        setupCollectionView()
        setupBarItems()
        setupMenus()
    }
    
    // MARK: - fetch data
    fileprivate func fetchData(){
        videos = [Video]()
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error != nil{
                print(error!)
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                for dictionary in json as! [[String: AnyObject]]{
                    let formatter = NumberFormatter()
                    formatter.numberStyle = .decimal
                    var video = Video()
                    var channel = Channel()
                    
                    channel.image = dictionary["channel"]?["profile_image_name"] as? String
                    channel.name = dictionary["channel"]?["name"] as? String
                    
                    video.channel = channel
                    video.title = dictionary["title"] as? String
                    video.numberOfViews = dictionary["number_of_views"] as? Int
                    video.imageName = dictionary["thumbnail_image_name"] as? String
                    if let channelName = video.channel?.name, let views = formatter.string(for: video.numberOfViews){
                        video.des = "\(channelName) - \(views)"
                    }
                    self.videos?.append(video)
                }
                
                DispatchQueue.main.async(execute: {
                    self.collectionView.reloadData()
                })
            } catch let jsonError{
                print(jsonError)
            }
        }.resume()
    }
    
    // MARK: - set up navigation
    fileprivate func setupNavigation(){
        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        titleLabel.text = "  Home"
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.barTintColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barStyle = .blackTranslucent
    }
    
    // MARK: - set up collection views
    fileprivate func setupCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        // Move the menu bar and scroll indicator down
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: - set up bar items
    fileprivate func setupBarItems(){
        let searchImage = UIImage(named: "loupe")?.withRenderingMode(.alwaysOriginal)
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchBtnPressed))
        
        let menuImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(menuBtnPressed))
        
        navigationItem.rightBarButtonItems = [menuButton, searchButton]
    }
    
    // MARK: - Menu bar buttons pressed
    @objc func searchBtnPressed(){
        print("search button pressed")
    }
    
    let settingLauncher = SettingLanucher()
    
    @objc func menuBtnPressed(){
        settingLauncher.showSettings()
    }
    
    // MARK: - set up the menu bar below the navigation bar
    let menuView: MenuBar = {
        let mb = MenuBar()
        mb.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
        mb.translatesAutoresizingMaskIntoConstraints = false
        return mb
    }()
    
    fileprivate func setupMenus(){
        let redView = UIView()
        redView.backgroundColor = UIColor(red: 230/255, green: 32/255, blue: 31/255, alpha: 1)
        redView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(redView)
        view.addSubview(menuView)
        
        view.anchors(visualFormat: "H:|[v0]|", views: menuView)
        view.anchors(visualFormat: "V:[v0(50)]", views: menuView)
        view.anchors(visualFormat: "H:|[v0]|", views: redView)
        view.anchors(visualFormat: "V:[v0(50)]", views: redView)
        
        menuView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuView.mainController = self
    }

    // MARK: - delegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        cell.videos = videos
        cell.navigationBar = navigationController
        return cell
    }
    
    
    //MARK: - collection view layout methods
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - view.frame.width / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let x = targetContentOffset.pointee.x
        
        print(x / view.frame.width)
        let nextIndex = IndexPath(item: Int(x / view.frame.width), section: 0)
        collectionView.scrollToItem(at: nextIndex, at: .centeredHorizontally, animated: true)
        
        menuView.leftContraint?.constant = CGFloat(integerLiteral: Int(x / view.frame.width)) * menuView.frame.width / 4
        menuView.menuCollectionView.selectItem(at: nextIndex, animated: true, scrollPosition: .centeredHorizontally)
        
        
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func scrollToViewAtIndex(index: Int){
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

