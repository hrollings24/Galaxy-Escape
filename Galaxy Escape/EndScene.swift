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
        scoreLB.fontSize = setCustomFont()
        scoreLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: self.frame.height - (self.frame.height/5))
        scoreLB.text = "Timed Score: " + "\(String(describing: score!))"
        self.addChild(scoreLB)
        
        let destroyedLB = SKLabelNode()
        destroyedLB.fontColor = UIColor.red
        destroyedLB.fontName = "SpacePatrol"
        destroyedLB.fontSize = setCustomFont()
        destroyedLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: (scoreLB.position.y) - scoreLB.frame.height)
        destroyedLB.text = "Meteors Destroyed: " + "\(String(describing: destroyed!))"
        self.addChild(destroyedLB)
        
        
        let highscoreLB = SKLabelNode()
        highscoreLB.fontName = "SpacePatrol"
        highscoreLB.fontColor = UIColor.red
        highscoreLB.fontSize = setCustomFont()
        let y = destroyedLB.position.y - destroyedLB.frame.height*2 - 70
        highscoreLB.position = CGPoint(x: self.frame.width/24 + (self.frame.width/3*2 -  self.frame.width/12)/2, y: y)
        highscoreLB.text = highScoreText()
        highscoreLB.name = "highscorenode"
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
        
        let modesButton = SKSpriteNode(imageNamed: "menuButton")
        modesButton.size = CGSize(width: self.frame.width/2 -  self.frame.width/10, height: ((self.frame.width/2 -  self.frame.width/10)*312)/1712)
        modesButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/20, y: self.frame.height/7*5)
        modesButton.name = "menu"
        self.addChild(modesButton)
        
        let shareButton = SKSpriteNode(imageNamed: "share")
        shareButton.size = CGSize(width: (self.frame.width/2 -  self.frame.width/10)/3, height: (((self.frame.width/2 -  self.frame.width/10)*248)/486)/3)
        shareButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/20, y: self.frame.height/7*2)
        shareButton.name = "share"
        self.addChild(shareButton)
        
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
        print("UPDATING")
        
        let db = DBHelper()
        let achievementsList: [Achievement] = db.read(statement: "SELECT * FROM achievement;")
        for ach in achievementsList{
            print(ach.id)
            if ach.id == 1{
                let n: Int = ach.progress + 1
                db.update(updateStatementString: "UPDATE achievement SET progress = \(n) WHERE id = \(ach.id);")
                db.update(updateStatementString: "UPDATE achievement SET percentage = \(n) WHERE id = \(ach.id);")
            }
            else if ach.id == 2{
                let n: Int = ach.progress + 1
                let px = (Float(n)/Float(ach.barrier))*100
                let p = Int(px)
                db.update(updateStatementString: "UPDATE achievement SET progress = \(n) WHERE id = \(ach.id);")
                db.update(updateStatementString: "UPDATE achievement SET percentage = \(p) WHERE id = \(ach.id);")
            }
            else if ach.id == 3{
                let n: Int = ach.progress + destroyed
                db.update(updateStatementString: "UPDATE achievement SET progress = \(n) WHERE id = \(ach.id);")
                let px = (Float(n)/Float(ach.barrier))*100
                let p = Int(px)
                db.update(updateStatementString: "UPDATE achievement SET percentage = \(p) WHERE id = \(ach.id);")
            }
            else if ach.id == 4{
                let n: Int = ach.progress + destroyed
                db.update(updateStatementString: "UPDATE achievement SET progress = \(n) WHERE id = \(ach.id);")
                let px = (Float(n)/Float(ach.barrier))*100
                let p = Int(px)
                db.update(updateStatementString: "UPDATE achievement SET percentage = \(p) WHERE id = \(ach.id);")
            }
            if ach.id == 5{
                if totalScore > 100{
                    db.update(updateStatementString: "UPDATE achievement SET progress = 100 WHERE id = \(ach.id);")
                    db.update(updateStatementString: "UPDATE achievement SET percentage = 100 WHERE id = \(ach.id);")
                }
            }
            if ach.id == 6{
                if totalScore > 200{
                    db.update(updateStatementString: "UPDATE achievement SET progress = 100 WHERE id = \(ach.id);")
                    db.update(updateStatementString: "UPDATE achievement SET percentage = 100 WHERE id = \(ach.id);")
                }
            }
            if ach.id == 7{
                if totalScore > 300{
                    db.update(updateStatementString: "UPDATE achievement SET progress = 100 WHERE id = \(ach.id);")
                    db.update(updateStatementString: "UPDATE achievement SET progress = 100 WHERE id = \(ach.id);")
                }
            }
            if ach.id == 8{
                if achievementsList[3].percentage == 100 && achievementsList[6].percentage == 100{
                    db.update(updateStatementString: "UPDATE achievement SET progress = 100 WHERE id = \(ach.id);")
                    db.update(updateStatementString: "UPDATE achievement SET percentage = 100 WHERE id = \(ach.id);")
                }
            }
            if ach.id == 9{
                if achievementsList[6].percentage == 100 && achievementsList[1].percentage == 100{
                    db.update(updateStatementString:  "UPDATE achievement SET progress = 100 WHERE id = \(ach.id);")
                    db.update(updateStatementString:  "UPDATE achievement SET percentage = 100 WHERE id = \(ach.id);")
                }
            }
        }
    }
    
    func addCounterNode() -> EFCountingLabel{
        
        let y = (self.childNode(withName: "highscorenode")?.position.y)! + 60
        let finalScoreLB = EFCountingLabel(frame: CGRect(x: self.frame.width/3 - (self.frame.width/2 -  self.frame.width/10)/2, y: y, width: self.frame.width/2 -  self.frame.width/8, height: 40))
        finalScoreLB.font = UIFont(name: "SpacePatrol", size: setCustomFont())
        finalScoreLB.adjustsFontSizeToFitWidth = true
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
    
    func setCustomFont() -> CGFloat {

           //Current runable device/simulator width find
           let bounds = UIScreen.main.bounds
           let width = bounds.size.width

           // basewidth you have set like your base storybord is IPhoneSE this storybord width 320px.
           let baseWidth: CGFloat = 1194

           // "14" font size is defult font size
           let fontSize = 64 * (width / baseWidth)

           return fontSize
       }
}
