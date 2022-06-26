//
//  PanelTransition.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class PanelTransition: NSObject, UIViewControllerTransitioningDelegate {
    
    // Presentation controller
    private let driver = TransitionDriver()
    var needDarkness = true
    var transition = TTransition.crossdisolve
    var vSpace: CGFloat = 0
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        driver.link(to: presented)
        
        let presentationController = needDarkness ? DimmPresentationController(presentedViewController: presented, presenting: presenting ?? source) :
        PresentationController(presentedViewController: presented, presenting: presenting ?? source)
        // add from top or from bot
        presentationController.driver = driver
        
        return presentationController
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = PresentAnimation()
        animation.transition = transition
        animation.vSpace = vSpace
        return animation
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animation = DismissAnimation()
        animation.transition = transition
        animation.vSpace = vSpace
        return animation
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return driver
    }
}
