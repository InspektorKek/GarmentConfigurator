//
//  Garmentable.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import Foundation

/// A protocol for garments that can have patterns.
protocol Garmentable: AnyObject, Codable, Identifiable, Equatable {
    var type: GarmentType { get }
    var bodyType: BodyType { get }
    var name: String { get }
}
