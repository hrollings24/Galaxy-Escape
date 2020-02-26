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
import EFCountingLabel

class EndScene: SKScene {
    
    var gameVC: UIViewController!
    var score: Int!
    var destroyed: Int!
    var totalScore: Int!
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene(){
        
        totalScore = score + (destroyed*2)

        let scoreLB = SKLabelNode()
        scoreLB.fontColor = UIColor.red
        scoreLB.fontName = "SpacePatrol"
        scoreLB.fontSize = 42
        scoreLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: self.frame.height - 70)
        scoreLB.text = "Timed Score: " + "\(String(describing: score!))"
        self.addChild(scoreLB)
        
        let destroyedLB = SKLabelNode()
        destroyedLB.fontColor = UIColor.red
        destroyedLB.fontName = "SpacePatrol"
        destroyedLB.fontSize = 32
        destroyedLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: (scoreLB.position.y) - scoreLB.frame.height)
        destroyedLB.text = "Meteors Destroyed: " + "\(String(describing: destroyed!))"
        self.addChild(destroyedLB)
        
        
        let highscoreLB = SKLabelNode()
        highscoreLB.fontName = "SpacePatrol"
        highscoreLB.fontColor = UIColor.red
        highscoreLB.fontSize = 34
        let y = destroyedLB.position.y - destroyedLB.frame.height*2 - 70
        highscoreLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: y)
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
            UserDefaults.standard.set(totalScore, forKey: "highscore")
            return "NEW HIGHSCORE!"
        }
        else if (UserDefaults.standard.value(forKey: "highscore") as! Int) < totalScore{
            UserDefaults.standard.set(totalScore, forKey: "highscore")
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
    
    func addCounterNode() -> EFCountingLabel{
        
        let finalScoreLB = EFCountingLabel(frame: CGRect(x: self.frame.width/3 - (self.frame.width/2 -  self.frame.width/10)/2, y: self.frame.height/2 - 20, width: self.frame.width/2 -  self.frame.width/10, height: 40))
        finalScoreLB.font = UIFont(name: "SpacePatrol", size: 48)
        finalScoreLB.backgroundColor = UIColor.clear
        finalScoreLB.textAlignment = .center
        finalScoreLB.textColor = UIColor.red
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        finalScoreLB.setUpdateBlock { value, label in
            label.text = "Final Score: " + (formatter.string(from: NSNumber(value: Int(value))) ?? "")
        }
        finalScoreLB.counter.timingFunction = EFTimingFunction.easeInOut(easingRate: 3)
        finalScoreLB.countFrom(CGFloat(score), to: CGFloat(totalScore))
        return finalScoreLB
    }
}
