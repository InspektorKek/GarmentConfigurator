//
//  NotificationCenter.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import Foundation

protocol NotificationCenterProtocol {
    func post(name: NSNotification.Name)
    func post(name: NSNotification.Name, object: Any?)
    func post(name: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]?)
    func addObserver(_ observer: Any,
                     selector aSelector: Selector,
                     name aName: Notification.Name?,
                     object anObject: Any?)
    func removeObserver(_ observer: Any)
}

extension NotificationCenter: NotificationCenterProtocol {
    func post(name: NSNotification.Name) {
        post(name: name, object: nil)
    }
}

extension NotificationCenter {
    enum NotificationName {
        static let didPerformPopViewController = NSNotification.Name(rawValue: "didPerformPopViewController")
    }
}
