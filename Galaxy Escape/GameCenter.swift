//
//  GameCenter.swift
//  Galaxy Escape
//
//  Created by Harry Rollings on 29/01/2020.
//  Copyright © 2020 Harry Rollings. All rights reserved.
//

import Foundation
import GameKit

class GameCenter{
    
    static let shared = GameCenter()
    
    private init(){
        
    }
    
    func authPlayer(presentingVC: UIViewController){
        let localPlayer = GKLocalPlayer.local
        localPlayer.authenticateHandler = {
            (view, error) in
            
            if view != nil{
                presentingVC.present(view!, animated: true, completion: nil)
            }
            else{
                print(GKLocalPlayer.local.isAuthenticated)
            }
        }
    }
    
    func saveHighScore(numberToSave: Int){
        if GKLocalPlayer.local.isAuthenticated{
            let scoreReporter = GKScore(leaderboardIdentifier: "scoreLeaderboard")
            scoreReporter.value = Int64(numberToSave)
            let scoreArray: [GKScore] = [scoreReporter]
            GKScore.report(scoreArray, withCompletionHandler: nil)
        }
    }
    
    func getHighScore() -> Int64{
        if GKLocalPlayer.local.isAuthenticated{
            let score = GKScore(leaderboardIdentifier: "scoreLeaderboard", player: GKLocalPlayer.local)
            let scoreAsInt = score.value
            print("DIS SCORE")
            print(scoreAsInt)
            return scoreAsInt
        }
        else{
            print("not authenictated")
        }
        return 0
    }
    
    func checkAchievements(){
        print("WARP")
        var gamesPlayed = 0
        if UserDefaults.standard.value(forKey: "gamesplayed") != nil{
            gamesPlayed = UserDefaults.standard.value(forKey: "gamesplayed") as! Int
        }
        let play100 = GKAchievement(identifier: "play100games")
        play100.percentComplete = Double(gamesPlayed/100)
        play100.showsCompletionBanner = true
        let play200 = GKAchievement(identifier: "play200games")
        play200.percentComplete = Double(gamesPlayed/200)
        play200.showsCompletionBanner = true
        GKAchievement.report([play100, play200], withCompletionHandler: nil)
        print(play100.percentComplete)

    }
    
}
