//
//  TShirtPattern.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import Foundation

/// An enum that represents a pattern type for a T-shirt.
enum TShirtPattern: String, Codable, CaseIterable {
    private enum Constants {
        static let leftArmName = "Arm-Left"
        static let rightArmName = "Arm-Right"
        static let frontName = "Front"
        static let backName = "Back"
    }
    
    case leftArm
    case rightArm
    case front
    case back
    
    var description: String {
        switch self {
        case .leftArm:
            return L10n.patternTshirtLeftArmTitle
        case .rightArm:
            return L10n.patternTshirtRightArmTitle
        case .front:
            return L10n.patternTshirtFrontTitle
        case .back:
            return L10n.patternTshirtBackTitle
        }
    }
    
    var nodeName: String {
        switch self {
        case .leftArm:
            return Constants.leftArmName
        case .rightArm:
            return Constants.rightArmName
        case .front:
            return Constants.frontName
        case .back:
            return Constants.backName
        }
    }
}
