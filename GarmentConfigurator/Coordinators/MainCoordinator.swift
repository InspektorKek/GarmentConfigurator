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
        router.setRootModule(scene)
    }
    
    func openARScreen(model: GarmentModel) {
        let scene = ARScreenAssembly(model: model, delegate: self).makeScene()
        router.present(scene, animated: true)
    }
}

extension MainCoordinator: GarmentsSceneDelegate {
    func openConfigurator(input: ConfigurationSceneInput) {
        let scene = ConfigurationAssembly(input: input, delegate: self).makeScene()
        router.push(scene, animated: true)
    }
}

extension MainCoordinator: ARScreenSceneDelegate {
    func openARResult() {
        let scene = ARResultAssembly(delegate: self).makeScene()
        router.present(scene, animated: true)
    }
}

extension MainCoordinator: ConfigurationSceneDelegate {
    func openAR(input: GarmentModel) {
        openARScreen(model: input)
    }
    
    func back() {
        router.popModule(animated: true)
    }
}
