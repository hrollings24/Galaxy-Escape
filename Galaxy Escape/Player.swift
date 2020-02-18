//
//  Player.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 03/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import SceneKit

class Player: SCNNode{
    
    private let lookAtForwardPosition = SCNVector3Make(0.0, 1, -20)
    private let cameraFowardPosition = SCNVector3(x: 0.0, y: 1, z: 15)

    private var lookAtNode: SCNNode?
    private var cameraNode: SCNNode?
    
    override init() {
        super.init()

        // Look at Node
        lookAtNode = SCNNode()
        lookAtNode!.position = lookAtForwardPosition
        self.addChildNode(lookAtNode!)
        
        // Camera Node
        cameraNode = SCNNode()
        cameraNode!.camera = SCNCamera()
        cameraNode!.position = cameraFowardPosition
        cameraNode!.camera!.zNear = 0.1
        cameraNode!.camera!.zFar = 200
        self.addChildNode(cameraNode!)

        // Link them
        let constraint1 = SCNLookAtConstraint(target: lookAtNode)
        constraint1.isGimbalLockEnabled = true
        cameraNode!.constraints = [constraint1]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
