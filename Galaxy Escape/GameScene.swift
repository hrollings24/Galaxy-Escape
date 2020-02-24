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
import CoreMotion

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let laserCategory  = CollisionCategory(rawValue: 1 << 0)
    static let meteorCategory = CollisionCategory(rawValue: 1 << 1)
    static let shipCatagory = CollisionCategory(rawValue: 1 << 2)
    static let planetCatagory = CollisionCategory(rawValue: 1 << 3)

}

extension UIDevice {
    static func vibrate() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

enum movement {
    case left
    case right
    case still
    case up
    case down
}

class GameScene: SCNScene, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{
    
    var cameraNode: SCNNode!
    var cameraConstraint: SCNNode!
    var player: SCNNode!
    
    var gameVC: GameViewController!
    var meteorArray = [SCNNode]()
    var meteorNodeMain: SCNNode!
    
    var ship: SCNNode!
    var shipOnScreen: Bool!
    var shipleftrightmovement: movement!
    var shipupdownmovement: movement!

    var planetNode: SCNNode!
    var playing: Bool!
    
    var meteorTimer = Timer()
    var speed: Float!
    
    var min: Float!
    var max: Float!
    var planetZ: CGFloat!
    var planetTextures = [UIImage]()
    var texturePointer: Int!


    
    
    init(gameViewController: GameViewController){
        super.init()

        gameVC = gameViewController

        for i in 1..<13{
            let string = "planet" + String(i) + "_diffuse"
            planetTextures.append(UIImage(named: string)!)
        }
        texturePointer = 0
   
        //define player
        //player = Player()
        //self.rootNode.addChildNode(player)
        
        //define scene
        setupScene()
        
        //define ship
        addShip()
    
        
    }
    
    func addShip(){
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        ship.position = SCNVector3(x: 0, y: -5, z: 0)
        //ship.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        ship.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        ship.physicsBody?.isAffectedByGravity = false
        ship.eulerAngles = SCNVector3(0, Float.pi, 0)

        ship.physicsBody?.categoryBitMask = CollisionCategory.shipCatagory.rawValue
        ship.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        ship.physicsBody?.collisionBitMask = 0
        //ship.physicsBody?.mass = 0
        
        shipleftrightmovement = .still
        shipupdownmovement = .still
        //ship.eulerAngles = SCNVector3(0, 0, CGFloat.pi / 3)

        shipOnScreen = true
        self.rootNode.addChildNode(ship)
    }
    
