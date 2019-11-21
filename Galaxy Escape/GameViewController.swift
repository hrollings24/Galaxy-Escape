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


class GameViewController: UIViewController {

    
    var sceneView: SCNView!
    var sceneGame: GameScene!
    var spriteScene: OverlayScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneGame = GameScene()
        self.sceneView.scene = sceneGame
        self.sceneView.autoenablesDefaultLighting = true
        self.view.addSubview(self.sceneView)
        
        self.spriteScene = OverlayScene(size: self.view.bounds.size)
        self.sceneView.overlaySKScene = self.spriteScene
        self.sceneView.overlaySKScene?.isUserInteractionEnabled = false
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneGame.spawnLaser()
    }
    
   
}
