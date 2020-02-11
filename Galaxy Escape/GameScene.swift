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
    static let terrainCatagory = CollisionCategory(rawValue: 1 << 3)

}

extension UIDevice {
    static func vibrate() {
        //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

class GameScene: SCNScene, SCNPhysicsContactDelegate{
    
    var cameraNode: SCNNode!
    var gameVC: GameViewController!
    var meteorArray = [SCNNode]()
    var meteorNodeMain: SCNNode!
    
    var player: Player!
    var ship: SCNNode!
    var shipOnScreen: Bool!
    
    var meteorTimer = Timer()
    var checkDistanceTimer = Timer()
    
    
    init(gameViewController: GameViewController){
        super.init()

        gameVC = gameViewController
   
        //define player
        player = Player()
        self.rootNode.addChildNode(player)
        
        //define ship
        addShip()
    
        //define scene
        setupScene()
    }
    
    func addShip(){
        ship = Ship()
        shipOnScreen = true
        self.rootNode.addChildNode(ship)
    }
    
    func removeShip(){
        ship.removeFromParentNode()
        shipOnScreen = false
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
        
    func spawnMeteor() {
        
        let meteor = Meteor()
        let randomX = Float.random(in: -40 ..< 40)
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
        
        let force = SCNVector3(x: randomXForce, y: randomYForce , z: 15)
        let position = SCNVector3(x: 0, y: 0, z: 0)
        meteor.meteorNode.physicsBody?.applyForce(force, at: position, asImpulse: true)

        meteor.position = SCNVector3(x: randomX, y: randomY, z: -50)
        
        self.rootNode.addChildNode(meteor)
        
    }
    
    func spawnLaser(){
        //called when button is pressed
        //create cylinder
        let laser = SCNCylinder(radius: 0.5, height: 2)
        laser.materials.first?.diffuse.contents = UIColor.red
        let laserNode = SCNNode(geometry: laser)
        
        laserNode.position = ship.presentation.worldPosition
        laserNode.rotation = SCNVector4Make(1, 0, 0, .pi / 2)
        laserNode.name = "laser"


        laserNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        laserNode.physicsBody?.velocity = SCNVector3Make(0, 2, -20)
        laserNode.physicsBody?.isAffectedByGravity = false
        laserNode.physicsBody?.categoryBitMask = CollisionCategory.laserCategory.rawValue
        laserNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        laserNode.physicsBody?.collisionBitMask = 0


        self.rootNode.addChildNode(laserNode)
    }
    
 
        
        
    func startGame(){
        
       
        if !shipOnScreen{
            addShip()
        }
        
        //addTerrain()
        
        // Scheduling timer to Call the function "spawnMeteor" with the interval of 0.6 seconds
        meteorTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.spawnMeteor1), userInfo: nil, repeats: true)
        //checkDistanceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkDistances), userInfo: nil, repeats: true)
    }
    
    func addTerrain(){
        
        //add Terrain
        let terrainClass = Terrain()
        let terrain = terrainClass.terrainNode
        
        terrain.position = SCNVector3(x: -140, y: -10, z: 0)
        terrain.rotation = SCNVector4Make(0, 1, 0, .pi / 2)
        
        terrain.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        terrain.physicsBody?.isAffectedByGravity = false
        terrain.physicsBody?.categoryBitMask = CollisionCategory.terrainCatagory.rawValue
        terrain.physicsBody?.contactTestBitMask = CollisionCategory.shipCatagory.rawValue
        terrain.physicsBody?.collisionBitMask = 0
        
        let moveAction = SCNAction.moveBy(x: 0, y: 0, z: 800, duration: 160)
        terrain.runAction(moveAction)

        self.rootNode.addChildNode(terrain)
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
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between meteor and ship
            meteorTimer.invalidate()
            checkDistanceTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.terrainCatagory.rawValue {
            //collision between ship and terrain
            meteorTimer.invalidate()
            checkDistanceTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.terrainCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between terrain and ship
            meteorTimer.invalidate()
            checkDistanceTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()
        }
        else{
            print("incorrect collision")
        }
    }
    
    @objc func checkDistances() {
        //
        
        let shipLocation = ship.position
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

