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
import GameKit


class GameViewController: UIViewController, UIGestureRecognizerDelegate, GKGameCenterControllerDelegate {

    
    var sceneView: SCNView!
    var sceneGame: GameScene!
    var spriteScene: GameOverlayScene!
    var menuScene: MenuScene!
    var endScene: EndScene!
    var panGesture: UIPanGestureRecognizer!
    var tapGesture: UITapGestureRecognizer!
    var tapGestureMenu: UITapGestureRecognizer!
    var tapGestureEnd: UITapGestureRecognizer!


   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameCenter.shared.authPlayer(presentingVC: self)
        GameCenter.shared.checkAchievements()
        
        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneGame = GameScene(gameViewController: self)
        self.sceneView.scene = sceneGame
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = false
        
        self.view.addSubview(self.sceneView)
        
       
        setupMenu()
        
        
    }
    
    func getLeaderboard(){
        
        
        
    }
    
    
    func setupMenu(){
        if tapGestureEnd != nil {
            sceneView.removeGestureRecognizer(tapGestureEnd)
            }
        //Add tap recognition
        tapGestureMenu = UITapGestureRecognizer(target: self, action: #selector(tapCalledMenu))
        tapGestureMenu.delegate = self
        sceneView.addGestureRecognizer(tapGestureMenu)
        
        if self.sceneGame.shipOnScreen == false{
            self.sceneGame.addSpaceship()
        }

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
        if tapGestureEnd != nil{
            sceneView.removeGestureRecognizer(tapGestureEnd)
        }
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapCalled))
        tapGesture.delegate = self
        sceneView.addGestureRecognizer(tapGesture)

        
        self.spriteScene = GameOverlayScene(size: self.view.bounds.size)
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
            
            self.sceneView.removeGestureRecognizer(self.tapGesture)
            self.tapGestureEnd = UITapGestureRecognizer(target: self, action: #selector(self.tapCalledEnd))
            self.tapGestureEnd.delegate = self
            self.sceneView.addGestureRecognizer(self.tapGestureEnd)
            
            self.endScene = EndScene(size: self.view.bounds.size)
            self.endScene.gameVC = self
            self.endScene.score = self.spriteScene.score
            self.endScene.setupScene()
            self.sceneView.overlaySKScene = self.endScene
            self.sceneView.overlaySKScene?.isUserInteractionEnabled = true
            
            GameCenter.shared.saveHighScore(numberToSave: self.spriteScene.score)
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
    
    @objc func tapCalledEnd(sender:UITapGestureRecognizer){
       
           if sender.state == .ended {
               var touchLocation: CGPoint = sender.location(in: sender.view)
               touchLocation = endScene.convertPoint(fromView: touchLocation)
               let touchedNode = endScene.atPoint(touchLocation)

               if let name = touchedNode.name {
                   print(name)
                   if name == "replay"{
                       setupGame()
                   }
                   else if name == "menu"{
                       setupMenu()
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
                   if name == "stats"{
                       showGameCenter()
                   }
                   if name == "replay"{
                       setupGame()
                   }
                   if name == "menu"{
                       setupMenu()
                   }
               }
           }
       }

    
    func fire(){
        sceneGame.spawnLaser()
    }
    
    
    func showGameCenter(){
        GameCenter.shared.checkAchievements()
        showLeaderboard()
        
    }
    
    
    func showLeaderboard(){
        let viewController = self.view.window?.rootViewController
        let gcvc = GKGameCenterViewController()
        
        gcvc.gameCenterDelegate = self
        
        viewController!.present(gcvc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if gestureRecognizer == panGesture && otherGestureRecognizer == tapGesture {
            return true
        }
        return false
    }
   
}
