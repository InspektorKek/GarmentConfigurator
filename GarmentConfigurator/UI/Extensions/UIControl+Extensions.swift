//
//  UIControl+Extensions.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

extension UIControl {
    func removeAllActions() {
        self.enumerateEventHandlers { action, targetAction, event, stop in
            if let action = action {
                self.removeAction(action, for: event)
            }
            if let (target, selector) = targetAction {
                self.removeTarget(target, action: selector, for: event)
            }
            stop = true
        }
    }

    func addAction(for controlEvents: UIControl.Event = .touchUpInside,
                   _ completionHandler: @escaping EmptyCompletionHandler) {
        let action = UIAction { (_: UIAction) in
            completionHandler()
        }
        addAction(action, for: controlEvents)
    }
}
