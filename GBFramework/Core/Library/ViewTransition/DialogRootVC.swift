//
//  DialogRootVC.swift
//  GBFramework
//
//  Created by Andrey Rachitskiy on 22.06.2022.
//

import UIKit

class DialogRootVC: UIViewController {
    
    weak var delegate: UIWindow?
    var transition = PanelTransition()
    var needDarkness = true {
        didSet {
            transition.needDarkness = needDarkness
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
    }
}
