//
//  ImageMaterial.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 08/03/23.
//

import Foundation

struct ImageMaterial: Codable, Identifiable, Hashable, Equatable {
    var texture: Data?
    let id: UUID
}