    func removeShip(){
        ship.removeFromParentNode()
        shipleftrightmovement = .still
        shipOnScreen = false
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
     

    func setupScene() {
            
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = SCNVector3Zero

        self.background.contents = [UIImage(named: "skybox3_left"),
                                    UIImage(named: "skybox3_right"),
                                    UIImage(named: "skybox3_up"),
                                    UIImage(named: "skybox3_down"),
                                    UIImage(named: "skybox3_back"),
                                    UIImage(named: "skybox3_front")]
        
        cameraConstraint = SCNNode()
        cameraConstraint.position = SCNVector3(0, 0, 0)
        self.rootNode.addChildNode(cameraConstraint)

        playing = false
        player = SCNNode()
        
        cameraNode = SCNNode()
        cameraNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cameraNode.physicsBody?.collisionBitMask = 0
        cameraNode!.camera = SCNCamera()
        cameraNode!.position = SCNVector3(x: 0.0, y: 0, z: 15)
        cameraNode!.camera!.zNear = 0.1
        cameraNode!.camera!.zFar = 300
        self.rootNode.addChildNode(cameraNode!)

        // Link them
        let constraint1 = SCNLookAtConstraint(target: cameraConstraint)
        constraint1.isGimbalLockEnabled = false
        cameraNode!.constraints = [constraint1]
        
        
        
    }
        
    func spawnMeteor() {
        // 1
    
        let meteor = Meteor()
        meteor.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        meteor.physicsBody?.isAffectedByGravity = false
        meteor.physicsBody?.categoryBitMask = CollisionCategory.meteorCategory.rawValue
        meteor.physicsBody?.contactTestBitMask = CollisionCategory.laserCategory.rawValue | CollisionCategory.shipCatagory.rawValue
        meteor.name = "meteor"
        meteor.physicsBody?.collisionBitMask = 0
        let randomX = Float.random(in: -40 ..< 40)
        let randomY = Float.random(in: -8 ..< 8)
        
        meteor.position = SCNVector3(x: randomX, y: randomY, z: -100)
        meteor.name = "meteor"
        
        planetNode.addChildNode(meteor)
        
    }
    
    func spawnLaser(){
        //called when button is pressed
        //create cylinder
        let laser = SCNCylinder(radius: 0.25, height: 3)
        laser.materials.first?.diffuse.contents = UIColor.red
        let laserNode = SCNNode(geometry: laser)
        
        laserNode.position = ship.presentation.worldPosition
        laserNode.rotation = SCNVector4Make(0, 1, 0, .pi / 2)
        laserNode.name = "laser"
        laserNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        laserNode.physicsBody?.isAffectedByGravity = false
        laserNode.physicsBody?.categoryBitMask = CollisionCategory.laserCategory.rawValue
        laserNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        laserNode.physicsBody?.collisionBitMask = 0
        
        let z = 50 * cos(ship.eulerAngles.y)
        let x = 50 * sin(ship.eulerAngles.y)
        laserNode.physicsBody?.velocity = SCNVector3Make(x, 0, -z)
        
        self.rootNode.addChildNode(laserNode)
    }
    
    func addBloom() -> [CIFilter]? {
        let bloomFilter = CIFilter(name:"CIBloom")!
        bloomFilter.setValue(10.0, forKey: "inputIntensity")
        bloomFilter.setValue(30.0, forKey: "inputRadius")

        return [bloomFilter]
    }
        
    func startGame(){
       
        speed = 15.0
        min = 0
        max = 0
        planetZ = -30
        let meteorScene = SCNScene(named: "art.scnassets/meteor.scn")!
        meteorNodeMain = meteorScene.rootNode.childNode(withName: "meteor", recursively: true)!
        playing = true
        
        if !shipOnScreen{
            addShip()
        }
        planetNode = SCNNode()

        //shipNode.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi));

     
        self.rootNode.addChildNode(planetNode)

        addInitialPlanet()
        for i in 1...100 {
            addPlanet(i: i)
        }
        cameraNode.position = SCNVector3(0, 0, 15)
        
        
        // Scheduling timer to Call the function "spawnMeteor" with the interval of 0.5 seconds
        meteorTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.spawnMeteor1), userInfo: nil, repeats: true)
    }
    
    func addInitialPlanet(){
        let earthScene = SCNScene(named: "art.scnassets/earth.scn")!
        let earthNode = earthScene.rootNode.childNode(withName: "earth", recursively: true)!
        earthNode.position = SCNVector3(-30, 0, planetZ)
        earthNode.scale = SCNVector3(1.4, 1.4, 1.4)
        earthNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        earthNode.physicsBody?.categoryBitMask = CollisionCategory.planetCatagory.rawValue
        earthNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        earthNode.physicsBody?.collisionBitMask = 0
        planetNode.addChildNode(earthNode)
        
        min = earthNode.position.x - (38)
        max = earthNode.position.x + (38)
        planetZ -= 4
        texturePointer += 1
        
    }
    
    func addPlanet(i: Int){
        let radius = CGFloat.random(in: 30..<50)

        if i % 10 == 0{
            min = Float.random(in: -40 ..< 40)
            max = Float.random(in: -40 ..< 40)
        }
      
        let sphereGeometry = SCNSphere(radius: radius)
        sphereGeometry.firstMaterial?.diffuse.contents = planetTextures[texturePointer!]
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody?.categoryBitMask = CollisionCategory.planetCatagory.rawValue
        sphereNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        sphereNode.physicsBody?.collisionBitMask = 0

        if i % 2 == 0{
            min -= Float(radius*2)
            sphereNode.position = SCNVector3(CGFloat(min), CGFloat.random(in: -4..<4), planetZ)
            min -= Float(radius)*2 - 10
        }
        else{
            max += Float(radius*2)
            sphereNode.position = SCNVector3(CGFloat(max), CGFloat.random(in: -4..<4), planetZ)
            max += Float(radius)*2 + 10
        }
        planetZ -= 8
        planetNode.addChildNode(sphereNode)
        if texturePointer == 11{
            texturePointer = 0
        }
        else{
            texturePointer += 1
        }
    }

