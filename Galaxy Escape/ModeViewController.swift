//
//  ModeScene.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 03/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import SpriteKit
import SceneKit
import UIKit

class ModeViewController: UIViewController{
    var gameVC: GameViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        // Do any additional setup after loading the view.
        
    }
    @IBAction func zen(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupGame(mode: .zen)
    }
    
    @IBAction func arcade(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupGame(mode: .easy)
    }
    @IBAction func classic(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupGame(mode: .classic)
    }
    @IBAction func dash(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupGame(mode: .dash)
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }
}
