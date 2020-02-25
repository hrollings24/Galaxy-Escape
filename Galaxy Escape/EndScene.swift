//
//  EndScene.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 29/01/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation

import SpriteKit
import UIKit


class EndScene: SKScene {
    
    var gameVC: UIViewController!
    var score: Int!
    var destroyed: Int!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene(){
        
        let scoreLB = SKLabelNode()
        scoreLB.fontColor = UIColor.red
        scoreLB.fontName = "SpacePatrol"
        scoreLB.fontSize = 48
        scoreLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: self.frame.height - 70)
        scoreLB.text = "Score: " + "\(String(describing: score!))"
        self.addChild(scoreLB)
        
        let destroyedLB = SKLabelNode()
        destroyedLB.fontColor = UIColor.red
        destroyedLB.fontName = "SpacePatrol"
        destroyedLB.fontSize = 32
        destroyedLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: (self.frame.height - 70) - scoreLB.frame.height - 30)
        destroyedLB.text = "Meteors Destroyed: " + "\(String(describing: destroyed!))"
        self.addChild(destroyedLB)
        
        let highscoreLB = SKLabelNode()
        highscoreLB.fontName = "SpacePatrol"
        highscoreLB.fontColor = UIColor.red
        highscoreLB.fontSize = 34
        highscoreLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: (self.frame.height - 70) - destroyedLB.frame.height*2 - 60)
        highscoreLB.text = highScoreText()
        self.addChild(highscoreLB)
        
        addButtons()
        incrementStats()
    }
    
    func addButtons(){
        let playButton = SKSpriteNode(imageNamed: "replayButton")
        playButton.size = CGSize(width: self.frame.width/2 -  self.frame.width/10, height: ((self.frame.width/2 -  self.frame.width/10)*312)/1712)
        playButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/20, y: self.frame.height/7*6)
        playButton.name = "replay"
        self.addChild(playButton)
        
        let modesButton = SKSpriteNode(imageNamed: "continueButton")
        modesButton.size = CGSize(width: self.frame.width/2 -  self.frame.width/10, height: ((self.frame.width/2 -  self.frame.width/10)*312)/1712)
        modesButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/20, y: self.frame.height/7*5)
        modesButton.name = "continue"
        self.addChild(modesButton)
        
        let storeButton = SKSpriteNode(imageNamed: "menuButton")
        storeButton.size = CGSize(width: self.frame.width/2 -  self.frame.width/10, height: ((self.frame.width/2 -  self.frame.width/10)*312)/1712)
        storeButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/20, y: self.frame.height/7*4)
        storeButton.name = "menu"
        self.addChild(storeButton)
        
    }
    
    func highScoreText() -> String{
        if UserDefaults.standard.value(forKey: "highscore") == nil{
            UserDefaults.standard.set(score, forKey: "highscore")
            return "NEW HIGHSCORE!"
        }
        else if (UserDefaults.standard.value(forKey: "highscore") as! Int) < score{
            UserDefaults.standard.set(score, forKey: "highscore")
            return "NEW HIGHSCORE!"
        }
        else{
            return NSString(format: "HIGHSCORE: %i", UserDefaults.standard.value(forKey: "highscore") as! Int) as String
        }
    }
    
    
    func incrementStats(){
        
        //increment amount of games played
        if UserDefaults.standard.value(forKey: "gamesplayed") == nil{
            UserDefaults.standard.set(1, forKey: "gamesplayed")
        }
        else{
            let gamesPlayed = (UserDefaults.standard.value(forKey: "gamesplayed") as! Int) + 1
            UserDefaults.standard.set(gamesPlayed, forKey: "gamesplayed")
        }
    }

}
