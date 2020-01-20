//
//  GameViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 18/11/2019.
//  Copyright © 2019 Harry Rollings. All rights reserved.
//

import UIKit
import SceneKit
import SpriteKit
import GameplayKit


class GameViewController: UIViewController {

    
    var sceneView: SCNView!
    var sceneGame: GameScene!
    var spriteScene: OverlayScene!
    var movingNow: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneGame = GameScene()
        self.sceneView.scene = sceneGame
        self.sceneView.autoenablesDefaultLighting = true
        
        // add a tap gesture recognizer
        let tapGesture = UIPanGestureRecognizer(target: self, action:#selector(moveSpaceship))
        sceneView.addGestureRecognizer(tapGesture)
        movingNow = false
        
        
        self.view.addSubview(self.sceneView)
        
        self.spriteScene = OverlayScene(size: self.view.bounds.size)
        self.sceneView.overlaySKScene = self.spriteScene
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneGame.spawnLaser()
    }
    
    
    var previousLoc = CGPoint.init(x: 0, y: 0)

    @objc func moveSpaceship(sender: UIPanGestureRecognizer){
        var delta = sender.translation(in: self.view)
        let loc = sender.location(in: self.view)

        if sender.state == .changed {
            delta = CGPoint.init(x: 2 * (loc.x - previousLoc.x), y: 2 * (loc.y - previousLoc.y))
            sceneGame.setShipPosition(pos: SCNVector3.init(sceneGame.shipNode.position.x + Float(delta.x * 0.02), sceneGame.shipNode.position.y + Float(-delta.y * (0.02)), 0))
            previousLoc = loc
        }
    previousLoc = loc


    }
 
  
    
    func CGPointToSCNVector3(view: SCNView, depth: Float, point: CGPoint) -> SCNVector3 {
           let projectedOrigin = view.projectPoint(SCNVector3Make(0, 0, depth))
           let locationWithz   = SCNVector3Make(Float(point.x), Float(point.y), projectedOrigin.z)
           return view.unprojectPoint(locationWithz)
       }
    
    
   
}
