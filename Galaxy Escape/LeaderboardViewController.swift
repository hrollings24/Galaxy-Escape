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
    var scoresArray = [UIView]()

    @IBOutlet var friendSV: UIScrollView!
    @IBOutlet var worldSV: UIScrollView!
    
    @IBAction func back(_ sender: Any) {
        //dismiss VC
        self.dismiss(animated: true, completion: nil)
        gameVC.setupMenu()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        self.view.isOpaque = false
                        
        self.getScores(limit: .global)
        self.getScores(limit: .friendsOnly)
    
    }

    func getScores(limit: GKLeaderboard.PlayerScope){
        
        let leaderboard = GKLeaderboard()
        leaderboard.playerScope = limit
        leaderboard.timeScope = .allTime
        leaderboard.identifier = "scoreLeaderboard"

        leaderboard.loadScores { scores, error in
            guard let scores = scores else { return }
            var count = 0
            var array = [UIView]()
            outerloop: for score in scores {
                let nameLabel = UILabel()
                nameLabel.text = score.player.alias
                nameLabel.textColor = .white
                nameLabel.frame.size = CGSize(width: self.worldSV.frame.width/3*2, height: 40)
                nameLabel.adjustsFontSizeToFitWidth = true
                nameLabel.numberOfLines = 0
                nameLabel.font = UIFont(name: "SpacePatrol", size: 48)
                let scoreLabel = UILabel()
                scoreLabel.text = String(score.value)
                scoreLabel.adjustsFontSizeToFitWidth = true
                scoreLabel.numberOfLines = 0
                scoreLabel.textColor = .white
                scoreLabel.font = UIFont(name: "SpacePatrol", size: 48)
                scoreLabel.textAlignment = .right
                scoreLabel.frame.size = CGSize(width: self.worldSV.frame.width/3, height: 40)
                let newView = UIView()
                newView.backgroundColor = UIColor.red
                scoreLabel.frame.origin.x = self.worldSV.frame.width/3*2
                newView.sizeThatFits(CGSize(width: self.worldSV.frame.width, height: 40))
                newView.addSubview(nameLabel)
                //scoreLabel.translatesAutoresizingMaskIntoConstraints = false
                //scoreLabel.rightAnchor.constraint(equalTo: newView.rightAnchor, constant: -10).isActive = true
                newView.addSubview(scoreLabel)
                array.append(newView)
                if count < 10{
                    count += 1
                }
                else{
                    break outerloop
                }
            }
            self.addToScreen(limit: limit, array: array)
        }
    }
    
    //runs in background thread
    func addToScreen(limit: GKLeaderboard.PlayerScope, array: [UIView]) {
        var yPosition: CGFloat = 0.0
                
        for view in array{

            view.frame.origin.x = 0
            view.frame.origin.y = yPosition

            //add to scroll view
            if limit == .global{
                self.worldSV.addSubview(view)
            }
            else{
                self.friendSV.addSubview(view)
            }
            yPosition += 50
        }
        if limit == .global{
            self.worldSV.contentSize.height = yPosition
        }
        else{
            self.friendSV.contentSize.height = yPosition
        }
        
        scoresArray += array
        
        self.checkFontSizes()
        
    }
    
    func checkFontSizes(){
        var minimumSize = CGFloat(48)
        for view in scoresArray{
            let labels = view.subviews.compactMap { $0 as? UILabel }

            for label in labels {
                let fontSize = label.fontSize
                if fontSize < minimumSize{
                    minimumSize = fontSize
                }
            }
            for label in labels {
                print(minimumSize)
                label.font = label.font.withSize(minimumSize)
            }
        }
    }
    

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

}


extension UILabel {

    /// The receiver’s font size, including any adjustment made to fit to width. (read-only)
    ///
    /// If `adjustsFontSizeToFitWidth` is not `true`, this is just an alias for
    /// `.font.pointSize`. If it is `true`, it returns the adjusted font size.
    ///
    /// Derived from: [http://stackoverflow.com/a/28285447/5191100](http://stackoverflow.com/a/28285447/5191100)
    var fontSize: CGFloat {
        get {
            if adjustsFontSizeToFitWidth {
                var currentFont: UIFont = font
                let originalFontSize = currentFont.pointSize
                var currentSize: CGSize = (text! as NSString).size(withAttributes: [NSAttributedString.Key.font: currentFont])

                while currentSize.width > frame.size.width && currentFont.pointSize > (originalFontSize * minimumScaleFactor) {
                    currentFont = currentFont.withSize(currentFont.pointSize - 1)
                    currentSize = (text! as NSString).size(withAttributes: [NSAttributedString.Key.font: currentFont])
                }

                return currentFont.pointSize
            }

            return font.pointSize
        }
    }
}
