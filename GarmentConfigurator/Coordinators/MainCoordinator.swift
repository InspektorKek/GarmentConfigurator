//
//  MainCoordinator.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 27/02/23.
//

import UIKit

final class MainCoordinator: BaseCoordinator, ARResultSceneDelegate {
    override func start() {
        let scene = GarmentsAssembly(delegate: self).makeScene()
        startingViewController = scene
        router.setRootModule(scene)
    }
}

extension MainCoordinator: GarmentsSceneDelegate {
    func openConfigurator(input: ConfigurationSceneInput) {
        let scene = ConfigurationAssembly(input: input, delegate: self).makeScene()
        router.push(scene, animated: true)
    }
}

extension MainCoordinator: ConfigurationSceneDelegate {
    func openAR(input: GarmentModel) {
        let scene = ARScreenAssembly(model: input, delegate: self).makeScene()
        router.push(scene, animated: true)
    }

    func back() {
        router.popModule(animated: true)
    }
}

extension MainCoordinator: ARScreenSceneDelegate {
    func closeAR() {
        router.popModule(animated: true)
    }
}
