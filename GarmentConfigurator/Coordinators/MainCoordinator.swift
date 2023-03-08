//
//  MainCoordinator.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 27/02/23.
//

import UIKit

 final class MainCoordinator: BaseCoordinator {
    override func start() {
        let scene = GarmentsAssembly(delegate: self).makeScene()
        router.setRootModule(scene)
    }
 }

 extension MainCoordinator: GarmentsSceneDelegate {
    func openConfigurator() {
        let scene = ConfigurationAssembly(delegate: self).makeScene()
        router.push(scene, animated: true)
    }
 }
//
// extension MainCoordinator: GarmentsSceneDelegate, ARScreenSceneDelegate {
//    func openConfigurator() {
//        let scene = ARScreenAssembly(delegate: self).makeScene()
//        router.push(scene, animated: true)
//    }
// }

// extension MainCoordinator: ARScreenSceneDelegate {
//    func openARResult() {
//        let scene = ARResultAssembly(delegate: self).makeScene()
//        router.present(scene, animated: true)
//    }
// }

extension MainCoordinator: ConfigurationSceneDelegate {
    func back() {
        router.popModule(animated: true)
    }
}
