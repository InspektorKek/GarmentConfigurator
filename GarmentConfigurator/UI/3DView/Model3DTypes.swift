//
//  Model3DTypes.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 28/02/23.
//

import GLTFSceneKit
import SceneKit
import SwiftUI

typealias PlatformImage = UIImage
typealias ViewRepresentable = UIViewRepresentable

typealias IBLValues = (url: URL, intensity: Double)

enum ModelLoadState {
    case success
    case failure
}

/// An internal type to help diffing the passed scene/file to `Model3DView`.
enum SceneFileType: Equatable {
    case reference(SCNScene)
    case url(URL?)

    static func == (lhs: SceneFileType, rhs: SceneFileType) -> Bool {
        if case .url(let l) = lhs, case .url(let r) = rhs {
            return l == r
        } else if case .reference(let l) = lhs, case .reference(let r) = rhs {
            return l == r
        }
        return false
    }
}
