//
//  MaterialsService.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import UIKit
import Combine

protocol MaterialManagingProtocol {
    var materials: Published<[ImageMaterial]>.Publisher { get }
    func addNew(_ material: ImageMaterial)
}

extension MaterialManagingProtocol {
    static func retrieveSavedMaterials() -> [ImageMaterial] {
        AppData.imageMaterialIDs
            .compactMap { id -> ImageMaterial? in
                do {
                    let material = try FilesManager.shared.read(fileNamed: id)
                    return ImageMaterial(texture: material, id: UUID(uuidString: id)!)
                } catch {
                    return nil
                }
            }
    }
}

final class ImageDataMaterialsService: MaterialManagingProtocol {
    var materials: Published<[ImageMaterial]>.Publisher { $sourceMaterials }
    
    @Published private var sourceMaterials: [ImageMaterial]
    
    private var subscriptions = Set<AnyCancellable>()
    
    init() {
        sourceMaterials = Self.retrieveSavedMaterials()
        bind()
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
    
    func addNew(_ material: ImageMaterial) {
        sourceMaterials.insert(material, at: 0)
    }
    
    private func bind() {
        $sourceMaterials
            .receive(on: DispatchQueue.global(qos: .background))
            .sink { materials in
                guard !materials.isEmpty else { return }
                
                materials.forEach {
                    do {
                        try FilesManager.shared.save(fileNamed: $0.id.uuidString, data: $0.texture!)
                    } catch {
                        print(error)
                    }
                }
                AppData.imageMaterialIDs = materials.map { $0.id.uuidString }
            }
            .store(in: &subscriptions)
    }
}
