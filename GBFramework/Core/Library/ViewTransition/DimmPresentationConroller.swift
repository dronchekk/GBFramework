//
//  DimmPresentationConroller.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class DimmPresentationController: PresentationController {
    
    // darkness
    private lazy var dimmView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        view.alpha = 0
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        return view
    }()
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        dimmView.frame = containerView!.frame
    }
    
    // Start animation
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
        containerView?.insertSubview(dimmView, at: 0)
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 1
        }
    }
    
    override func presentationTransitionDidEnd(_ completed: Bool) {
        super.presentationTransitionDidEnd(completed)
        if !completed { // If start animation canceled or interrupted
            self.dimmView.removeFromSuperview()
        }
    }
    
    // Dismiss animation
    override func dismissalTransitionWillBegin() {
        super.dismissalTransitionWillBegin()
        performAlongsideTransitionIfPossible { [unowned self] in
            self.dimmView.alpha = 0
        }
    }
    
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        super.dismissalTransitionDidEnd(completed)
        if completed { // if dismis transision canceled or interrupted
            self.dimmView.removeFromSuperview()
        }
    }
    
    // Animation start
    private func performAlongsideTransitionIfPossible(_ block: @escaping () -> Void) {
        guard let coordinator = self.presentedViewController.transitionCoordinator else {
            block()
            return
        }
        coordinator.animate(alongsideTransition: { (_) in
            block()
        }, completion: nil)
    }
}

extension DimmPresentationController {
    @objc private func onTap() {
        presentedViewController.dismiss(animated: true, completion: nil)
    }
}