    @objc func spawnMeteor1(){
        DispatchQueue.global(qos: .background).async {
            self.spawnMeteor()
        }
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
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.laserCategory.rawValue {
                   //planet and laser
                   contact.nodeA.removeFromParentNode()
               }
        else if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.laserCategory.rawValue {
                   //planet and laser
                   contact.nodeB.removeFromParentNode()
               }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue {
            //collision between ship and meteor
            meteorTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between meteor and ship
            meteorTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue {
            //collision between ship and terrain
            meteorTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between terrain and ship
            meteorTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue {
            contact.nodeA.removeFromParentNode()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue {
            contact.nodeB.removeFromParentNode()
        }
        else{
            print("incorrect collision")
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if playing!{
            let z = (speed+0.1) * cos(ship.eulerAngles.y)
            let x = (speed+0.1) * sin(ship.eulerAngles.y)
            planetNode.enumerateChildNodes { (node, stop) in
                if node.name == "meteor"{
                    let vec = ship.presentation.worldPosition - node.presentation.worldPosition
                    node.physicsBody?.velocity = SCNVector3Make(-x, 0, z) + (vec/4)
                    //VIBRATIONS
                    
                    if (ship.presentation.worldPosition.x < node.presentation.worldPosition.x + 4) && (ship.presentation.worldPosition.x > node.presentation.worldPosition.x - 4) {
                        if (ship.presentation.worldPosition.y < node.presentation.worldPosition.y + 2) && (ship.presentation.worldPosition.y > node.presentation.worldPosition.y - 2) {
                            if ship.presentation.worldPosition.z < node.presentation.worldPosition.z + 8{
                                let generator = UIImpactFeedbackGenerator(style: .light)
                                //generator.impactOccurred()
                            }
                        }
                    }
                }
                else{
                    node.physicsBody?.velocity = SCNVector3Make(-x, 0, z)
                }
            }
            var eulerAngledZ = Float()
            var eulerAngledX = Float()

            if shipleftrightmovement == .right{
               eulerAngledZ = Float.pi / 6
            }
            else if shipleftrightmovement == .left{
               eulerAngledZ = -(Float.pi / 6)
            }
            else{
               eulerAngledZ = 0
            }
            if shipupdownmovement == .up{
               eulerAngledX = Float.pi / 9
            }
            else if shipleftrightmovement == .down{
               eulerAngledX = -(Float.pi / 9)
            }
            else{
               eulerAngledX = 0
            }

            let act = SCNAction.rotateTo(x: CGFloat(eulerAngledX), y: CGFloat.pi, z: CGFloat(eulerAngledZ), duration: 0.5, usesShortestUnitArc: true)
            ship.runAction(act)
            //ship.eulerAngles = SCNVector3(eulerAngledX, , eulerAngledZ)
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


extension SCNVector3{
    func length() -> Float {
        return sqrtf(x*x + y*y + z*z)
    }
    func distance(vector: SCNVector3) -> SCNVector3 {
        return (self - vector)
    }
}

func - (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x - right.x, left.y - right.y, left.z - right.z)
}
func * (vector: SCNVector3, scalar: Float) -> SCNVector3 {
    return SCNVector3Make(vector.x * scalar, vector.y * scalar, vector.z * scalar)
}
func + (left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}
func / (left: SCNVector3, right: Float) -> SCNVector3 {
    return SCNVector3Make(left.x / right, left.y / right, left.z / right)
}
