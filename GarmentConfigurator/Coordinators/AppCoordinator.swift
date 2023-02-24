//
//  AppCoordinator.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit
import Resolver

final class AppCoordinator: BaseCoordinator {

    private var window: UIWindow

    init(window: UIWindow) {
        let navigationController = BaseNavigationController()
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        super.init(router: Router(rootController: navigationController))
    }

    override func start() {
        router.setRootModule(SplashScreenAssembly(delegate: self).makeScene())
    }
}

extension AppCoordinator: SplashScreenSceneDelegate {
    func startMainFlow() {

    }
}
