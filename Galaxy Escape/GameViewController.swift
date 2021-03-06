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
    
    func setupGame(mode: Mode){
      
        
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
        self.sceneGame.startGame(modeParameter: mode)
        
        
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
                   if name == "replay"{
                        for view in self.endView.subviews{
                            view.removeFromSuperview()
                        }
                        setupGame(mode: sceneGame.mode)
                   }
                   else if name == "continue"{
                                          continueGame()
                                      }
                   else if name == "menu"{
                        for view in self.endView.subviews{
                            view.removeFromSuperview()
                        }
                       setupMenu()
                   }
                    else if name == "share"{
                    let textToShare = "I just achieved a score of \(String(describing: self.endScene.totalScore!)) on Galaxy Escape! Avaliable now on the App Store."

                         let objectsToShare = [textToShare]
                         let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)

                    activityVC.excludedActivityTypes = [UIActivity.ActivityType.airDrop, UIActivity.ActivityType.addToReadingList]

                    let currentViewController:UIViewController=UIApplication.shared.keyWindow!.rootViewController!

                    activityVC.popoverPresentationController?.sourceView = self.view
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        activityVC.popoverPresentationController?.sourceRect = sender.self.accessibilityFrame
                    }

                    
                    currentViewController.present(activityVC, animated: true, completion: nil)
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
                    setupGame(mode: .zen)
                   }
                   if name == "stats"{
                       showGameCenter()
                   }
                   if name == "modes"{
                       setupModes()
                   }
                    if name == "settings"{
                        setupSettings()
                    }
                   if name == "achievements"{
                       showAchievements()
                   }
               }
           }
       }
    
    func setupSettings(){
        sceneGame.removeShip()
        self.sceneView.overlaySKScene = nil

        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
        viewController.gameVC = self
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
    }
    
    func setupStore(){
        self.present(displayAlert(titleString: "Store", messageString: "Check back for future updates!"), animated: true)

    }

    func setupModes(){
        
        //displayAlert(titleString: "Modes", messageString: "Check back for future updates!")
        
        
        sceneGame.removeShip()
        self.sceneView.overlaySKScene = nil
        
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "modes") as! ModeViewController
        viewController.gameVC = self
        viewController.providesPresentationContextTransitionStyle = true
        viewController.definesPresentationContext = true
        viewController.modalPresentationStyle = .overCurrentContext
        viewController.modalTransitionStyle = .crossDissolve
        self.present(viewController, animated: true, completion: nil)
        
    }
    
    func fire(){
        sceneGame.spawnLaser()
    }
    
    func continueGame(){
        self.present(displayAlert(titleString: "Continue", messageString: "Check back for future updates!"), animated: true)

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
   
    
    func displayAlert(titleString: String, messageString: String) -> UIAlertController{
           let alertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
           let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in }
           
           alertController.addAction(OKAction)
           return alertController
           
       }
    
    func pause(){
        sceneGame.isPaused = true
        spriteScene.isPaused = true
        spriteScene.scoreTimer.invalidate()
        sceneGame.meteorTimer.invalidate()
    }
    
    func unpause(){
        sceneGame.isPaused = false
        spriteScene.isPaused = false
        sceneGame.runMeteorTimer()
        spriteScene.runScoreTimer()
        
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
