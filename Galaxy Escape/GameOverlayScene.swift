//
//  OverlayScore.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 21/11/2019.
//  Copyright © 2019 Harry Rollings. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

enum PowerType{
    case slow
    case unlimitedLasers
    case invincible
    case lifesaver
    case double
    case none

}

class GameOverlayScene: SKScene {
    
    private var scoreNode: SKLabelNode!
    private var meteorLabel: SKLabelNode!
    private var laserNode: SKLabelNode!
    private var counter = 0
    var gameVC: GameViewController!
    var scoreAdd: Int!
    var powerActive: Bool!
    var givePowerupAt: Int!
    var scoreTimer: Timer!
    
    var score = 0 {
        didSet {
            scoreNode.text = "Score: \(self.score)"
        }
    }
    var meteorsDestroyed = 0 {
        didSet {
            meteorLabel.text = "Destroyed: \(self.meteorsDestroyed)"
        }
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        scoreAdd = 1
        powerActive = false
                
        addFireButton()
        
        self.backgroundColor = UIColor.clear
                
        scoreNode = SKLabelNode(text: "Score: 0")
        scoreNode.fontName = "DINAlternate-Bold"
        scoreNode.fontColor = UIColor.white
        scoreNode.fontSize = 24
        scoreNode.position = CGPoint(x: scoreNode.frame.width + 5, y: self.frame.height - scoreNode.frame.height - 7)
        
        self.addChild(scoreNode)
        
        meteorsDestroyed = 0
        meteorLabel = SKLabelNode(text: "Destroyed: 0")
        meteorLabel.fontName = "DINAlternate-Bold"
        meteorLabel.fontColor = UIColor.white
        meteorLabel.fontSize = 24
        meteorLabel.position = CGPoint(x: self.frame.width - (scoreNode.frame.width + 5), y: self.frame.height - scoreNode.frame.height - 7)
        
        self.addChild(meteorLabel)
        givePowerupAt = 5
        runScoreTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addFireButton(){
    
        let fireBtn = SKSpriteNode(imageNamed: "firebutton")


        fireBtn.size = CGSize(width: 80, height: 80)
        if UserDefaults.standard.value(forKey: "fireBtnPos") as! String == "left"{
            fireBtn.position = CGPoint(x: 80, y: 80)
        }
        else if UserDefaults.standard.value(forKey: "fireBtnPos") as! String == "right"{
            fireBtn.position = CGPoint(x: self.frame.width - 80, y: 80)
        }
        else{
            fireBtn.position = CGPoint(x: self.frame.width - 80, y: 80)
            let fireBtnDup = SKSpriteNode(imageNamed: "firebutton")
            fireBtnDup.size = CGSize(width: 80, height: 80)
            fireBtnDup.position = CGPoint(x: 80, y: 80)
            fireBtnDup.name = "fire"
            self.addChild(fireBtnDup)
        }
        fireBtn.name = "fire"

        self.addChild(fireBtn)
    }
    
    func incrementMeteor(){
        meteorsDestroyed += 1
        if meteorsDestroyed == givePowerupAt && gameVC.sceneGame.mode != .classic{
            let typed: PowerType = randomPower()
            if !(UserDefaults.standard.value(forKey: "powerup") as! Bool) {
                DispatchQueue.main.async{
                    //first time recieving a powerup!
                    //PAUSE GAME
                    UserDefaults.standard.set(true, forKey: "powerup")
                    self.gameVC.pause()
                    let alert = UIAlertController(title: "Powerup!", message: "After destroying meteors, you recieve one of these powerups: Unlimited Lasers, Double Score or a Slowdown", preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: { action in
                        //run your function here
                        self.gameVC.unpause()
                        self.runPowerup(type: typed)
                    }))
                    self.gameVC.present(alert, animated: true, completion: nil)
                }
            }
            else{
                runPowerup(type: typed)
            }
        }
    }
    
    func addLaserNode(){
        if !powerActive{
            print("adding laser node")
            laserNode = SKLabelNode(text: "Reloading Lasers!")
            laserNode.fontName = "DINAlternate-Bold"
            laserNode.fontColor = UIColor.white
            laserNode.fontSize = 24
            laserNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - laserNode.frame.height - 7)
            
            self.addChild(laserNode)
        }
    }
    
    func removeLaserNode(){
        print("removing laser node")
        laserNode?.removeFromParent()
    }
    
    @objc func incrementScore(){
        score += scoreAdd
    }
    
    func runPowerup(type: PowerType){
        powerActive = true
        switch type {
        case .double:
            scoreAdd = 2
            addPowerupNode(text: "Double Score")
            Timer.scheduledTimer(withTimeInterval: 3, repeats: false){ timer in
                self.scoreAdd = 1
                self.removeLaserNode()
                self.powerActive = false
                self.givePowerupAt = self.meteorsDestroyed + 7
                
            }
        case .slow:
            gameVC.sceneGame.speed = gameVC.sceneGame.speed*0.9
            self.powerActive = false
            addPowerupNode(text: "Slow")
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false){ timer in
                self.removeLaserNode()
                self.powerActive = false
                self.givePowerupAt = self.meteorsDestroyed + 7
            }
        case .unlimitedLasers:
            gameVC.sceneGame.laserLimit = 100
            addPowerupNode(text: "Unlimited Lasers")
            Timer.scheduledTimer(withTimeInterval: 4, repeats: false){ timer in
                self.gameVC.sceneGame.laserLimit = 5
                self.removeLaserNode()
                self.powerActive = false
                self.givePowerupAt = self.meteorsDestroyed + 7
           }
        default:
            //none
            break
        }
        

    }
    
    func randomPower() -> PowerType{
        var randomType: PowerType!
        let ranInt = Int.random(in: 0..<3)
        switch ranInt{
        case 0:
            randomType = PowerType.slow
        case 1:
            randomType = PowerType.unlimitedLasers
        case 2:
            randomType = PowerType.double
        default:
            randomType = PowerType.none
        }
        return randomType
    }
    
    func addPowerupNode(text: String){
        removeLaserNode()
        laserNode = SKLabelNode(text: text)
        laserNode.fontName = "DINAlternate-Bold"
        laserNode.fontColor = UIColor.white
        laserNode.fontSize = 24
        laserNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - laserNode.frame.height - 7)

        self.addChild(laserNode)
        
    }
    
    func runScoreTimer(){
        scoreTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.incrementScore), userInfo: nil, repeats: true)

    }
}
