//
//  PresentAnimation.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class PresentAnimation: NSObject {

    var duration:TimeInterval = 0.3
    var vSpace: CGFloat = 0
    var transition: TTransition = .crossdisolve

    private func updateDuration(_ frame: CGRect) {
        if transition == .crossdisolve { return }
        if frame.height > UIScreen.main.bounds.height * 0.5 {
            duration *= 1.4
        }
    }

    func getStartFrame(_ rootFrame: CGRect, _ frame: CGRect) -> CGRect {
        switch transition {
        case .bottomsheet:
            if #available(iOS 13, *) {
                //return CGRect(x: 0, y: UIScreen.main.bounds.height - frame.height, width: frame.width, height: frame.height)
                return CGRect(x: 0, y: rootFrame.height - frame.height, width: frame.width, height: frame.height)
            }
            //return CGRect(x: 0, y: UIScreen.main.bounds.height, width: frame.width, height: frame.height)
            return CGRect(x: 0, y: rootFrame.height, width: frame.width, height: frame.height)
        case .showFromTop:
            if #available(iOS 13, *) {
                return CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
            }
            return CGRect(x: 0, y: -(frame.height + vSpace), width: frame.width, height: frame.height)
        case .showFromBottom:
            if #available(iOS 13, *) {
                //return CGRect(x: 0, y: UIScreen.main.bounds.height - frame.height, width: frame.width, height: frame.height)
                return CGRect(x: 0, y: rootFrame.height - frame.height, width: frame.width, height: frame.height)
            }
            //return CGRect(x: 0, y: UIScreen.main.bounds.height, width: frame.width, height: frame.height)
            return CGRect(x: 0, y: rootFrame.height, width: frame.width, height: frame.height)
        default: return frame
        }
    }

    func getEndFrame(_ rootFrame: CGRect, _ frame: CGRect) -> CGRect {
        switch transition {
        case .bottomsheet:
            return frame.offsetBy(dx: 0, dy: -frame.height)
        case .showFromTop:
            return frame.offsetBy(dx: 0, dy: frame.height + vSpace)
        case .showFromBottom:
            return frame.offsetBy(dx: 0, dy: -frame.height)
        default: return frame
        }
    }

    private func animator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        let toView = transitionContext.view(forKey: .to)!
        let fromController = transitionContext.viewController(forKey: .from) as? DialogRootVC
        let rootFrame = fromController?.delegate?.frame ?? UIScreen.main.bounds
        updateDuration(toView.frame)

        let startFrame = getStartFrame(rootFrame, toView.frame)
        let endFrame = getEndFrame(rootFrame, startFrame)

        toView.frame = startFrame
        if transition == .crossdisolve {
            toView.alpha = 0
        }
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeIn) {
            toView.frame = endFrame
            toView.alpha = 1
        }
        animator.addCompletion { (position) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled) // end animation if not cancelled
            if !transitionContext.transitionWasCancelled && self.transition == .crossdisolve {
                let toView = transitionContext.view(forKey: .to)!
                toView.alpha = 1
            }
        }
        return animator
    }
}

extension PresentAnimation: UIViewControllerAnimatedTransitioning {

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let animator = self.animator(using: transitionContext)
        animator.startAnimation()
    }

    func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
        return self.animator(using: transitionContext)
    }
}
