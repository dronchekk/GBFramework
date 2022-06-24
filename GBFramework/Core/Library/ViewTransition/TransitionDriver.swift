//
//  TransitionDriver.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class TransitionDriver: UIPercentDrivenInteractiveTransition {

    private weak var presentedController: UIViewController?
    private var panRecognizer: UIPanGestureRecognizer?
    var direction = TTransition.present

    func link(to controller: UIViewController) {
        presentedController = controller
        panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handle(recognizer:)))
        presentedController?.view.addGestureRecognizer(panRecognizer!)
    }

    @objc private func handle(recognizer r: UIPanGestureRecognizer) {
        switch direction {
        case .present: handlePresentation(recognizer: r)
        case .dismiss: handleDismiss(recognizer: r)
        default: return
        }
    }

    override var wantsInteractiveStart: Bool {
        get {
            switch direction {
            case .present: return false
            case .dismiss: return panRecognizer?.state == .began // gestureIsActive
            default: return false
            }
        }
        set {}
    }

    var maxTranslation: CGFloat {
        get { return presentedController?.view.frame.height ?? 0 }
    }

    // pause before call
    var isRunning: Bool {
        get { return percentComplete != 0 }
    }
}

// MARK: Gestures Handle
extension TransitionDriver {

    private func handlePresentation(recognizer r: UIPanGestureRecognizer) {
        func onBegan() {
            pause()
        }

        func onChanged() {
            let increment = -r.incrementToBottom(maxTranslation: maxTranslation)
            update(percentComplete + increment)
        }

        func onEnd() {
            if r.isProjectedToDownHalf(maxTranslation: maxTranslation) {
                cancel()
            }
            else {
                finish()
            }
        }

        func onCancel() {
            cancel()
        }

        switch r.state {
        case .began: onBegan()
        case .changed: onChanged()
        case .ended, .cancelled: onEnd()
        case .failed: onCancel()
        default: break
        }
    }

    private func handleDismiss(recognizer r: UIPanGestureRecognizer) {
        func onBegan() {
            pause() // without pause percentComplete always equal 0
            //            if !isRunning {
            //                presentedController?.dismiss(animated: true, completion: nil)
            //            }
        }

        func onChanged() {
            let increment = r.incrementToBottom(maxTranslation: maxTranslation)
            update(percentComplete + increment)
        }

        func onEnded() {
            if r.isProjectedToDownHalf(maxTranslation: maxTranslation) {
                finish()
            }
            else {
                cancel()
            }
        }

        func onFailed() {
            cancel()
        }

        switch r.state {
        case .began: onBegan()
        case .changed: onChanged()
        case .ended, .cancelled: onEnded()
        case .failed: onFailed()
        default: break
        }
    }
}
