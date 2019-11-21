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
    var spriteScene: OverlayScene!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    

        self.sceneView = SCNView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        self.sceneView.scene = GameScene()
        self.sceneView.autoenablesDefaultLighting = true
        self.view.addSubview(self.sceneView)
        
    }
}
