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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vibswitch.setOn(UserDefaults.standard.value(forKey: "vibrations") as! Bool, animated: false)
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false

        // Do any additional setup after loading the view.
    }
    

    @IBAction func vibChanged(_ sender: Any) {
        print("Changhing")
        let swh : UISwitch = sender as! UISwitch

       if swh.isOn {
           UserDefaults.standard.set(true, forKey: "vibrations")
       } else {
           UserDefaults.standard.set(false, forKey: "vibrations")
       }
    print(UserDefaults.standard.value(forKey: "vibrations"))
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
