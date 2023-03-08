//
//  MaterialsService.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import UIKit

protocol MaterialManagingProtocol {
    func retrieveSavedMaterials() -> [ImageMaterial]
    func addNew(_ material: ImageMaterial)
}

struct ImageMaterial: Codable, Identifiable, Hashable, Equatable {
    var texture: Data?
    let id: UUID
}

final class ImageDataMaterialsService: MaterialManagingProtocol {
    func retrieveSavedMaterials() -> [ImageMaterial] {
        return [
            .init(texture: UIImage(named: "AppIcon")!.pngData(), id: UUID()),
            .init(texture: UIImage(named: "First")!.pngData(), id: UUID()),
            .init(texture: UIImage(named: "Second")!.pngData(), id: UUID()),
            .init(texture: UIImage(named: "Third")!.pngData(), id: UUID())
        ]
    }
    
    func addNew(_ material: ImageMaterial) {
        #warning("Cache new material")
    }
}
