//
//  LaunchVC.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 16.06.2022.
//

import UIKit

class LaunchVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        launch()

        func launch() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.performSegue(withIdentifier: TSegue.map, sender: nil)
            }
        }
    }
}
