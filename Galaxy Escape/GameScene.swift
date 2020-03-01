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
import AudioToolbox

class GameScene: SCNScene, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{
    
    //Camera Fields
    var cameraNode: SCNNode!
    var cameraConstraint: SCNNode!
    
    //Ship Fields
    var ship: SCNNode!
    var shipOnScreen: Bool!

    //Gameplay Fields
    var meteorNodeMain: SCNNode!
    var meteorTimer = Timer()
    var speed: Float!
    var motionManager: CMMotionManager!
    var xMovement = Float(0)
    var laserNodeMain: SCNNode!
    var vibrationTimer = Timer()
    var canVibrate: Bool!
    
    //Lasers
    var laserCount: Int!
    var laserNodeOnScreen: Bool!
    var laserLimit: Int!

    
    //Game Setting Fields
    var playing: Bool!
    var gameVC: GameViewController!
    var vibrationCounter: Int!
    
    //Planet Fields
    var planetNode: SCNNode!
    var min: Float!     //used for setting position of planets
    var max: Float!
    var planetZ: CGFloat!
    var planetTextures = [UIImage]()
    var texturePointer: Int!
    var removedPlanets: Int!
    

    init(gameViewController: GameViewController){
        super.init()
        
        
        let meteorScene = SCNScene(named: "art.scnassets/ar2.dae")!
        meteorNodeMain = meteorScene.rootNode.childNode(withName: "meteor", recursively: true)!
    
        //define scene
        setupScene()
        
        
       

        gameVC = gameViewController

        for i in 1..<13{
            let string = "planet" + String(i) + "_diffuse"
            planetTextures.append(UIImage(named: string)!)
        }
        
       
        
        //define ship
        addShip()
        
    }
    
    func addShip(){
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        ship = scene.rootNode.childNode(withName: "ship", recursively: true)!
        ship.position = SCNVector3(x: 0, y: -2.5, z: 0)
        //ship.rotation = SCNVector4Make(0, 1, 0, Float.pi)
        ship.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        ship.physicsBody?.isAffectedByGravity = false
        ship.eulerAngles = SCNVector3(0, Float.pi, 0)

        ship.physicsBody?.categoryBitMask = CollisionCategory.shipCatagory.rawValue
        ship.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue | CollisionCategory.planetCatagory.rawValue
        ship.physicsBody?.collisionBitMask = 0
        
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
        
        cameraNode = SCNNode()
        cameraNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        cameraNode.physicsBody?.collisionBitMask = 0
        cameraNode!.camera = SCNCamera()
        cameraNode!.position = SCNVector3(x: 0.0, y: 0, z: 15)
        cameraNode!.camera!.zNear = 0.1
        cameraNode!.camera!.zFar = 400
        self.rootNode.addChildNode(cameraNode!)

        // Link them
        let constraint1 = SCNLookAtConstraint(target: ship)
        constraint1.isGimbalLockEnabled = false
        cameraNode!.constraints = [constraint1]
        
    }
        
    func spawnMeteor() {
        // 1
        
        let scaleFactor = Float.random(in: 0.01..<0.03)
        let meteor = meteorNodeMain.clone()
        meteor.scale = SCNVector3(x: scaleFactor, y: scaleFactor, z: scaleFactor)

        meteor.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        meteor.physicsBody?.isAffectedByGravity = false
        meteor.physicsBody?.categoryBitMask = CollisionCategory.meteorCategory.rawValue
        meteor.physicsBody?.contactTestBitMask = CollisionCategory.laserCategory.rawValue | CollisionCategory.shipCatagory.rawValue
        meteor.name = "meteor"
        meteor.physicsBody?.collisionBitMask = 0
        //CRASH IF SHIP MOVES INTO NEGATIVE X
     
        let randomX = Float.random(in: (ship.position.x-40) ..< (ship.position.x+40))
        let randomY = Float.random(in: -(ship.position.y+8) ..< (ship.position.y+8))
        
        meteor.position = SCNVector3(x: randomX, y: randomY, z: -210)
        planetNode.addChildNode(meteor)
                
    }
    
