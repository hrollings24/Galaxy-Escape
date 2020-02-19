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
    static let earthCatagory = CollisionCategory(rawValue: 1 << 3)

}

extension UIDevice {
    static func vibrate() {
        //AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
}

class GameScene: SCNScene, SCNPhysicsContactDelegate, SCNSceneRendererDelegate{
    
    var cameraNode: SCNNode!
    var cameraConstraint: SCNNode!
    var player: SCNNode!
    
    var gameVC: GameViewController!
    var meteorArray = [SCNNode]()
    var meteorNodeMain: SCNNode!
    
    //var player: Player!
    var ship: SCNNode!
    var shipOnScreen: Bool!
    var planetNode: SCNNode!
    var playing: Bool!
    
    var meteorTimer = Timer()
    var checkDistanceTimer = Timer()
    var speed: Float!
    
    var min: Float!
    var max: Float!
    var planetZ: CGFloat!


    
    
    init(gameViewController: GameViewController){
        super.init()

        gameVC = gameViewController

   
        //define player
        //player = Player()
        //self.rootNode.addChildNode(player)
        
        //define scene
        setupScene()
        
        //define ship
        addShip()
    
        
    }
    
    func addShip(){
        ship = Ship()
        ship.position = SCNVector3(x: 0, y: -5, z: 0)
        ship.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi))
        ship.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)

        //shipNode.rotation = SCNVector4Make(0, 1, 0, Float(Double.pi));
        ship.physicsBody?.isAffectedByGravity = false

        ship.physicsBody?.categoryBitMask = CollisionCategory.shipCatagory.rawValue
        ship.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        ship.physicsBody?.collisionBitMask = 0
        //ship.physicsBody?.mass = 0

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
        let laser = SCNCylinder(radius: 0.25, height: 3)
        laser.materials.first?.diffuse.contents = UIColor.red
        let laserNode = SCNNode(geometry: laser)
        
        laserNode.position = ship.worldPosition
        laserNode.rotation = SCNVector4Make(0, 1, 0, .pi / 2)
        laserNode.name = "laser"
        laserNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        
        laserNode.physicsBody?.isAffectedByGravity = false
        laserNode.physicsBody?.categoryBitMask = CollisionCategory.laserCategory.rawValue
        laserNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        laserNode.physicsBody?.collisionBitMask = 0
        
        let z = 40 * cos(ship.eulerAngles.y)
        let x = 40 * sin(ship.eulerAngles.y)
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
        
        
        //let moveAction = SCNAction.moveBy(x: 0, y: 0, z: -200, duration: 20)
        //cameraNode.runAction(moveAction)
        //ship.runAction(moveAction)
        //cameraConstraint.runAction(moveAction)
        //shipConstraint.runAction(moveAction)

        
        //addTerrain()
        
        // Scheduling timer to Call the function "spawnMeteor" with the interval of 0.6 seconds
        meteorTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.spawnMeteor1), userInfo: nil, repeats: true)
        checkDistanceTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.checkDistances), userInfo: nil, repeats: true)
    }
    
    func addInitialPlanet(){
        let earthScene = SCNScene(named: "art.scnassets/earth.scn")!
        let earthNode = earthScene.rootNode.childNode(withName: "earth", recursively: true)!
        earthNode.position = SCNVector3(-30, 0, planetZ)
        earthNode.scale = SCNVector3(1.4, 1.4, 1.4)
        earthNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        earthNode.physicsBody?.categoryBitMask = CollisionCategory.earthCatagory.rawValue
        earthNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        earthNode.physicsBody?.collisionBitMask = 0
        planetNode.addChildNode(earthNode)
        
        min = earthNode.position.x - (38)
        max = earthNode.position.x + (38)
        planetZ -= 4
        
    }
    
    func addPlanet(i: Int){
        let radius = CGFloat.random(in: 20..<30)
        var locMax: Float!
        var locMin: Float!

        if i % 10 == 0{
            min = Float.random(in: -40 ..< 40)
            max = Float.random(in: -40 ..< 40)
            max = max+Float(radius)+10
            min = min-Float(radius)-10
        }
        else{
            locMax = Float(radius)+6+max
            locMin = min-Float(radius)-6
        }
        var minmax = 0
        if i % 2 == 0{
            minmax = 0
        }
        else{
            minmax = 1
        }
      
        let sphereGeometry = SCNSphere(radius: radius)
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "mars_diffuse")
        let sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.physicsBody = SCNPhysicsBody(type: .dynamic, shape: nil)
        sphereNode.physicsBody?.categoryBitMask = CollisionCategory.earthCatagory.rawValue
        sphereNode.physicsBody?.contactTestBitMask = CollisionCategory.meteorCategory.rawValue
        sphereNode.physicsBody?.collisionBitMask = 0

        switch minmax {
            case 0:
                print(SCNVector3(CGFloat(locMin), 0, planetZ))
                sphereNode.position = SCNVector3(CGFloat(locMin), 0, planetZ)
                min = locMin - Float(radius)*2 - 6
                if Float(radius)*2 + 6 + locMax > max{
                    max += Float(radius)*2 + 6
                }
            default:
                print(SCNVector3(CGFloat(locMax), 0, planetZ))
                sphereNode.position = SCNVector3(CGFloat(locMax), 0, planetZ)
                max = Float(radius)*2 + 6 + locMax
                if locMin - Float(radius)*2 - 6 < min{
                    min = locMin - Float(radius)*2 - 6
                }
            }
        planetZ -= 8
        planetNode.addChildNode(sphereNode)
    }

    @objc func spawnMeteor1(){
        DispatchQueue.global(qos: .background).async {
            self.spawnMeteor()
        }
    }
    
   func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
    
        print("removing...")
        print(contact.nodeA)
        print(contact.nodeB)
        
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
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.earthCatagory.rawValue {
            //collision between ship and terrain
            meteorTimer.invalidate()
            checkDistanceTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()

        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.earthCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.shipCatagory.rawValue {
            //collision between terrain and ship
            meteorTimer.invalidate()
            checkDistanceTimer.invalidate()
            self.rootNode.enumerateChildNodes { (node, stop) in
                node.removeFromParentNode()
            }
            self.shipOnScreen = false
            gameVC.endGame()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.earthCatagory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue {
            contact.nodeA.removeFromParentNode()
        }
        else if contact.nodeB.physicsBody?.categoryBitMask == CollisionCategory.meteorCategory.rawValue && contact.nodeA.physicsBody?.categoryBitMask == CollisionCategory.earthCatagory.rawValue {
            contact.nodeB.removeFromParentNode()
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
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        if playing!{
            let z = (speed+0.1) * cos(ship.eulerAngles.y)
            let x = (speed+0.1) * sin(ship.eulerAngles.y)
            planetNode.enumerateChildNodes { (node, stop) in
                node.physicsBody?.velocity = SCNVector3Make(-x, 0, z)
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
