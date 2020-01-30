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


class OverlayScene: SKScene {
    
    var scoreNode: SKLabelNode!
    var counter = 0
    var gameVC: GameViewController!
    
    var score = 0 {
        didSet {
            scoreNode.text = "Score: \(self.score)"
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
    
    
    
     override func update(_ currentTime: TimeInterval) {
           if counter >= 30 {
               score += 1
               counter = 0
               scoreNode.text = "Score: \(self.score)"
           } else {
               counter += 1
           }
        
       }
}
