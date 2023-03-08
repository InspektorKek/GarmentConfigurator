//
//  BaseCoordinator.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit
import SafariServices

protocol SceneAssembly {
    func makeScene() -> UIViewController
}

protocol Coordinator: AnyObject {
    var startingViewController: UIViewController? { get }
    var parent: Coordinator? { get }
    var children: [Coordinator] { get }

    func add(_ child: Coordinator)
    func remove(_ child: Coordinator)
    func start()
}

class BaseCoordinator: NSObject, Coordinator {
    let router: Router
    var children: [Coordinator] = []

    weak var startingViewController: UIViewController?
    weak var parent: Coordinator?

    init(router: Router) {
        self.router = router
        super.init()
    }

    deinit {
        children.removeAll()
    }

    func start() {
        fatalError("This function must be override")
    }

    // MARK: in case if we would need to open safari inside app
//    func openURL(_ url: URL) {
//        let config = SFSafariViewController.Configuration()
//        config.barCollapsingEnabled = false
//        let destination = SFSafariViewController(
//            url: url,
//            configuration: config
//        )
//        destination.modalPresentationStyle = .popover
//        router.present(destination, animated: true)
//    }

    final func add(_ child: Coordinator) {
        for element in children where child === element { return }
        children.append(child)
    }

    final func remove(_ child: Coordinator) {
        guard !children.isEmpty else { return }
        for (index, element) in children.enumerated() where element === child {
            children.remove(at: index)
            break
        }
    }
}