    func spawnLaser(){
        
        if (laserCount! >= laserLimit) && !laserNodeOnScreen{
            laserNodeOnScreen = true
            gameVC.spriteScene.addLaserNode()
        }
        else if (laserCount! < laserLimit){
            print(laserCount!)

            //called when button is pressed
            //create cylinder
            let laser = SCNCylinder(radius: 0.2, height: 3.5)
            laser.materials.first?.diffuse.contents = UIColor.red
            let laserNode = SCNNode(geometry: laser)
            
            laserNode.position = ship.position
            let shipAngles = ship.eulerAngles
            laserNode.eulerAngles = SCNVector3((Float.pi / 2) - shipAngles.x, -shipAngles.y, 0)
            laserNode.name = "laser"
            laserNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
            
            laserNode.physicsBody?.isAffectedByGravity = false
            laserNode.physicsBody?.categoryBitMask = CollisionCategory.laserCategory.rawValue
            laserNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
            laserNode.physicsBody?.collisionBitMask = 0

            let z = 50 * cos(ship.eulerAngles.y)
            let x = 50 * sin(ship.eulerAngles.y)
            let y = 50 * sin(ship.eulerAngles.x)
            laserNode.physicsBody?.velocity = SCNVector3Make(x, y, -z)
            
            laserCount += 1
            
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { timer in
                //timer fired
                self.laserCount -= 1
                if self.laserCount >= self.laserLimit-1{
                    self.laserNodeOnScreen = false
                    self.gameVC.spriteScene.removeLaserNode()
                }

            }
            laserNodeMain.addChildNode(laserNode)
        }
    }
        
    func resetCamera(){
        cameraNode!.position = SCNVector3(x: 0.0, y: 0, z: 15)
        cameraNode.eulerAngles = SCNVector3Zero
    }
    
