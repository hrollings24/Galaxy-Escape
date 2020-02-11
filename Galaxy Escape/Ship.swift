//
//  Ship.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 11/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SceneKit

class Ship: SCNNode{
    
    var shipNode: SCNNode!
    
    override init() {
        super.init()
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        shipNode = scene.rootNode.childNode(withName: "ship", recursively: true)!

        shipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        shipNode.position = SCNVector3(x: 0, y: -5, z: 0)
        shipNode.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi));
        shipNode.physicsBody?.isAffectedByGravity = false
        shipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        shipNode.physicsBody?.categoryBitMask = CollisionCategory.shipCatagory.rawValue
        shipNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        shipNode.physicsBody?.collisionBitMask = 0
        shipNode.physicsBody?.mass = 0
        
        self.addChildNode(shipNode)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
