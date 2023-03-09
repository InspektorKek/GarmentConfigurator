//
//  UIView+Animation.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

extension UIView {
    /// Changes view's alpha to 1.
    func show(animated: Bool,
              duration: TimeInterval = AnimationDuration.microSlow.timeInterval,
              completion: ((Bool) -> Void)? = nil) {
        let withDuration: TimeInterval = animated ? duration : 0
        UIView.animate(withDuration: withDuration, animations: {
            self.alpha = 1
        }, completion: completion)
    }

    /// Changes view's alpha to 0.
    func hide(animated: Bool,
              duration: TimeInterval = AnimationDuration.microSlow.timeInterval,
              completion: ((Bool) -> Void)? = nil) {
        let withDuration: TimeInterval = animated ? duration : 0
        UIView.animate(withDuration: withDuration, animations: {
            self.alpha = 0
        }, completion: completion)
    }
}

enum AnimationDuration: TimeInterval {
    /// 0.1 sec
    case microFast = 0.1
    /// 0.2 sec
    case microRegular = 0.2
    /// 0.3 sec
    case microSlow = 0.3

    /// 0.4 sec
    case macroFast = 0.4
    /// 0.5 sec
    /// default animation duration
    case macroRegular = 0.5
    /// 0.6 sec
    case macroSlow = 0.6

    var timeInterval: TimeInterval { rawValue }
}
