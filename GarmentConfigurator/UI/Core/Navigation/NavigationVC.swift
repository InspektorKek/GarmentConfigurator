//
//  NavigationVC.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

class NavigationVC: UIViewController {
    let controlsContainer = UIView()
    private let container = UIView()
    private var dividerTopConstraint: NSLayoutConstraint?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = Asset.Colors.baseNavigationColor.color
        view.addSubviews([container])
        container.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(60).priority(.medium)
        }
        container.addSubviews([controlsContainer])
        controlsContainer.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
    }

    func layoutNavigationConstraintsIfNeeded() {
        navigationContainerViewController?.view.layoutIfNeeded()
    }
}

// MARK: - Private Helpers

private extension UIViewController {
    var navigationContainerViewController: NavigationContainerViewController? {
        if let parent = parent as? NavigationContainerViewController {
            return parent
        }
        return parent?.navigationContainerViewController
    }
}
