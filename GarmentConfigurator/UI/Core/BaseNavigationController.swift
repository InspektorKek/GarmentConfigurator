//
//  BaseNavigationController.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit
import Resolver

final class BaseNavigationController: UINavigationController {

    @Injected var notificationCenter: NotificationCenterProtocol

    var navigationBarBackgroundColor = Asset.Colors.backgroundPrimary.color
    var navigationBarTintColor = Asset.Colors.labelsPrimary.color

    override func viewDidLoad() {
        super.viewDidLoad()
        makeNotTranslucent()
        updateNavigationBarAppearance()
        removeNavigationBarShadow()
        delegate = self
        interactivePopGestureRecognizer?.delegate = self
    }

    func handlePoppedViewControllerIfNeeded(_ navigationController: UINavigationController) {
        if let coordinator = navigationController.topViewController?.transitionCoordinator {
            if let fromViewController = coordinator.viewController(forKey: .from),
               !navigationController.viewControllers.contains(fromViewController) {
                // viewController is going to be popped
                if coordinator.isInteractive {
                    // if viewController is going to be poppoed via back swipe
                    // we must wait until transition is finished, to make sure that
                    // it isn't cancelled.
                    coordinator.notifyWhenInteractionChanges { [weak self] context in
                        if !context.isCancelled {
                            // handle pop event for viewController
                            self?.postNotificationThatViewControllerWasPopped()
                        }
                    }
                } else {
                    // viewController is popped after user taps back button
                    // we handle pop event immediately
                    postNotificationThatViewControllerWasPopped()
                }
            }
        }
    }

    private func postNotificationThatViewControllerWasPopped() {
        notificationCenter.post(name: NotificationCenter.NotificationName.didPerformPopViewController)
    }

    func makeNotTranslucent() {
        navigationBar.isTranslucent = false
    }

    func removeNavigationBarShadow() {
        navigationBar.scrollEdgeAppearance?.shadowColor = .clear
    }

    private func updateNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = navigationBarBackgroundColor
        navigationBar.standardAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = navigationBarTintColor
    }
}

extension BaseNavigationController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        handlePoppedViewControllerIfNeeded(navigationController)
    }
}

extension BaseNavigationController: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        viewControllers.count > 1
    }
}
