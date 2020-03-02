//
//  Meteor.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 02/03/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SceneKit

class Meteor: SCNNode{
    
    var distanceToShip: Float!
    
    override init(){
        
        super.init()
        
        let meteorScene = SCNScene(named: "art.scnassets/ar2.dae")!
        let node = meteorScene.rootNode.childNode(withName: "meteor", recursively: true)!
        let scaleFactor = Float.random(in: 0.01..<0.03)
        node.scale = SCNVector3(x: scaleFactor, y: scaleFactor, z: scaleFactor)
        node.name = "meteor"
        distanceToShip = 1000
        self.addChildNode(node)
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateDistance(newDistance: Float){
        distanceToShip = newDistance
    }
    
}
