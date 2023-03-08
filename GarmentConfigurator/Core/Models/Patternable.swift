//
//  Patternable.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import Foundation

/// A protocol for patterns.
protocol Patternable: Codable, Identifiable, Hashable, Equatable {
    var name: String { get }
    var textureMaterial: ImageMaterial? { get set }
    var scale: Float { get set }
    var rotation: Float { get set }
}
