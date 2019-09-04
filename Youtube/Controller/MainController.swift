//
//  ViewController.swift
//  Youtube
//
//  Created by Junyu Lin on 22/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class MainController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    // MARK: Properties
    
    // variables
    let cellId = "cellId"
    
    let titles = ["  Home", "  Trending", "  Subscription", "  Account"]
    
    var videos: [Video]?
    
    var interactor = Interactor()
    

    // MARK: - view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Hello world")
        
        fetchData()
        
        setupNavigation()
        setupCollectionView()
        setupBarItems()
        setupMenus()
        
        SettingLanucher.shard.mainController = self
    }
    
    // MARK: - set up methods
    
    // set up navigation
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
    
    // set up collection view
    fileprivate func setupCollectionView(){
        collectionView.backgroundColor = .white
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: cellId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        
        // Move the menu bar and scroll indicator down
        collectionView.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
    }
    
    // set up bar items
    fileprivate func setupBarItems(){
        let searchImage = UIImage(named: "loupe")?.withRenderingMode(.alwaysOriginal)
        let searchButton = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(searchBtnPressed))
        
        let menuImage = UIImage(named: "more")?.withRenderingMode(.alwaysOriginal)
        let menuButton = UIBarButtonItem(image: menuImage, style: .plain, target: self, action: #selector(menuBtnPressed))
        
        navigationItem.rightBarButtonItems = [menuButton, searchButton]
    }
    
    // set up the menu bar below the navigation bar
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
    
    // MARK: - button action handler
    @objc func searchBtnPressed(){
        print("search button pressed")
    }
    
    
    @objc func menuBtnPressed(){
       SettingLanucher.shard.showSettings()
    }
    
    // MARK: - functions
    
    // fetch data
    fileprivate func fetchData(){
        videos = [Video]()
        ApiService.shard.fetchData({ (videos) -> (Void) in
            self.videos = videos
            DispatchQueue.main.async(execute: {
                self.collectionView.reloadData()
            })
        })
    }
    
    // present view controller
    func presentViewController(setting: Setting){
        let viewController = UIViewController()
        viewController.view.backgroundColor = .white
        viewController.navigationItem.title = setting.title
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // override present function of navigation controller
    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        navigationController?.present(viewControllerToPresent, animated: flag, completion: completion)
        
        if let des = viewControllerToPresent as? VideoViewController {
            print("view controller")
            des.transitioningDelegate = self
            des.interacting = interactor
        }
    }
    
    // displaying the video view controller
    func presentVideoView(){
        let videoViewController = VideoViewController()
        
        videoViewController.modalPresentationStyle = .custom
        self.present(videoViewController, animated: true) {
        }
    }
    
    // display the selected cell
    func scrollToViewAtIndex(index: Int){
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        updateNavigationTitle(index: index)
    }
    
    // update the title of the navigation bar
    fileprivate func updateNavigationTitle(index: Int){
        if let label = navigationItem.titleView as? UILabel{
            label.text = titles[index]
        }
    }
    
    // MARK: - delegate methods
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! PageCell
        cell.videos = videos
        cell.navigationController = navigationController
        cell.mainController = self
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
        
        updateNavigationTitle(index: nextIndex.item)
        
        UIView.animate(withDuration: 0.75, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
