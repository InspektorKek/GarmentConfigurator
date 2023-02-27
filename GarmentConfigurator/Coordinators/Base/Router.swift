//
//  Router.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

final class Router {
    var topViewController: UIViewController? { rootController?.topViewController }

    var root: BaseNavigationController? { rootController }

    private var rootController: BaseNavigationController?

    required init(rootController: BaseNavigationController = .init()) {
        self.rootController = rootController
    }

    func present(_ module: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        rootController?.present(module, animated: animated, completion: completion)
    }

    func push(_ module: UIViewController, animated: Bool) {
        guard
            !(module is UINavigationController)
        else {
            assertionFailure("⚠️Deprecated push UINavigationController.")
            return
        }
        rootController?.hideBottomBarAndPush(controller: module, animated: animated)
    }

    func popModule(animated: Bool) {
        rootController?.popViewController(animated: animated)
    }

    func popTo(controllerIndex: Int, animated: Bool) {
        guard let root = rootController else { return }
        let destination = root.viewControllers[controllerIndex]
        rootController?.popToViewController(destination, animated: animated)
    }

    func dismissModule(animated: Bool) {
        rootController?.dismiss(animated: animated, completion: nil)
    }

    func disableNavigationSlide() {
        rootController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    func setRootModule(_ module: UIViewController, hideBar: Bool = false, animated: Bool = false) {
        rootController?.setViewControllers([module], animated: animated)
        rootController?.isNavigationBarHidden = hideBar
    }

    func popToRootModule(animated: Bool) {
        rootController?.popToRootViewController(animated: animated)
    }

    func select(tab withIndex: Int) {
        rootController?.tabBarController?.selectedIndex = withIndex
    }

    func hideTabBar(hideTabBar: Bool) {
        rootController?.tabBarController?.tabBar.isHidden = hideTabBar
    }

    func set(controllers: [UIViewController]) {
        rootController?.setViewControllers(controllers, animated: false)
    }

    func add(controllers: [UIViewController]) {
        var currentStack = rootController?.viewControllers ?? []
        currentStack.append(contentsOf: controllers)
        rootController?.setViewControllers(currentStack, animated: false)
    }

    func pop(to viewController: AnyClass, animated: Bool) {
        guard let index = root?.getIndex(of: viewController) else { return }
        popTo(controllerIndex: index, animated: animated)
    }
}

private extension UINavigationController {
    func getIndex(of viewController: AnyClass) -> Int? {
        viewControllers.firstIndex(where: { $0.isKind(of: viewController) })
    }

    func hideBottomBarAndPush(controller: UIViewController, animated: Bool) {
        controller.hidesBottomBarWhenPushed = true
        pushViewController(controller, animated: animated)
    }
}
