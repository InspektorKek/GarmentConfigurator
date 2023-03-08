//
//  UIApplication+Extension.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 08/03/23.
//

import UIKit

extension UIApplication {
    var keyWindow: UIWindow? {
        UIApplication
            .shared
            .connectedScenes
            .filter({ $0.activationState == .foregroundActive })
            .compactMap({ $0 as? UIWindowScene })
            .first?.windows
            .first(where: \.isKeyWindow)
    }
}
