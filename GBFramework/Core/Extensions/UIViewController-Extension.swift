//
//  UIViewController-Extension.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 18.06.2022.
//

import UIKit

extension UIViewController {

    func canPerformSegue(withIdentifier id: String) -> Bool {
        guard let segues = self.value(forKey: "storyboardSegueTemplates") as? [NSObject] else { return false }
        return segues.firstIndex { $0.value(forKey: "identifier") as? String == id } != nil
    }

    // Performs segue with passed identifier, if self can perform it.
    func performSegueIfPossible(withIdentifier id: String, sender: AnyObject? = nil) {
        guard canPerformSegue(withIdentifier: id) else { return }
        self.performSegue(withIdentifier: id, sender: sender)
    }
}
