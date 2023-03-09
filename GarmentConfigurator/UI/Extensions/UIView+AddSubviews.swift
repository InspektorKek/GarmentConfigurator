//
//  UIView+AddSubviews.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 24/02/23.
//

import UIKit

extension UIView {
    func addSubviewsWithoutAutoresizing(_ subviews: UIView...) {
        addSubviewsWithoutAutoresizing(subviews)
    }

    func addSubviewsWithoutAutoresizing(_ subviews: [UIView]) {
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }

    func addSubviews(_ subviews: [UIView]) {
        subviews.forEach {
            addSubview($0)
        }
    }

    func addSubviews(_ subviews: UIView...) {
        addSubviews(subviews)
    }
}

extension UIView {
    /* This helper method tries to find a subview of the given class. It returns
       the first view found, or nil if none are found. */
    func findSubview(ofType theClass: AnyClass) -> UIView? {
        for subview in self.subviews where subview.isKind(of: theClass) {
            return subview
        }
        return nil
    }

    /* This helper method tries to find all subviews of the given class. It
       returns an array of views, which is empty if none are found. */
    func findSubviews(ofType theClass: AnyClass) -> [UIView] {
        var foundViews = [UIView]()
        for subview in subviews where subview.isKind(of: theClass) {
            foundViews.append(subview)
        }
        return foundViews
    }
}
