//
//  EndViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 21/01/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import UIKit

class EndViewController: UIViewController {

    @IBOutlet var scoreLB: UILabel!
    @IBOutlet var highscoreLB: UILabel!
    
    var score: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupView()
        
    }
    
    func setupView(){
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Comet Clash Background")
        self.view.insertSubview(backgroundImage, at: 0)

        
        scoreLB.adjustsFontSizeToFitWidth = true
        highscoreLB.adjustsFontSizeToFitWidth = true
        scoreLB.text = "\(score!)"
        
        highScore()
      
       
    }

    @IBAction func replay(_ sender: Any) {
        let vc : AnyObject! = self.storyboard!.instantiateViewController(withIdentifier: "GameScene")
        self.show(vc as! UIViewController, sender: vc)
    }
    
    @IBAction func menu(_ sender: Any) {
    }
    
    func highScore(){
        if UserDefaults.standard.value(forKey: "highscore") == nil{
            UserDefaults.standard.set(score, forKey: "highscore")
            highscoreLB.text = "NEW HIGHSCORE!"
        }
        else if (UserDefaults.standard.value(forKey: "highscore") as! Int) < score!{
            UserDefaults.standard.set(score, forKey: "highscore")
            highscoreLB.text = "NEW HIGHSCORE!"
        }
        else{
            highscoreLB.text = NSString(format: "HIGHSCORE: %i", UserDefaults.standard.value(forKey: "highscore") as! Int) as String
        }
    }
}
