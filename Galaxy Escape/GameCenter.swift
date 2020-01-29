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
    
    private var localPlayer = GKLocalPlayer.local
    private let leaderboardID = "scoreLeaderboard"
    private var scores: [(playerName: String, score: Int)]?
    private var leaderboard: GKLeaderboard?
    
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
        var localScore = Int64()
        if (GKLocalPlayer.local.isAuthenticated) {
            GKLeaderboard.loadLeaderboards { objects, error in
               if let e = error {
                   print(e)
               } else {
                if let leaderboards = objects {
                       for leaderboard in leaderboards {
                           if let localPlayerScore = leaderboard.localPlayerScore {
                                localScore = localPlayerScore.value
                           }
                       }
                    }
               }
           }
        }
        print(localScore)
        return localScore
    }
    
    
    func loadScores(finished: @escaping ([(playerName: String, score: Int)]?)->()) {
        // fetch leaderboard from Game Center
        fetchLeaderboard { [weak self] in
            if let localLeaderboard = self?.leaderboard {
                // set player scope as .global (it's set by default) for loading all players results
                localLeaderboard.playerScope = .global
                // load scores and then call method in closure
                localLeaderboard.loadScores { [weak self] (scores, error) in
                    // check for errors
                    if error != nil {
                        print(error!)
                    } else if scores != nil {
                        // assemble leaderboard info
                        var leaderBoardInfo: [(playerName: String, score: Int)] = []
                        for score in scores! {
                            let name = score.player.alias
                            let userScore = Int(score.value)
                            leaderBoardInfo.append((playerName: name, score: userScore))
                        }
                        self?.scores = leaderBoardInfo
                        // call finished method
                        finished(self?.scores)
                    }
                }
            }
        }
    }
    
    private func fetchLeaderboard(finished: @escaping () -> ()) {
        // check if local player authentificated or not
        if localPlayer.isAuthenticated {
            // load leaderboard from Game Center
            GKLeaderboard.loadLeaderboards { [weak self] (leaderboards, error) in
                // check for errors
                if error != nil {
                    print("Fetching leaderboard -- \(error!)")
                } else {
                    // if leaderboard exists
                    if leaderboards != nil {
                        for leaderboard in leaderboards! {
                            // find leaderboard with given ID (if there are multiple leaderboards)
                            if leaderboard.identifier == self?.leaderboardID {
                                self?.leaderboard = leaderboard
                                finished()
                            }
                        }
                    }
                }
            }
        }
    }
}
