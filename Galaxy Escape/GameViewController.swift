//
//  GameViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 18/11/2019.
//  Copyright © 2019 Harry Rollings. All rights reserved.
//

import UIKit
import SceneKit

class GameViewController: UIViewController {

    var scnView: SCNView!
    var scnScene: SCNScene!
    var cameraNode: SCNNode!
    
    var timer = Timer()



    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupScene()
        setupCamera()
        addSpaceship()
        scheduledTimerWithTimeInterval()

        
    }
    
 
    override var shouldAutorotate: Bool {
        return true
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setupView() {
        scnView = self.view as? SCNView
        
        scnView.autoenablesDefaultLighting = true
    }
    
    func setupScene() {
      scnScene = SCNScene()
      scnView.scene = scnScene
        
      scnScene.background.contents = "Comet Clash Background.png"
    }
    
    func setupCamera() {
      // 1
      cameraNode = SCNNode()
      // 2
      cameraNode.camera = SCNCamera()
      // 3
      cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
      // 4
      scnScene.rootNode.addChildNode(cameraNode)
    }
    
    func spawnShape() {
        // 1
        var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
        default:
        // 3
        geometry = SCNBox(width: 1.0, height: 1.0, length: 1.0,
          chamferRadius: 0.0)
        }
        // 4
        let geometryNode = SCNNode(geometry: geometry)
        // 5
        geometryNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        geometryNode.physicsBody?.isAffectedByGravity = false
        // 1
        let randomX = Float.random(in: -12 ..< -7)
        let randomY = Float.random(in: -5 ..< 5)
        // 2
        let force = SCNVector3(x: randomX, y: randomY , z: 0)
        // 3
        let position = SCNVector3(x: 0.05, y: 0.05, z: 0.05)
        // 4
        geometryNode.physicsBody?.applyForce(force, at: position, asImpulse: true)

        let randomPosY = Float.random(in: -8 ..< 8)
        geometryNode.position = SCNVector3(x: 18, y: Float(randomPosY), z: 0)
        scnScene.rootNode.addChildNode(geometryNode)
        
    }
    
    func addSpaceship(){
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        let shipNode = scene.rootNode.childNode(withName: "ship", recursively: true)!

        shipNode.position = SCNVector3(x: -10, y: 0, z: 0)
        scnScene.rootNode.addChildNode(shipNode)

    }
    
    
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "spawnMeteor" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.spawnMeteor), userInfo: nil, repeats: true)
    }

    @objc func spawnMeteor(){
        spawnShape()
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
    
}

enum ShapeType:Int {

  case box = 0
  case sphere
  case pyramid
  case torus
  case capsule
  case cylinder
  case cone
  case tube

  // 2
  static func random() -> ShapeType {
    let maxValue = tube.rawValue
    let rand = arc4random_uniform(UInt32(maxValue+1))
    return ShapeType(rawValue: Int(rand))!
  }
    
    
}
