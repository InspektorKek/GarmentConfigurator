//
//  NavigationContainerViewController.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit
import SnapKit

final class NavigationContainerViewController: UIViewController {
    private let navigationViewController: UIViewController
    private let contentViewController: UIViewController

    init(navigationViewController: UIViewController, contentViewController: UIViewController) {
        self.navigationViewController = navigationViewController
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        add(navigationViewController)
        view.addSubview(navigationViewController.view)
        navigationViewController.view.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(44.5).priority(.low)
        }

        add(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.view.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(navigationViewController.view.snp.bottom)
        }
    }
}

extension UIViewController {
    func withCustom(navigationViewController: UIViewController) -> UIViewController {
        NavigationContainerViewController(
            navigationViewController: navigationViewController,
            contentViewController: self
        )
    }

    func withCustom(navigationTitle: String, backButtonDelegate: BackNavigator) -> UIViewController {
        let navigationViewController = BackButtonAndTitleNavigationVC(navigationTitle: navigationTitle,
                                                                      backButtonDelegate: backButtonDelegate)
        return NavigationContainerViewController(
            navigationViewController: navigationViewController,
            contentViewController: self
        )
    }
}

protocol BackNavigator: AnyObject {
    func back()
}

protocol BackToRootNavigator: AnyObject {
    func backToRoot(animated: Bool)
    func backToRoot()
}

extension BackToRootNavigator where Self: BaseCoordinator {
    func backToRoot() {
        backToRoot(animated: true)
    }

    func backToRoot(animated: Bool) {
        router.popToRootModule(animated: animated)
    }
}
