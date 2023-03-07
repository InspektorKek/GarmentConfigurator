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

struct ImageMaterial: Identifiable {
    var texture: Data?
    let id = UUID()
    
    static let `default` = ImageMaterial(texture: nil)
}

final class ImageDataMaterialsService: MaterialManagingProtocol {
    func retrieveSavedMaterials() -> [ImageMaterial] {
        return [
            .init(texture: UIImage(named: "AppIcon")!.pngData()),
            .init(texture: UIImage(named: "First")!.pngData()),
            .init(texture: UIImage(named: "Second")!.pngData()),
            .init(texture: UIImage(named: "Third")!.pngData())
        ]
    }
    
    func addNew(_ material: ImageMaterial) {
        #warning("Cache new material")
    }
}
