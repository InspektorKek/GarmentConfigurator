//
//  BaseViewController.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        hideBackButtonTitle()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(#function) at \(self)")
    }

    deinit {
        print("\(self) was deinitted.")
    }
}
