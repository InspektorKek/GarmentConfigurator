//
//  PatternedScene.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import SceneKit

class PatternedScene {
    let scene: SCNScene
    
    private let patternedNode: PatternedNode
    
    init(scene: SCNScene, patternedNode: PatternedNode) {
        self.scene = scene
        self.patternedNode = patternedNode
    }
    
    convenience init(scene: SCNScene) {
        let patternedNode = PatternedNode(node: scene.rootNode.childNodes.first!)
        self.init(scene: scene, patternedNode: patternedNode)
    }
    
    func applyMaterial(data: Data, to pattern: any Patternable) throws {
        try patternedNode.applyTexture(textureData: data, to: pattern)
    }
}
