//
//  ChildViewControllerViewInterface.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

protocol ChildViewControllerViewInterface {
    func addChildViewController(_ controller: UIViewController, shouldAddView: Bool)
    func getChildViewController<T>(of type: T.Type) -> T?
}

extension ChildViewControllerViewInterface where Self: BaseViewController {
    func addChildViewController(_ controller: UIViewController, shouldAddView: Bool) {
        add(controller, shouldAddView: shouldAddView)
    }

    func getChildViewController<T>(of type: T.Type) -> T? {
        children.compactMap { $0 as? T }.first
    }
}

extension UIViewController {
    func add(_ child: UIViewController, shouldAddView: Bool = false) {
        addChild(child)
        if shouldAddView {
            view.addSubview(child.view)
        }
        child.didMove(toParent: self)
    }

    func remove(shouldRemoveView: Bool = false) {
        // Just to be safe, we check that this view controller
        // is actually added to a parent before removing it.
        guard parent != nil else {
            return
        }
        willMove(toParent: nil)
        if shouldRemoveView {
            view.removeFromSuperview()
        }
        removeFromParent()
    }
}
