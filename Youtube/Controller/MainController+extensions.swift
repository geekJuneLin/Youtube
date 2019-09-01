//
//  MainController+extensions.swift
//  Youtube
//
//  Created by Junyu Lin on 1/09/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

extension MainController: UIViewControllerTransitioningDelegate {
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return DismissAnimator()
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor.started ? interactor : nil
    }
    
}
