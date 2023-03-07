//
//  PatternNode.swift
//  GarmentConfigurator
//
//  Created by Mikhail Borisov on 07/03/23.
//

import SceneKit

class PatternedNode {
    let node: SCNNode
    
    init(node: SCNNode) {
        self.node = node
    }
    
    func applyTexture(textureData: Data, to pattern: any Patternable) throws {
        guard let patternNode = node.childNode(withName: pattern.name, recursively: true),
              let geometryNode = patternNode.childNode(withName: "Geometry", recursively: true),
              let material = geometryNode.geometry?.firstMaterial else {
            throw PatternedNodeError.invalidPattern
        }
        
        material.diffuse.contents = textureData
        
        let (min, max) = geometryNode.boundingBox
        let width = CGFloat(max.x - min.x)
        let height = CGFloat(max.y - min.y)
        material.diffuse.contentsTransform = SCNMatrix4MakeScale(Float(width), Float(height), 1)
        material.diffuse.wrapS = .repeat
        material.diffuse.wrapT = .repeat
    }
}

enum PatternedNodeError: Error {
    case invalidPattern
}
