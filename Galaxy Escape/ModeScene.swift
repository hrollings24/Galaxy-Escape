//
//  ModeScene.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 03/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import SpriteKit
import SceneKit
import UIKit

class Modes: SCNScene{
    
    var gameVC: UIViewController!
    private let lookAtForwardPosition = SCNVector3Make(0.0, 1, 0)
    private let cameraFowardPosition = SCNVector3(x: 0.0, y: 1, z: 15)

    private var lookAtNode: SCNNode?
    private var cameraNode: SCNNode?
    
    init(gameViewController: GameViewController){
         super.init()

         gameVC = gameViewController
            
         setupScene()
     }
     
     required init(coder aDecoder: NSCoder) {
         super.init(coder: aDecoder)!
     }
    
    func setupScene(){
        
        self.background.contents = [UIImage(named: "skybox3_left"),
            UIImage(named: "skybox3_right"),
            UIImage(named: "skybox3_up"),
            UIImage(named: "skybox3_down"),
            UIImage(named: "skybox3_back"),
            UIImage(named: "skybox3_front")]
        
        setupCamera()
        addPlanets()
        
    }
    
    func setupCamera(){
        // Look at Node
        lookAtNode = SCNNode()
        lookAtNode!.position = lookAtForwardPosition
        self.rootNode.addChildNode(lookAtNode!)

        // Camera Node
        cameraNode = SCNNode()
        cameraNode!.camera = SCNCamera()
        cameraNode!.position = cameraFowardPosition
        cameraNode!.camera!.zNear = 0.1
        cameraNode!.camera!.zFar = 200
        self.rootNode.addChildNode(cameraNode!)

        // Link them
        let constraint1 = SCNLookAtConstraint(target: lookAtNode)
        constraint1.isGimbalLockEnabled = true
        cameraNode!.constraints = [constraint1]
    }
    
    func addPlanets(){
        //Earth
        let earthScene = SCNScene(named: "art.scnassets/earth.scn")!
        let earthNode = earthScene.rootNode.childNode(withName: "earth", recursively: true)!
        let earthAction = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0.1, 1, 0), duration: 10))
        earthNode.runAction(earthAction)
        
        earthNode.position = SCNVector3(x: -12, y: 5, z: 0)
        self.rootNode.addChildNode(earthNode)
        
        //Mars
        let marsScene = SCNScene(named: "art.scnassets/earth.scn")!
        let marsNode = marsScene.rootNode.childNode(withName: "earth", recursively: true)!
        let marsAction = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(0.1, -1, 0), duration: 12))
        marsNode.runAction(marsAction)
        
        marsNode.position = SCNVector3(x: 0, y: -1, z: 0)
        self.rootNode.addChildNode(marsNode)
        
        //Jupiter
        let jupiterScene = SCNScene(named: "art.scnassets/earth.scn")!
        let jupiterNode = jupiterScene.rootNode.childNode(withName: "earth", recursively: true)!
        let jupiterAction = SCNAction.repeatForever(SCNAction.rotate(by: .pi, around: SCNVector3(-0.2, -1.1, 0), duration: 12))
        jupiterNode.runAction(jupiterAction)
        
        jupiterNode.position = SCNVector3(x: 12, y: 4, z: 0)
        self.rootNode.addChildNode(jupiterNode)
    }
    
}
