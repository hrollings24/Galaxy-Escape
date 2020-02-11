//
//  Meteor.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 11/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SceneKit

class Meteor: SCNNode{
    
    var meteorNode: SCNNode!
       
       override init() {
           super.init()
           
            let meteorScene = SCNScene(named: "art.scnassets/meteor.scn")!
            meteorNode = meteorScene.rootNode.childNode(withName: "meteor", recursively: true)!
        
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
