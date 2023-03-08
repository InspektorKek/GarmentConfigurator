//
//  TShirtPatternInfo.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import Foundation

/// A struct that represents a pattern for a T-shirt.
struct TShirtPatternInfo: Patternable {
    let type: TShirtPattern
    let id: UUID
    
    var textureMaterial: ImageMaterial?
    var scale: Float = 0
    var rotation: Float = 0
    
    var name: String { type.name }
    
    static func `default`(_ type: TShirtPattern) -> Self {
        .init(type: type, id: UUID())
    }
}
