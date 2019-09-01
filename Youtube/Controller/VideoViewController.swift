//
//  VideoView.swift
//  Youtube
//
//  Created by Junyu Lin on 29/08/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

protocol VideoViewPopUpDelegate {
    func handlePopUp()
}

class VideoViewController: UIViewController{
    
    var interacting: Interactor?
    
    let baseView: UIView = {
       let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    fileprivate func setupViews(){
        let gesture = UIPanGestureRecognizer()
        gesture.addTarget(self, action: #selector(handlePan))
        
        view.backgroundColor = UIColor(white: 1, alpha: 0)
        
        view.addSubview(baseView)
        
        view.addGestureRecognizer(gesture)

        baseView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        baseView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        baseView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer){
        let progess = gesture.translation(in: view).y
        let downward = max((progess / view.frame.height), 0)
        let percentage = CGFloat(min(downward, 1))

        if let inter = interacting {
            switch gesture.state {
            case .began:
                print("begin")
                inter.started = true
                dismiss(animated: true, completion: nil)
            case .changed:
                print("changing")
                inter.finished = percentage > CGFloat(0.1)
                inter.update(percentage)
            case .cancelled:
                print("cancel")
                inter.started = false
                inter.cancel()
            case .ended:
                print("end")
                inter.started = false
                inter.finished ? inter.finish() : inter.cancel()
            default:
                break
            }
        }
    }
    
}
