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
    
    private var shipNode: SCNNode!
    var shipConstraint: SCNNode!
    
    override init() {
        super.init()
        
        shipConstraint = SCNNode()
        shipConstraint.position = SCNVector3(0, 0, -5)
        
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        shipNode = scene.rootNode.childNode(withName: "ship", recursively: true)!

        shipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        shipNode.position = SCNVector3(0, 0, 0)


        //shipNode.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi));
        shipNode.physicsBody?.isAffectedByGravity = false
        shipNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        shipNode.physicsBody?.categoryBitMask = CollisionCategory.shipCatagory.rawValue
        shipNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        shipNode.physicsBody?.collisionBitMask = 0
        shipNode.physicsBody?.mass = 0


        
        let constraint1 = SCNLookAtConstraint(target: shipConstraint)
        constraint1.isGimbalLockEnabled = true
        shipNode!.constraints = [constraint1]
        
        self.addChildNode(shipNode)
        self.addChildNode(shipConstraint)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
