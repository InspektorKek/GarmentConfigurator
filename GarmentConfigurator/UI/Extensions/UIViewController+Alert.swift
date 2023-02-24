//
//  UIViewController+Alert.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

struct Alert {
    let title: String?
    let message: String?
    let style: UIAlertController.Style
    let actions: [UIAlertAction]
}

protocol Alertable {
    func presentAlert(message: String?, completion: EmptyCompletionHandler?)
    func presentAlert(title: String?,
                      message: String?,
                      defaultButtonTitle: String?,
                      completion: EmptyCompletionHandler?)
    func presentActionSheet(_ actions: [UIAlertAction])
}

extension Alertable where Self: UIViewController {
    func presentAlert(message: String?, completion: (() -> Void)?) {
        presentAlert(title: nil, message: message, completion: completion)
    }

    func presentAlert(title: String?,
                      message: String?,
                      defaultButtonTitle: String? = "ÖK",
                      completion: EmptyCompletionHandler? = nil) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: defaultButtonTitle, style: .default, handler: { _ in
            completion?()
        }))
        present(alertController, animated: true, completion: nil)
    }

    func presentActionSheet(_ actions: [UIAlertAction]) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actions.forEach {
            alert.addAction($0)
        }
        present(alert, animated: true, completion: nil)
    }

    func presentAlert(_ alert: Alert) {
        let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
        alert.actions.forEach {
            alertController.addAction($0)
        }
        present(alertController, animated: true, completion: nil)
    }
}

extension UIViewController: Alertable {}

protocol AlertPresentable {
    func presentAlert(message: String?, completion: EmptyCompletionHandler?)
    func presentAlert(_ alert: Alert)
}

extension AlertPresentable where Self: BaseCoordinator {
    func presentAlert(message: String?, completion: EmptyCompletionHandler? = nil) {
        router.topViewController?.presentAlert(message: message, completion: completion)
    }

    func presentAlert(_ alert: Alert) {
        router.topViewController?.presentAlert(alert)
    }
}
