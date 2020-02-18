//
//  Meteor.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 11/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SceneKit
import SceneKit.ModelIO


class Meteor: SCNNode{
    
    var meteorNode: SCNNode!
       
    override init() {
       super.init()
       
        let meteorScene = SCNScene(named: "art.scnassets/rock.dae")!
        meteorNode = meteorScene.rootNode.childNode(withName: "meteor", recursively: true)!
            
        let scaleFactor = Float.random(in: 0.005..<0.03)
        meteorNode.scale = SCNVector3(x: scaleFactor, y: scaleFactor, z: scaleFactor)
 
        
        meteorNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        meteorNode.physicsBody?.isAffectedByGravity = false
        meteorNode.physicsBody?.categoryBitMask = CollisionCategory.meteorCategory.rawValue
        meteorNode.physicsBody?.contactTestBitMask = CollisionCategory.laserCategory.rawValue | CollisionCategory.shipCatagory.rawValue
        meteorNode.name = "meteor"
        meteorNode.physicsBody?.collisionBitMask = 0

        
        self.addChildNode(meteorNode)
    }

    required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
}
