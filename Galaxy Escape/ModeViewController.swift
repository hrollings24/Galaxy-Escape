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
    
    @IBOutlet weak var classic: UILabel!
    @IBOutlet weak var zen: UILabel!
    @IBOutlet weak var sprint: UILabel!
    @IBOutlet weak var dash: UILabel!
    
    @IBOutlet weak var powerupsdes: UILabel!
    @IBOutlet weak var sprintdes: UILabel!
    @IBOutlet weak var classicdes: UILabel!
    @IBOutlet weak var dashdes: UILabel!
    
    @IBOutlet weak var easyPlay: UIButton!
    @IBOutlet weak var dashPlay: UIButton!
    @IBOutlet weak var classicPlay: UIButton!
    @IBOutlet weak var zenPlay: UIButton!
    var acvs = [Achievement]()
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        // Do any additional setup after loading the view.
        
        let db = DBHelper()
        acvs = db.read(statement: "SELECT * FROM achievement WHERE id BETWEEN 7 AND 9;")
        
        easyPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 42))
        classicPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 42))
        zenPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 42))
        dashPlay.titleLabel?.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 42))
        
        zen.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 48))
        sprint.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 48))
        classic.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 48))
        dash.font = UIFont(name: "SpacePatrol", size: setCustomFont(baseFont: 48))

        powerupsdes.font = UIFont.systemFont(ofSize: setCustomFont(baseFont: 32))
        sprintdes.font = UIFont.systemFont(ofSize: setCustomFont(baseFont: 32))
        classicdes.font = UIFont.systemFont(ofSize: setCustomFont(baseFont: 32))
        dashdes.font = UIFont.systemFont(ofSize: setCustomFont(baseFont: 32))
        powerupsdes.adjustsFontSizeToFitWidth = true
        sprintdes.adjustsFontSizeToFitWidth = true
        classicdes.adjustsFontSizeToFitWidth = true
        dashdes.adjustsFontSizeToFitWidth = true

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
    
    @IBAction func arcade(_ sender: UIButton){
        
        if sender.titleLabel?.text == "locked"{
            let String = "Unlock by achieving " + acvs[2].name
            self.present(gameVC.displayAlert(titleString: "Mode Locked", messageString: String), animated: true)
        }
        else{
 
            self.dismiss(animated: true, completion: nil)
            gameVC.setupGame(mode: .sprint)
        }
    }
    
    @IBAction func classic(_ sender: UIButton) {
        if sender.titleLabel?.text == "locked"{
            let String = "Unlock by achieving " + acvs[0].name
            self.present(gameVC.displayAlert(titleString: "Mode Locked", messageString: String), animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
            gameVC.setupGame(mode: .classic)
        }
    }
    
    @IBAction func dash(_ sender: UIButton) {
       if sender.titleLabel?.text == "locked"{
            let String = "Unlock by achieving " + acvs[1].name
            self.present(gameVC.displayAlert(titleString: "Mode Locked", messageString: String), animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
            gameVC.setupGame(mode: .dash)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }
    
    func setCustomFont(baseFont: CGFloat) -> CGFloat {

              //Current runable device/simulator width find
              let bounds = UIScreen.main.bounds
              let width = bounds.size.width

              // basewidth you have set like your base storybord is IPhoneSE this storybord width 320px.
              let baseWidth: CGFloat = 1194

              // "14" font size is defult font size
              let fontSize = baseFont * (width / baseWidth)

              return fontSize
          }
}
