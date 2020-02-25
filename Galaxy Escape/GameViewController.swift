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
    var modeOverlayScene: ModeOverlayScene!
    var endScene: EndScene!
    var modesScene: Modes!
    var panGesture: UIPanGestureRecognizer!
    var tapGesture: UITapGestureRecognizer!
    var tapGestureMenu: UITapGestureRecognizer!
    var tapGestureEnd: UITapGestureRecognizer!
    var currentAngleY: Float = 0.0

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameCenter.shared.authPlayer(presentingVC: self)
        GameCenter.shared.checkAchievements()
        
        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneGame = GameScene(gameViewController: self)
        self.sceneView.scene = sceneGame
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = false
        self.sceneView.delegate = sceneGame
        self.sceneView.showsStatistics = true
        
        self.view.addSubview(self.sceneView)
        
       
        setupMenu()
        
        
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
            sceneGame.addShip()
        }

        self.menuScene = MenuScene(size: self.view.bounds.size)
        self.menuScene.gameVC = self
        self.sceneView.overlaySKScene = self.menuScene
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = true
    }
    
    func setupGame(){
      
        // add a tap gesture recognizer
        
        
        panGesture = UIPanGestureRecognizer(target: self, action:#selector(self.moveSpaceship))
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
        //var newAngleY = (Float)(delta.x)*(Float)(Double.pi)/360.0

        if sender.state == .changed {
            delta = CGPoint.init(x: 2 * (loc.x - previousLoc.x), y: 2 * (loc.y - previousLoc.y))
             sceneGame.ship.position = SCNVector3.init(sceneGame.ship.worldPosition.x + Float(delta.x * 0.02), sceneGame.ship.worldPosition.y + Float(-delta.y * (0.02)), sceneGame.ship.worldPosition.z)
            /*
            let cameraPos = SCNVector3.init(sceneGame.ship.worldPosition.x + Float(delta.x * 0.02), sceneGame.ship.worldPosition.y, sceneGame.cameraNode.worldPosition.z)
            
            let cameraAction = SCNAction.move(to: cameraPos, duration: 0.5)
            sceneGame.cameraNode.runAction(cameraAction)
            let cameraConsPos = SCNVector3.init(sceneGame.ship.worldPosition.x + Float(delta.x * 0.02), sceneGame.ship.worldPosition.y, sceneGame.cameraConstraint.worldPosition.z)
            let cameraConsAction = SCNAction.move(to: cameraConsPos, duration: 0.5)
            sceneGame.cameraConstraint.runAction(cameraConsAction)
            */
           
            if Float(delta.x * 0.02) > 0{
                sceneGame.shipleftrightmovement = .left
            }
            else if Float(delta.x * 0.02) < 0{
                sceneGame.shipleftrightmovement = .right
            }
            else{
                sceneGame.shipleftrightmovement = .still
            }
            if Float(-delta.y * (0.02)) > 0{
              sceneGame.shipupdownmovement = .down
            }
            else if Float(-delta.y * (0.02)) > 0{
              sceneGame.shipupdownmovement = .up
            }
            else{
              sceneGame.shipupdownmovement = .still
            }
            
            
            previousLoc = loc

            //newAngleY += currentAngleY
            //sceneGame.ship.eulerAngles.y = newAngleY
        }
        previousLoc = loc
        
        if(sender.state == .ended) {
            //currentAngleY = newAngleY
            sceneGame.shipleftrightmovement = .still
            
        }
    }
    
    /*
    @objc func moveSpaceship(sender: UIPanGestureRecognizer){
        
        let translation = sender.translation(in: sender.view!)
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += currentAngleY

        sceneGame.ship.eulerAngles.y = newAngleY

        if(sender.state == .ended) { currentAngleY = newAngleY }
    }
 */
    
    
    
    func endGame(){
        
        DispatchQueue.main.async {
            
            self.sceneView.removeGestureRecognizer(self.tapGesture)
            self.tapGestureEnd = UITapGestureRecognizer(target: self, action: #selector(self.tapCalledEnd))
            self.tapGestureEnd.delegate = self
            self.sceneView.addGestureRecognizer(self.tapGestureEnd)
            
            self.endScene = EndScene(size: self.view.bounds.size)
            self.endScene.gameVC = self
            self.endScene.score = self.spriteScene.score
            self.endScene.destroyed = self.spriteScene.meteorsDestroyed
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
                   if name == "modes"{
                       setupModes()
                   }
                   if name == "achievements"{
                       showAchievements()
                   }
               }
           }
       }

    func setupModes(){
        
        self.view.willRemoveSubview(sceneView)
        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.modesScene = Modes(gameViewController: self)
        self.sceneView.scene = modesScene
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = false
        
        self.view.addSubview(self.sceneView)
        
        self.modeOverlayScene = ModeOverlayScene(size: self.view.bounds.size)
        self.modeOverlayScene.gameVC = self
        self.sceneView.overlaySKScene = self.modeOverlayScene
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = true
        
        self.modeOverlayScene.setupScene()
        
        
    }
    
    func fire(){
        sceneGame.spawnLaser()
    }
    
    func showAchievements(){
        GameCenter.shared.checkAchievements()
        //showLeaderboard()
        
        sceneGame.removeShip()
        self.sceneView.overlaySKScene = nil
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "achievements") as! AchievementsViewController
        viewController.gameVC = self
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    
    func showGameCenter(){
        GameCenter.shared.checkAchievements()
        //showLeaderboard()
        
        sceneGame.removeShip()
        self.sceneView.overlaySKScene = nil
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "leaderboard") as! LeaderboardViewController
        viewController.gameVC = self
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
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
