//
//  SettingsViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 20/03/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var vibswitch: UISwitch!
    var gameVC: GameViewController!
    @IBOutlet weak var leftbutton: UIButton!
    @IBOutlet weak var rightbutton: UIButton!
    @IBOutlet weak var bothbutton: UIButton!
    @IBOutlet weak var inverseswitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vibswitch.setOn(UserDefaults.standard.value(forKey: "vibrations") as! Bool, animated: false)
        inverseswitch.setOn(UserDefaults.standard.value(forKey: "inverse") as! Bool, animated: false)
        let fireBtnPos = UserDefaults.standard.value(forKey: "fireBtnPos") as! String
        setFireBtn(fireBtnPos: fireBtnPos)
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false

        // Do any additional setup after loading the view.
    }
    

    @IBAction func vibChanged(_ sender: Any) {
        let swh : UISwitch = sender as! UISwitch

       if swh.isOn {
           UserDefaults.standard.set(true, forKey: "vibrations")
       } else {
           UserDefaults.standard.set(false, forKey: "vibrations")
       }
    }
    
    @IBAction func invChanged(_ sender: Any) {
        let swh : UISwitch = sender as! UISwitch

        if swh.isOn {
          UserDefaults.standard.set(true, forKey: "inverse")
        } else {
          UserDefaults.standard.set(false, forKey: "inverse")
        }
        
    }
    
    @IBAction func left(_ sender: Any) {
        UserDefaults.standard.set("left", forKey: "fireBtnPos")
        setFireBtn(fireBtnPos: "left")
    }
    @IBAction func right(_ sender: Any) {
        UserDefaults.standard.set("right", forKey: "fireBtnPos")
        setFireBtn(fireBtnPos: "right")
    }
    @IBAction func both(_ sender: Any) {
        UserDefaults.standard.set("both", forKey: "fireBtnPos")
        setFireBtn(fireBtnPos: "both")
    }
    
    
    func setFireBtn(fireBtnPos: String){
        print(fireBtnPos)
        switch fireBtnPos {
            case "left":
                leftbutton.setTitleColor(.white, for: .normal)
                rightbutton.setTitleColor(.red, for: .normal)
                bothbutton.setTitleColor(.red, for: .normal)
            case "right":
                rightbutton.setTitleColor(.white, for: .normal)
                bothbutton.setTitleColor(.red, for: .normal)
                leftbutton.setTitleColor(.red, for: .normal)
            case "both":
                bothbutton.setTitleColor(.white, for: .normal)
                leftbutton.setTitleColor(.red, for: .normal)
                rightbutton.setTitleColor(.red, for: .normal)
            default:
                leftbutton.setTitleColor(.white, for: .normal)
                bothbutton.setTitleColor(.red, for: .normal)
                rightbutton.setTitleColor(.red, for: .normal)
        }
    }
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