    func startGame(){
       
        // Scheduling timer to Call the function "spawnMeteor" with the interval of 0.5 seconds
        meteorTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.spawnMeteor1), userInfo: nil, repeats: true)
        self.rootNode.addChildNode(cameraNode!)

        texturePointer = 0
        canVibrate = true
        laserLimit = 5
        
        resetCamera()
        vibrationCounter = 0
        laserNodeOnScreen = false
        laserCount = 0
        speed = 20.0
        min = 0
        max = 0
        planetZ = -50
        
        if !shipOnScreen{
            addShip()
        }
        planetNode = SCNNode()
        removedPlanets = 0

        self.rootNode.addChildNode(planetNode)

        addInitialPlanet()
        for i in 1...100 {
            addPlanet(i: i)
        }
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        playing = true
        laserNodeMain = SCNNode()
        self.rootNode.addChildNode(laserNodeMain)

       
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
        let radius = CGFloat.random(in: 30..<60)

        if i % 10 == 0{
            min = Float.random(in: -40 ..< 40)
            max = Float.random(in: -40 ..< 40)
        }
      
        let sphereGeometry = SCNSphere(radius: radius)
        sphereGeometry.firstMaterial?.diffuse.contents = planetTextures[texturePointer!]
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody?.categoryBitMask = CollisionCategory.planetCatagory.rawValue
        sphereNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue |  CollisionCategory.shipCatagory.rawValue
        sphereNode.physicsBody?.collisionBitMask = 0

        if i % 2 == 0{
            min -= (Float(radius*2) + 12)
            sphereNode.position = SCNVector3(CGFloat(min), CGFloat.random(in: -4..<4), planetZ)
            //min -= (Float(radius)*2 + 12)
        }
        else{
            max += (Float(radius*2) + 12)
            sphereNode.position = SCNVector3(CGFloat(max), CGFloat.random(in: -4..<4), planetZ)
            //max += (Float(radius)*2 + 12)
        }
        planetZ -= 12
        planetNode.addChildNode(sphereNode)
        if texturePointer == 11{
            texturePointer = 0
        }
        else{
            texturePointer += 1
        }
    }

    @objc func spawnMeteor1(){
            self.spawnMeteor()
        
    }
    
   //Collisions
   func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        
        if contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.laserCategory.rawValue {
            //remove meteor and laser
            gameVC.spriteScene.incrementMeteor()
            contact.nodeA.removeFromParentNode()
            contact.nodeB.removeFromParentNode()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.laserCategory.rawValue {
            //remove meteor and laser
            gameVC.spriteScene.incrementMeteor()
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
            cameraNode.removeAllActions()
            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between meteor and ship
            meteorTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            cameraNode.removeAllActions()

            gameVC.endGame()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue {
            //collision between ship and terrain
            meteorTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            cameraNode.removeAllActions()

            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.planetCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between terrain and ship
            meteorTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            cameraNode.removeAllActions()

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
        if playing{
            
            speed += 0.02
            var eulerAngledZ = Float()
            var eulerAngledX = Float()
            var eulerAngledY = Float.pi
            
            //Move Ship
            if let accelerometerData = motionManager.accelerometerData {
                let tilt = CGVector(dx: accelerometerData.acceleration.y * -50, dy: accelerometerData.acceleration.x * 50)
                if tilt.dx > 0{
                    var val = tilt.dx
                    if val > 18{
                        val = 18
                    }
                    else{
                        val = tilt.dx
                    }
                    //left
                    ship.position = SCNVector3.init(ship.position.x + Float(val/200), ship.position.y, ship.position.z)
                    cameraNode.position = SCNVector3.init(cameraNode.position.x + Float(val/200), cameraNode.position.y, cameraNode.position.z)
                    eulerAngledZ = Float(val / 40)
                    eulerAngledY = Float.pi + Float(val / 40)
                }
                else if tilt.dx < 0{
                    var val = tilt.dx
                    if val < -18{
                        val = -18
                    }
                    else{
                        val = tilt.dx
                    }
                    //right
                    ship.position = SCNVector3.init(ship.position.x - Float(val/200), ship.position.y, ship.position.z)
                    cameraNode.position = SCNVector3.init(cameraNode.position.x - Float(val/200), cameraNode.position.y, cameraNode.position.z)
                    eulerAngledZ = Float(val / 40)
                    eulerAngledY = Float.pi + Float(val / 40)
                }
                else{
                    //Stop
                    eulerAngledZ = 0
                }
                let tiltAngle = tilt.dy - 35
                if tiltAngle < 0{
                    //tilt ship downwards
                    eulerAngledX = -Float(tiltAngle/80)
                }
                else if tilt.dy > 0{
                    eulerAngledX = -Float(tiltAngle/80)
                }
                let act = SCNAction.rotateTo(x: CGFloat(eulerAngledX), y: CGFloat(eulerAngledY), z: CGFloat(eulerAngledZ), duration: 0.4, usesShortestUnitArc: true)
                ship.runAction(act)
                let actCamera = SCNAction.rotateTo(x: 0, y: CGFloat(eulerAngledY - Float.pi), z: 0, duration: 0.5, usesShortestUnitArc: true)
                cameraNode.runAction(actCamera)
            }
 
            //Set Velocities
            let x = (speed) * sin(ship.eulerAngles.y)
            let z = (speed) * cos(ship.eulerAngles.y)
           
            planetNode.enumerateChildNodes { (node, stop) in
                if node.name == "meteor"{
                    node.physicsBody?.velocity = SCNVector3Make(-x, 0, z+Float.random(in: 4..<12))
                    //VIBRATIONS
                    if canVibrate!{
                             
                            
                        if (checkDistanceBetween(node1: node)) != .medium{
                            let generator = UIImpactFeedbackGenerator(style: checkDistanceBetween(node1: node))
                            generator.impactOccurred()
                            canVibrate = false
                            vibrationTimer = Timer.scheduledTimer(withTimeInterval: 0.25, repeats: false) { timer in
                                //timer fired
                                self.canVibrate = true
                                self.vibrationTimer.invalidate()
                            }
                        }
                    }
                }
                else{
                    node.physicsBody?.velocity = SCNVector3Make(-x, 0, z)
                }
                //Check to remove node
                if node.presentation.worldPosition.z > (15 + (node.geometry?.boundingSphere.radius)!){
                    node.removeFromParentNode()
                    removedPlanets += 1
                    if removedPlanets == 10{
                        planetZ += 120
                        for i in 1...10 {
                           addPlanet(i: i)
                        }
                        removedPlanets = 0
                    }
                }
            }
            laserNodeMain.enumerateChildNodes { (node, stop) in
                if node.presentation.worldPosition.z < -200{
                    node.removeFromParentNode()
                }
            }
        }
    }
    
    
    func checkDistanceBetween(node1: SCNNode) -> UIImpactFeedbackGenerator.FeedbackStyle{
        let node1Pos = node1.presentation.worldPosition
        if node1Pos.z == 0 && node1Pos.x == 0 && node1Pos.y == 0{
            return .medium
        }
        let node2Pos = ship.position
        let distance = SCNVector3(
            node2Pos.x - node1Pos.x,
            node2Pos.y - node1Pos.y,
            node2Pos.z - node1Pos.z
        )
        if distance.z < 18 && abs(distance.y) < 4 && abs(distance.x) < 7{
            print("Strong")
            return .heavy
        }
        else if distance.z < 30 && abs(distance.y) < 4 && abs(distance.x) < 7{
            return .light
        }
        return .medium
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

struct CollisionCategory: OptionSet {
    let rawValue: Int
    static let laserCategory  = CollisionCategory(rawValue: 1 << 0)
    static let meteorCategory = CollisionCategory(rawValue: 1 << 1)
    static let shipCatagory = CollisionCategory(rawValue: 1 << 2)
    static let planetCatagory = CollisionCategory(rawValue: 1 << 3)

}

enum Strength{
    case light
    case strong
    case none
}
