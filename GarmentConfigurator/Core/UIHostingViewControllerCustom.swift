//
//  UIHostingViewControllerCustom.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import SwiftUI

class UIHostingViewControllerCustom<Content>: UIHostingController<Content> where Content: View {
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
}

extension UIViewController {

    /// Add a SwiftUI `View` as a child of the input `UIView`.
    /// - Parameters:
    ///   - swiftUIView: The SwiftUI `View` to add as a child.
    ///   - view: The `UIView` instance to which the view should be added.
    func addSubSwiftUIView<Content>(_ swiftUIView: Content,
                                    to view: UIView,
                                    backgroundColor: UIColor = .white) where Content: View {
        let hostingController = UIHostingViewControllerCustom(rootView: swiftUIView)
        hostingController.view.backgroundColor = backgroundColor

        /// Add as a child of the current view controller.
        addChild(hostingController)

        /// Add the SwiftUI view to the view controller view hierarchy.
        view.addSubview(hostingController.view)

        /// Setup the constraints to update the SwiftUI view boundaries.
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
            view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor)
        ]

        NSLayoutConstraint.activate(constraints)

        /// Notify the hosting controller that it has been moved to the current view controller.
        hostingController.didMove(toParent: self)
    }
}
