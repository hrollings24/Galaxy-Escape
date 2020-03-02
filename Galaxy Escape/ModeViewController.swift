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
    
    @IBOutlet weak var easyPlay: UIButton!
    @IBOutlet weak var dashPlay: UIButton!
    @IBOutlet weak var classicPlay: UIButton!
    @IBOutlet weak var zenPlay: UIButton!
    var acvs = [Achievement]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        // Do any additional setup after loading the view.
        
        let db = DBHelper()
        acvs = db.read(statement: "SELECT * FROM achievement WHERE id BETWEEN 7 AND 9;")
        
        easyPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: 32)
        classicPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: 32)
        zenPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: 32)
        dashPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: 32)

        var btnArray = [UIButton]()
        btnArray.append(classicPlay)
        btnArray.append(dashPlay)
        btnArray.append(easyPlay)

        var counter = 0
        for ach in acvs{
            if ach.percentage != 100{
                btnArray[counter].setTitle("locked", for: .normal)
            }
            counter += 1
        }
        
    }
    @IBAction func zen(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupGame(mode: .zen)
    }
    
    @IBAction func arcade(_ sender: UIButton) {
        if sender.titleLabel?.text == "locked"{
            let String = "Unlock by achieving " + acvs[2].name
            self.present(gameVC.displayAlert(titleString: "Mode Locked", messageString: String), animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
            gameVC.setupGame(mode: .easy)
        }
    }
    
    @IBAction func classic(_ sender: UIButton) {
        if sender.titleLabel?.text == "locked"{
            let String = "Unlock by achieving " + acvs[0].name
            self.present(gameVC.displayAlert(titleString: "Mode Locked", messageString: String), animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
            gameVC.setupGame(mode: .easy)
        }
    }
    
    @IBAction func dash(_ sender: UIButton) {
       if sender.titleLabel?.text == "locked"{
            let String = "Unlock by achieving " + acvs[1].name
            self.present(gameVC.displayAlert(titleString: "Mode Locked", messageString: String), animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
            gameVC.setupGame(mode: .easy)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }
}
