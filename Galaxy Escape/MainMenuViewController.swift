//
//  MainMenuViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 19/11/2019.
//  Copyright © 2019 Harry Rollings. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        backgroundImage.image = UIImage(named: "Comet Clash Background")
        self.view.insertSubview(backgroundImage, at: 0)

        let logo = UIImage(named: "temp_logo.png")
        let logoView = UIImageView(image: logo)
        var logoHeight = (self.view.frame.size.height/2) - (self.view.frame.size.height/20)
        var logoWidth = (logoHeight/40)*87
        if logoWidth > self.view.frame.size.width/2{
            logoWidth = (self.view.frame.size.width / 2) - (self.view.frame.size.height/20)
            logoHeight = (logoWidth/87)*40
        }
        logoView.frame = CGRect(x: (self.view.frame.size.height/20), y: (self.view.frame.size.height/20), width: logoWidth, height: logoHeight)
                
        self.view.addSubview(logoView)
        
        let highscoreText = UILabel()
        highscoreText.frame = CGRect(x: (self.view.frame.size.height/20), y: (self.view.frame.size.height/20)+logoHeight+10, width: logoWidth, height: self.view.frame.size.height/6)
        highscoreText.adjustsFontSizeToFitWidth = true
        highscoreText.font = UIFont(name: "SpacePatrol", size: 200)
        highscoreText.numberOfLines = 0
        self.view.addSubview(highscoreText)
        
        if UserDefaults.standard.value(forKey: "highscore") == nil{
            UserDefaults.standard.set(0, forKey: "highscore")
            highscoreText.text = "HIGHSCORE: 0"
        }
        else{
            highscoreText.text = NSString(format: "HIGHSCORE: %i", UserDefaults.standard.value(forKey: "highscore") as! Int) as String
        }
        
        
        let playButton = UIButton(frame: CGRect(x: (self.view.frame.size.width/2), y: (self.view.frame.size.height/20)+logoHeight+10, width: logoWidth, height: self.view.frame.size.height/6))
        playButton.backgroundColor = .green
        playButton.setTitle("Play", for: .normal)
        playButton.addTarget(self, action: #selector(playPressed), for: .touchUpInside)

        self.view.addSubview(playButton)

    }
    
    @objc func playPressed(sender: UIButton!) {
        print("Button tapped")
        performSegue(withIdentifier: "playGame", sender: self)
    }


  

}
