//
//  MainMenuViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 19/11/2019.
//  Copyright © 2019 Harry Rollings. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

   
    
    @IBOutlet var highscoreLB: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Comet Clash Background")
        self.view.insertSubview(backgroundImage, at: 0)

        

       
        highscoreLB.adjustsFontSizeToFitWidth = true
        if UserDefaults.standard.value(forKey: "highscore") == nil{
            UserDefaults.standard.set(0, forKey: "highscore")
            highscoreLB.text = "HIGHSCORE: 0"
        }
        else{
            highscoreLB.text = NSString(format: "HIGHSCORE: %i", UserDefaults.standard.value(forKey: "highscore") as! Int) as String
        }
    }}
