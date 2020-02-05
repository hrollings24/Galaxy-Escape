//
//  MenuSpriteScene.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 03/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import UIKit
import SpriteKit

class ModeOverlayScene: SKScene{
    
    var gameVC: UIViewController!
    
    override init(size: CGSize){
        super.init(size: size)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupScene(){
        let earthLB = SKLabelNode()
        earthLB.text = "Earth"
        earthLB.fontColor = UIColor.red
        earthLB.fontName = "SpacePatrol"
        earthLB.fontSize = 48
        earthLB.position = CGPoint(x: self.frame.width/6, y: self.frame.height/2-20)
        self.addChild(earthLB)
    }
    
}
