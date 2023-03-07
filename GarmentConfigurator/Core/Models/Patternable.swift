//
//  Patternable.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import Foundation

/// A protocol for patterns.
protocol Patternable: Codable, Identifiable, Hashable {
    var name: String { get }
    var textureData: Data? { get set }
    var scale: Float { get set }
    var rotation: Float { get set }
}
