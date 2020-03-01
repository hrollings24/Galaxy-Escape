//
//  MenuScene.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 26/01/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class MenuScene: SKScene{
    
    var gameVC: GameViewController!

    
    override init(size: CGSize) {
        super.init(size: size)
        
        setupScene()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene(){

        let logo = SKSpriteNode(imageNamed: "temp_logo")
        logo.size = CGSize(width: self.frame.width/2 -  self.frame.width/12, height: ((self.frame.width/2 -  self.frame.width/12)*1025)/1949)
        logo.position = CGPoint(x: self.frame.width/24 + logo.size.width/2, y: self.frame.height/3*2)
        self.addChild(logo)
        
        var highscoreLB = SKLabelNode()
        highscoreLB = SKLabelNode()
        highscoreLB.fontName = "SpacePatrol"
        highscoreLB.fontColor = UIColor.red
        highscoreLB.fontSize = 24
        
        highscoreLB.position = CGPoint(x: self.frame.width/24 + logo.size.width/2, y: logo.position.y - logo.size.height/2 - 30)
        if UserDefaults.standard.value(forKey: "highscore") == nil{
            //INITALISE DB
            initaliseDB()
            UserDefaults.standard.set(0, forKey: "highscore")
            highscoreLB.text = "HIGHSCORE: 0"
        }
        else{
            highscoreLB.text = NSString(format: "HIGHSCORE: %i", UserDefaults.standard.value(forKey: "highscore") as! Int) as String
        }
        
        self.addChild(highscoreLB)
        
       addButtons()
    }
    
    func addButtons(){
        let playButton = SKSpriteNode(imageNamed: "playbutton")
        playButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*535)/1712)
        playButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*6)
        playButton.name = "play"
        self.addChild(playButton)
        
        let modesButton = SKSpriteNode(imageNamed: "modesbutton")
        modesButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*535)/1712)
        modesButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*5)
        modesButton.name = "modes"
        self.addChild(modesButton)
        
        let storeButton = SKSpriteNode(imageNamed: "storebutton")
        storeButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*535)/1712)
        storeButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*4)
        storeButton.name = "store"
        self.addChild(storeButton)
        
        let achievementsButton = SKSpriteNode(imageNamed: "achievementsbutton")
        achievementsButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*535)/1712)
        achievementsButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*3)
        achievementsButton.name = "achievements"
        self.addChild(achievementsButton)
        
        let statsButton = SKSpriteNode(imageNamed: "statsbutton")
        statsButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*535)/1712)
        statsButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*2)
        statsButton.name = "stats"
        self.addChild(statsButton)
    }
    
    func initaliseDB(){
        //let achTuple: [(id: Int, name: String, barrier: Int, Progress: Int, description: String)]
        var achArray = [(id: Int, name: String, barrier: Int, Progress: Int, description: String)]()

        achArray.append((id: 1, name: "Play 100 Games", barrier: 100, Progress: 0, description: "Play 100 games to unlock this achievement"))
        achArray.append((id: 2, name: "Play 200 Games", barrier: 200, Progress: 0, description: "Play 200 games to unlock this achievement"))
        achArray.append((id: 3, name: "Destroy 200 Meteors", barrier: 200, Progress: 0, description: "Destroy 200 meteors to unlock this achievement"))
        achArray.append((id: 4, name: "Destroy 400 Meteors", barrier: 400, Progress: 0, description: "Play 400 meteors to unlock this achievement"))
        
        let db = DBHelper()
        for element in achArray{
            db.insert(id: element.id, name: element.name, barrier: element.barrier, progress: element.Progress, description: element.description)
        }
    }
    
}
