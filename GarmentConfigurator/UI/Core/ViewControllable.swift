//
//  ViewControllable.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

protocol ViewControllable {
    func hideBackButtonTitle()
    func hideNavigationBar(animated: Bool)
    func showNavigationBar(animated: Bool)
    func setLargeNavigationTitle(_ title: String)
    func setRegularNavigationTitle(_ title: String)
    func setLargeNavigationTitle(_ title: String, animated: Bool)
    func setRegularNavigationTitle(_ title: String, animated: Bool)
}

extension UIViewController: ViewControllable {}

extension ViewControllable where Self: UIViewController {
    func hideBackButtonTitle() {
        navigationItem.backButtonDisplayMode = .minimal
    }

    func hideNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    func showNavigationBar(animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func setLargeNavigationTitle(_ title: String) {
        setLargeNavigationTitle(title, animated: false)
    }

    func setRegularNavigationTitle(_ title: String) {
        setRegularNavigationTitle(title, animated: false)
    }

    func setLargeNavigationTitle(_ title: String, animated: Bool) {
        setNavigationTitle(title,
                           titleTextAttributes: NavigationBarTextAttributes().getLargeTextAttributes(),
                           animated: animated)
    }

    func setRegularNavigationTitle(_ title: String, animated: Bool) {
        setNavigationTitle(title,
                           titleTextAttributes: NavigationBarTextAttributes().getRegularTextAttributes(),
                           animated: animated)
    }

    private func setNavigationTitle(_ title: String, titleTextAttributes: TitleTextAttributes, animated: Bool) {
        let appearance = navigationController?.navigationBar.standardAppearance
        appearance?.titleTextAttributes = titleTextAttributes
        if let appearance = appearance {
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        guard animated else {
            navigationItem.title = title
            return
        }
        guard title != navigationItem.title else {
            return
        }
        let fadeTransition = CATransition()
        fadeTransition.duration = AnimationDuration.microSlow.timeInterval
        fadeTransition.type = .fade
        navigationController?.navigationBar.layer.add(fadeTransition, forKey: "fadeTransition")
        navigationItem.title = title
    }
}

typealias TitleTextAttributes = [NSAttributedString.Key: Any]

struct NavigationBarTextAttributes {
    func getLargeTextAttributes() -> TitleTextAttributes {
        return [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
            NSAttributedString.Key.foregroundColor: Asset.Colors.labelsPrimary.color
        ]
    }

    func getRegularTextAttributes() -> TitleTextAttributes {
        return [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold),
            NSAttributedString.Key.foregroundColor: Asset.Colors.labelsPrimary.color
        ]
    }
}

extension UIViewController {
    func setTransparentNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }

    func setOpaqueNavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
}
