//
//  PresentationController.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class PresentationController: UIPresentationController {
    
    override var frameOfPresentedViewInContainerView: CGRect {
        //let bounds = containerView!.bounds
        //let halfHeight = bounds.height / 2
        
        //let bounds = presentedViewController.view.bounds
        //let height = bounds.height
        //return CGRect(x: 0, y: UIScreen.main.bounds.height - height, width: bounds.width, height: height)
        return presentedViewController.view.frame
    }
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.addSubview(presentedView!)
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        presentedView?.frame = frameOfPresentedViewInContainerView
    }
    
    var driver: TransitionDriver!
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if completed {
            driver.direction = .present
        }
    }
}
