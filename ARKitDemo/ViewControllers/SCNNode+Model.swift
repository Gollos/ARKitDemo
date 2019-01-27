//
//  ARModelNode.swift
//  ARKitDemo
//
//  Created by Golos on 1/27/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import Foundation
import SceneKit

extension SCNNode {
    
    static func create(with modelName: String) -> SCNNode? {
        guard let modelScene = SCNScene(named: "art.scnassets/\(modelName).DAE") else { return nil }
        
        let model = modelScene.rootNode
        
        let boxSide: CGFloat = 0.1
        let box = SCNBox(width: boxSide,
                         height: boxSide,
                         length: boxSide,
                         chamferRadius: 0)

        model.geometry = box

        let shape = SCNPhysicsShape(geometry: box, options: nil)

        model.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        model.physicsBody?.isAffectedByGravity = false

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.clear
        model.geometry?.materials = [material]
        
        return model
    }
}
