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
    var endView: UIView!

    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        endView = UIView()
        GameCenter.shared.authPlayer(presentingVC: self)
        GameCenter.shared.checkAchievements()
        
        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneGame = GameScene(gameViewController: self)
        self.sceneView.scene = sceneGame
        self.sceneView.autoenablesDefaultLighting = true
        self.sceneView.allowsCameraControl = false
        self.sceneView.delegate = sceneGame
        
        self.view.addSubview(self.sceneView)
        
       
        setupMenu()
        
        
    }
    
    func setupMenu(){
        sceneGame.resetCamera()

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

        self.endView.removeFromSuperview()
        self.menuScene = MenuScene(size: self.view.bounds.size)
        self.menuScene.gameVC = self
        self.sceneView.overlaySKScene = self.menuScene
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = true
    }
    
    func setupGame(){
      
        
        // add a tap gesture recognizer
        
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
        
        self.endView.removeFromSuperview()
        self.sceneGame.startGame()
        
        
    }
    
    
    
    var previousLoc = CGPoint.init(x: 0, y: 0)
 
    
    
    func endGame(){
        
        DispatchQueue.main.async {
            
            self.sceneGame.playing = false
            
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
            let cn = self.endScene.addCounterNode()
            self.endView.addSubview(cn)
            self.sceneView.addSubview(self.endView)
            
            GameCenter.shared.saveHighScore(numberToSave: self.endScene.totalScore)
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
                        for view in self.endView.subviews{
                            view.removeFromSuperview()
                        }
                       setupGame()
                   }
                    if name == "continue"{
                                          continueGame()
                                      }
                   else if name == "menu"{
                        for view in self.endView.subviews{
                            view.removeFromSuperview()
                        }
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
                    if name == "store"{
                        setupStore()
                    }
                   if name == "achievements"{
                       showAchievements()
                   }
               }
           }
       }
    
    func setupStore(){
        displayAlert(titleString: "Store", messageString: "Check back for future updates!")

    }

    func setupModes(){
        
        displayAlert(titleString: "Modes", messageString: "Check back for future updates!")
        
        /*
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
 
         */
        
        
    }
    
    func fire(){
        sceneGame.spawnLaser()
    }
    
    func continueGame(){
        displayAlert(titleString: "Continue", messageString: "Check back for future updates!")
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
   
    
    func displayAlert(titleString: String, messageString: String){
           let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
           
           alertController.addAction(OKAction)
           
           self.present(alertController, animated: true)
       }
}
