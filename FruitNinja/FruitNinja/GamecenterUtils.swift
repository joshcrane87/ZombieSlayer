//
//  GamecenterUtils.swift
//  CircleJump
//
//  Created by Josh Crane on 5/22/15
//

import Foundation
import GameKit
private let _sharedGamecenterUtils = GamecenterUtils()

class GamecenterUtils : NSObject, GKGameCenterControllerDelegate {
    
    class var sharedGamecenterUtils : GamecenterUtils{
        return _sharedGamecenterUtils
    }
    
    override init(){
    }
 
    func authenticateLocalUserOnViewController(viewController:UIViewController){
        var localPlayer:GKLocalPlayer = GKLocalPlayer.localPlayer()
        if (localPlayer.authenticated == false) {
            localPlayer.authenticateHandler = {(authViewController, error) -> Void in
                if (authViewController != nil) {
                    viewController.presentViewController(authViewController,animated:false,completion: nil)
                }
            }
        }
        else {
            println("Already authenticated")
        }
    }
    func reportScore(score:Int,leaderboardID:NSString) {
        var scoreReporter:GKScore = GKScore(leaderboardIdentifier:leaderboardID as String)
        scoreReporter.value = Int64(score)
        scoreReporter.context = 0
        GKScore.reportScores([scoreReporter],withCompletionHandler: {(error) -> Void in
            if let reportError = error {
                println("Unable to report score!\nError:\(error)")
            }
            else {
                println("Score reported successfully!")
            }
        })
    }
    func showLeaderboardOnViewController(viewController:UIViewController?, leaderboardID:NSString){
        if let containerController = viewController {
            var gamecenterController:GKGameCenterViewController = GKGameCenterViewController()
            gamecenterController.gameCenterDelegate = self
            gamecenterController.viewState = GKGameCenterViewControllerState.Leaderboards
            gamecenterController.leaderboardIdentifier = leaderboardID as String
            viewController?.presentViewController(gamecenterController,animated:false,completion: nil)
        }
    }
    func gameCenterViewControllerDidFinish(_gameCenterViewController: GKGameCenterViewController!){
        _gameCenterViewController.dismissViewControllerAnimated(false,completion: nil)
    }
}