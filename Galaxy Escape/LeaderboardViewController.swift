//
//  LeaderboardViewController.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 04/02/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import GameKit

class LeaderboardViewController: UIViewController, GKGameCenterControllerDelegate {

    var gameVC: GameViewController!

    
    @IBOutlet var friendSV: UIScrollView!
    @IBOutlet var worldSV: UIScrollView!
    
    @IBAction func back(_ sender: Any) {
        //dismiss VC
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }
    
    var scoreArray = [UIView]()
    var friendArray = [UIView]()

    let worldGroup = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
        
        worldGroup.enter()
                
        DispatchQueue.main.async {
            self.getWorldwideScores()
            self.getFriendsScores()
        }

        worldGroup.notify(queue: .main) {
            var yPosition: CGFloat = 0.0
            var yPositionFriend: CGFloat = 0.0

            print("BOO")
            print(self.scoreArray.count)
            print(self.friendArray.count)


            for view in self.scoreArray{

                view.frame.origin.x = 0
                view.frame.origin.y = yPosition

                //add to scroll view
                self.worldSV.addSubview(view)
                yPosition += 50
            }
            self.worldSV.contentSize.height = yPosition
            
            for view in self.friendArray{

                view.frame.origin.x = 0
                view.frame.origin.y = yPositionFriend

                //add to scroll view
                self.friendSV.addSubview(view)
                yPositionFriend += 50
            }
            self.worldSV.contentSize.height = yPositionFriend
        }
    }

    func getWorldwideScores(){
        
        let leaderboard = GKLeaderboard()
        leaderboard.playerScope = .global
        leaderboard.timeScope = .allTime
        leaderboard.identifier = "scoreLeaderboard"

        leaderboard.loadScores { scores, error in
            guard let scores = scores else { return }
            var count = 0
            outerloop: for score in scores {
                let nameLabel = UILabel()
                nameLabel.text = score.player.alias
                nameLabel.textColor = .white
                nameLabel.frame.size = CGSize(width: self.worldSV.frame.width/2, height: 40)
                nameLabel.adjustsFontSizeToFitWidth = true
                nameLabel.numberOfLines = 0
                nameLabel.font = nameLabel.font.withSize(48)
                let scoreLabel = UILabel()
                scoreLabel.text = String(score.value)
                scoreLabel.adjustsFontSizeToFitWidth = true
                scoreLabel.numberOfLines = 0
                scoreLabel.textColor = .white
                scoreLabel.font = scoreLabel.font.withSize(48)
                scoreLabel.textAlignment = .right
                scoreLabel.frame.size = CGSize(width: self.worldSV.frame.width/2, height: 40)
                let newView = UIView()
                newView.backgroundColor = UIColor.red
                scoreLabel.frame.origin.x = self.worldSV.frame.width/2
                newView.sizeThatFits(CGSize(width: self.worldSV.frame.width, height: 40))
                newView.addSubview(nameLabel)
                //scoreLabel.translatesAutoresizingMaskIntoConstraints = false
                //scoreLabel.rightAnchor.constraint(equalTo: newView.rightAnchor, constant: -10).isActive = true
                print(nameLabel)
                newView.addSubview(scoreLabel)
                self.scoreArray.append(newView)
                if count < 10{
                    count += 1
                }
                else{
                    break outerloop
                }
            }
        }
    }
    
    func getFriendsScores(){
        let leaderboard = GKLeaderboard()
        leaderboard.playerScope = .friendsOnly
        leaderboard.timeScope = .allTime
        leaderboard.identifier = "scoreLeaderboard"

        leaderboard.loadScores { scores, error in
            guard let scores = scores else { return }
            var count = 0
            outerloop: for score in scores {
                let nameLabel = UILabel()
                nameLabel.text = score.player.alias
                nameLabel.textColor = .white
                nameLabel.frame.size = CGSize(width: self.worldSV.frame.width/2, height: 40)
                nameLabel.adjustsFontSizeToFitWidth = true
                nameLabel.numberOfLines = 0
                nameLabel.font = nameLabel.font.withSize(48)
                let scoreLabel = UILabel()
                scoreLabel.text = String(score.value)
                scoreLabel.adjustsFontSizeToFitWidth = true
                scoreLabel.numberOfLines = 0
                scoreLabel.textColor = .white
                scoreLabel.font = scoreLabel.font.withSize(48)
                scoreLabel.textAlignment = .right
                scoreLabel.frame.size = CGSize(width: self.worldSV.frame.width/2, height: 40)
                let newView = UIView()
                newView.backgroundColor = UIColor.red
                scoreLabel.frame.origin.x = self.worldSV.frame.width/2
                newView.sizeThatFits(CGSize(width: self.worldSV.frame.width, height: 40))
                newView.addSubview(nameLabel)
                //scoreLabel.translatesAutoresizingMaskIntoConstraints = false
                //scoreLabel.rightAnchor.constraint(equalTo: newView.rightAnchor, constant: -10).isActive = true
                newView.addSubview(scoreLabel)
                self.friendArray.append(newView)
                if count < 10{
                    count += 1
                }
                else{
                    break outerloop
                }
            }
            self.worldGroup.leave()
        }
    }
    

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

}
