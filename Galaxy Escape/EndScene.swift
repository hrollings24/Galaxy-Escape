//
//  EndScene.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 29/01/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit
import UIKit


class EndScene: SKScene {
    
    var gameVC: UIViewController!
    
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
        
       addButtons()
    }
    
    func addButtons(){
        let playButton = SKSpriteNode(imageNamed: "replayButton")
        playButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*312)/1712)
        playButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*6)
        playButton.name = "replay"
        self.addChild(playButton)
        
        let modesButton = SKSpriteNode(imageNamed: "continueButton")
        modesButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*312)/1712)
        modesButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*5)
        modesButton.name = "continue"
        self.addChild(modesButton)
        
        let storeButton = SKSpriteNode(imageNamed: "menuButton")
        storeButton.size = CGSize(width: self.frame.width/3 -  self.frame.width/10, height: ((self.frame.width/3 -  self.frame.width/10)*312)/1712)
        storeButton.position = CGPoint(x: (self.frame.width - playButton.size.width/2) -  self.frame.width/12, y: self.frame.height/7*4)
        storeButton.name = "menu"
        self.addChild(storeButton)
        
    }

}
