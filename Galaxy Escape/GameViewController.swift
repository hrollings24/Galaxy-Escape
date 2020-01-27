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


class GameViewController: UIViewController, UIGestureRecognizerDelegate {

    
    var sceneView: SCNView!
    var sceneGame: GameScene!
    var spriteScene: OverlayScene!
    var menuScene: MenuScene!
    var panGesture: UIPanGestureRecognizer!
    var tapGesture: UITapGestureRecognizer!
    var tapGestureMenu: UITapGestureRecognizer!


    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneGame = GameScene(gameViewController: self)
        self.sceneView.scene = sceneGame
        self.sceneView.autoenablesDefaultLighting = true
        
        self.view.addSubview(self.sceneView)
        
        //Add tap recognition
        tapGestureMenu = UITapGestureRecognizer(target: self, action: #selector(tapCalledMenu))
        tapGestureMenu.delegate = self
        sceneView.addGestureRecognizer(tapGestureMenu)

        self.menuScene = MenuScene(size: self.view.bounds.size)
        self.menuScene.gameVC = self
        self.sceneView.overlaySKScene = self.menuScene
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = true
        
    }
    
    func setupGame(){
      
        // add a tap gesture recognizer
        panGesture = UIPanGestureRecognizer(target: self, action:#selector(moveSpaceship))
        panGesture.maximumNumberOfTouches = 1
        panGesture.delegate = self
        sceneView.addGestureRecognizer(panGesture)
        
        sceneView.removeGestureRecognizer(tapGestureMenu)
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCalled))
        tapGesture.delegate = self
        sceneView.addGestureRecognizer(tapGesture)

        
        
        self.spriteScene = OverlayScene(size: self.view.bounds.size)
        self.spriteScene.gameVC = self
        self.sceneView.overlaySKScene = self.spriteScene
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = true
        
        self.sceneGame.startGame()
        
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
    
    func endGame(){
        
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "endSegue", sender: self)
        }
        
    }
    
    @objc func tapCalled(sender:UITapGestureRecognizer){
    
        if sender.state == .ended {
            var touchLocation: CGPoint = sender.location(in: sender.view)
            touchLocation = spriteScene.convertPoint(fromView: touchLocation)
            let touchedNode = spriteScene.atPoint(touchLocation)

            if let name = touchedNode.name {
                if name == "fire"{
                    fire()
                }
            }
        }
    }
    
    @objc func tapCalledMenu(sender:UITapGestureRecognizer){
       
           if sender.state == .ended {
               var touchLocation: CGPoint = sender.location(in: sender.view)
               touchLocation = menuScene.convertPoint(fromView: touchLocation)
               let touchedNode = menuScene.atPoint(touchLocation)

               if let name = touchedNode.name {
                   if name == "play"{
                       setupGame()
                   }
               }
           }
       }

    
    func fire(){
        sceneGame.spawnLaser()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if segue.destination is EndViewController
        {
            let vc = segue.destination as? EndViewController
            vc?.score = spriteScene.score
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer == panGesture && otherGestureRecognizer == tapGesture {
            return true
        }
        return false
    }
   
}
