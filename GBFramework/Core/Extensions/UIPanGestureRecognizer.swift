//
//  UIPanGestureRecognizer.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

extension UIPanGestureRecognizer {

    func incrementToBottom(maxTranslation: CGFloat) -> CGFloat {
        let translation = self.translation(in: view).y
        setTranslation(.zero, in: nil)
        return translation / maxTranslation // percent increment
    }

    func isProjectedToDownHalf(maxTranslation: CGFloat) -> Bool {
        let endLocation = projectedLocation(/*decelerationRate.fast*/)
        return endLocation.y > maxTranslation / 2 // is presentation completed
    }

    func projectedLocation(/*decelerationRate: UIScrollView.DecelerationRate*/) -> CGPoint {
        let velocityOffset = velocity(in: view).projectedOffset(decelerationRate: .normal)
        return location(in: view) + velocityOffset // projected location
    }
}
