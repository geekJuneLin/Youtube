//
//  DismissAnimator.swift
//  Youtube
//
//  Created by Junyu Lin on 1/09/19.
//  Copyright © 2019 Junyu Lin. All rights reserved.
//

import UIKit

class DismissAnimator: NSObject{
    
}

class Interactor: UIPercentDrivenInteractiveTransition{
    
    var started = false
    var finished = false
    
}

// custom dismiss animation which is interactive
extension DismissAnimator: UIViewControllerAnimatedTransitioning{
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 2
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        
        let containerView = transitionContext.containerView
        
        containerView.insertSubview(fromVC.view, belowSubview: toVC.view)
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            fromVC.view.backgroundColor = UIColor(white: 1, alpha: 0)
            fromVC.view.frame = CGRect(origin: CGPoint(x: 0, y: UIScreen.main.bounds.height), size: UIScreen.main.bounds.size)
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    
}
