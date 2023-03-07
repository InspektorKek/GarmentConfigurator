//
//  GarmentModel.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import Foundation

/// A model for a garment with patterns.
class GarmentModel {
    let id: UUID
    let name: String
    let bodyType: BodyType
    
    var type: GarmentType
    var patterns: [TShirtPatternInfo]
    
    init(type: GarmentType, id: UUID = UUID(), name: String, bodyType: BodyType) {
        self.type = type
        self.patterns = Self.patterns(by: type)
        self.id = id
        self.name = name
        self.bodyType = bodyType
    }
    
    func update(pattern: TShirtPatternInfo, with textureData: Data) {
        guard let patternIndex = patterns.firstIndex(where: { $0.id == pattern.id }) else { return }

        patterns[patternIndex].textureData = textureData
    }
    
    private static func patterns(by type: GarmentType) -> [TShirtPatternInfo] {
        switch type {
        case .tShirt:
            return TShirtPattern.allCases.map { TShirtPatternInfo.default($0) }
        }
    }
}
