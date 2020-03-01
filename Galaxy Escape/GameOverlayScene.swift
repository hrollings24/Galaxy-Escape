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


class GameOverlayScene: SKScene {
    
    private var scoreNode: SKLabelNode!
    private var meteorLabel: SKLabelNode!
    private var laserNode: SKLabelNode!
    private var counter = 0
    var gameVC: GameViewController!
    
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func addFireButton(){
    
        let fireBtn = SKSpriteNode(imageNamed: "firebutton")
        fireBtn.size = CGSize(width: 80, height: 80)
        fireBtn.position = CGPoint(x: 80, y: 80)
        fireBtn.name = "fire"

        self.addChild(fireBtn)
    }
    
    func incrementMeteor(){
        meteorsDestroyed += 1
    }
    
    func addLaserNode(){
        print("adding laser node")
        laserNode = SKLabelNode(text: "Reloading Lasers!")
        laserNode.fontName = "DINAlternate-Bold"
        laserNode.fontColor = UIColor.white
        laserNode.fontSize = 24
        laserNode.position = CGPoint(x: self.frame.width / 2, y: self.frame.height - laserNode.frame.height - 7)
        
        self.addChild(laserNode)
    }
    
    func removeLaserNode(){
        print("removing laser node")
        laserNode?.removeFromParent()
    }
    
     override func update(_ currentTime: TimeInterval) {
           if counter >= 60 {
               score += 1
               counter = 0
           } else {
               counter += 1
           }
       }
}
