//
//  GameScene.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 21/11/2019.
//  Copyright © 2019 Harry Rollings. All rights reserved.
//

import UIKit
import SceneKit
import Foundation
import AVFoundation

struct CollisionCategory: OptionSet {
   let rawValue: Int
   static let laserCategory  = CollisionCategory(rawValue: 1 << 0)
   static let meteorCategory = CollisionCategory(rawValue: 1 << 1)
   static let shipCatagory = CollisionCategory(rawValue: 1 << 2)
}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

class GameScene: SCNScene, SCNPhysicsContactDelegate{
    
    var cameraNode: SCNNode!
    var shipNode: SCNNode!
    var gameVC: GameViewController!
    var meteorArray = [SCNNode]()

    
    var meteorTimer = Timer()
    var checkDistanceTimer = Timer()
    
    
    init(gameViewController: GameViewController){
        super.init()

        gameVC = gameViewController
        
        setupScene()
        setupCamera()
        addSpaceship()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
     

    func setupScene() {
            
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = SCNVector3(x: 0, y: 0, z: 0)

        self.background.contents = [UIImage(named: "skybox3_left"),
                                    UIImage(named: "skybox3_right"),
                                    UIImage(named: "skybox3_up"),
                                    UIImage(named: "skybox3_down"),
                                    UIImage(named: "skybox3_back"),
                                    UIImage(named: "skybox3_front")]
        
    }
        
    func setupCamera() {
      // 1
      cameraNode = SCNNode()
      // 2
      cameraNode.camera = SCNCamera()
      // 3
      cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
      // 4
      self.rootNode.addChildNode(cameraNode)
    }
        
    func spawnMeteor() {
        // 1
        var geometry:SCNGeometry
        // 2
        switch ShapeType.random() {
        default:
        // 3
        geometry = SCNSphere(radius: 0.5)
        }
        // 4
        let meteorNode = SCNNode(geometry: geometry)
        // 5
        meteorNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        meteorNode.physicsBody?.isAffectedByGravity = false
        meteorNode.physicsBody?.categoryBitMask = CollisionCategory.meteorCategory.rawValue
        meteorNode.physicsBody?.contactTestBitMask = CollisionCategory.laserCategory.rawValue | CollisionCategory.shipCatagory.rawValue
        meteorNode.name = "meteor"
        meteorNode.physicsBody?.collisionBitMask = 0

        // 1
        let randomX = Float.random(in: -40 ..< 40)
        print(randomX)
        let randomY = Float.random(in: -3 ..< 3)
        var randomXForce = Float(0.0)
        var randomYForce = Float(0.0)
        
        if randomX <= 0{
            randomXForce = Float.random(in: 0 ..< 7)
        }
        else{
            randomXForce = Float.random(in: -7 ..< 0)
        }
        if randomY <= 0{
            randomYForce = Float.random(in: 0 ..< 3)
        }
        else{
            randomYForce = Float.random(in: -3 ..< 0)
        }
        // 2
        let force = SCNVector3(x: randomXForce, y: randomYForce , z: 10)
        // 3
        let position = SCNVector3(x: randomX, y: randomY, z: -40)
        // 4
        meteorNode.physicsBody?.applyForce(force, at: position, asImpulse: true)
        
        meteorArray.append(meteorNode)
                
        meteorNode.position = SCNVector3(x: randomX, y: randomY, z: -20)
        self.rootNode.addChildNode(meteorNode)
        
    }
    
    func addSpaceship(){
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

        
        self.rootNode.addChildNode(shipNode)

    }
    
    func spawnLaser(){
        //called when button is pressed
        //create cylinder
        let laser = SCNCylinder(radius: 0.5, height: 2)
        laser.materials.first?.diffuse.contents = UIColor.red
        let laserNode = SCNNode(geometry: laser)
        
        laserNode.position = shipNode.position
        laserNode.rotation = SCNVector4Make(1, 0, 0, .pi / 2)
        //laserNode.rotation = SCNVector4Make(0, 0, 1, .pi / 2)
        laserNode.name = "laser"


        laserNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        laserNode.physicsBody?.velocity = SCNVector3Make(0, 0, -10)
        laserNode.physicsBody?.isAffectedByGravity = false
        laserNode.physicsBody?.categoryBitMask = CollisionCategory.laserCategory.rawValue
        laserNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        laserNode.physicsBody?.collisionBitMask = 0


        self.rootNode.addChildNode(laserNode)
    }
    
 
        
        
    func startGame(){
        // Scheduling timer to Call the function "spawnMeteor" with the interval of 0.6 seconds
        meteorTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.spawnMeteor1), userInfo: nil, repeats: true)
        checkDistanceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkDistances), userInfo: nil, repeats: true)
    }

    @objc func spawnMeteor1(){
        spawnMeteor()
    }
    
    func randRange (lower: Int , upper: Int) -> Int {
        return lower + Int(arc4random_uniform(UInt32(upper - lower + 1)))
    }
    
   func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.laserCategory.rawValue {
            //remove meteor and laser
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.laserCategory.rawValue {
            //remove meteor and laser
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue {
            //collision between ship and meteor
            meteorTimer.invalidate()
            checkDistanceTimer.invalidate()
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between meteor and ship
            meteorTimer.invalidate()
            checkDistanceTimer.invalidate()
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
            gameVC.endGame()
        }
        else{
            print("incorrect collision")
        }
    }
    
    func setShipPosition(pos: SCNVector3){
        shipNode.position =  pos
    }
    
    func getShipPositionX() -> SCNVector3{
        return shipNode.position
    }
    
    @objc func checkDistances() {
        //
        print("kjbdfw")
        
        let shipLocation = shipNode.position
        let xValueMax = shipLocation.x + 5
        let xValueMin = shipLocation.x - 5
        let yValueMax = shipLocation.y + 3
        let yValueMin = shipLocation.y - 3
        let zValueMax = shipLocation.z + 6
        let zValueMin = shipLocation.z - 6
        
        outerloop: for meteorNode in meteorArray{
            
            let realPosition = meteorNode.presentation.worldPosition

            
            if realPosition.z > 15{
                let index = meteorArray.firstIndex(of: meteorNode)!
                meteorArray.remove(at: index)
                break outerloop
            }
            if realPosition.x < xValueMax && realPosition.x > xValueMin {
                if realPosition.y < yValueMax && realPosition.y > yValueMin {
                    if realPosition.z < zValueMax && realPosition.z > zValueMin {
                        UIDevice.vibrate()
                    }
                }
            }
        }
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

