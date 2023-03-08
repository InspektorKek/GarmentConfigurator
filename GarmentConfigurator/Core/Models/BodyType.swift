//
//  BodyType.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

// Enum representing the body type of a garment.
enum BodyType: String, Codable {
    case male
    case female
    
    var name: String { rawValue.capitalized }
}
