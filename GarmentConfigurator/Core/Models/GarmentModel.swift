//
//  GarmentModel.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import Foundation

/// A model for a garment with patterns.
class GarmentModel: Identifiable {
    let id: UUID
    let name: String
    let bodyType: BodyType
    
    var type: GarmentType
    var patterns: [TShirtPatternInfo]
    
    var sceneName: String { "SceneCatalog.scnassets/Configurator-\(bodyType.name).scn" }
    
    init(type: GarmentType, id: UUID = UUID(), name: String, bodyType: BodyType) {
        self.type = type
        self.patterns = Self.patterns(by: type)
        self.id = id
        self.name = name
        self.bodyType = bodyType
    }
    
    func update(pattern: TShirtPatternInfo, with material: ImageMaterial) {
        guard let patternIndex = patterns.firstIndex(where: { $0.type == pattern.type }) else { return }
        
        patterns[patternIndex].textureMaterial = material
    }
    
    func updateRotation(value: Float, for pattern: TShirtPatternInfo) {
        guard let patternIndex = patterns.firstIndex(where: { $0.type == pattern.type }) else { return }
        
        patterns[patternIndex].rotation = value
    }
    
    func updateScale(value: Float, for pattern: TShirtPatternInfo) {
        guard let patternIndex = patterns.firstIndex(where: { $0.type == pattern.type }) else { return }
        
        patterns[patternIndex].scale = value
    }
    
    private static func patterns(by type: GarmentType) -> [TShirtPatternInfo] {
        switch type {
        case .tShirt:
            return TShirtPattern.allCases.map { TShirtPatternInfo.default($0) }
        }
    }
}

extension GarmentModel: Hashable {
    static func == (lhs: GarmentModel, rhs: GarmentModel) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
