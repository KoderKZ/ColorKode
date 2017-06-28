//
//  GameHandler.swift
//  ColorCode
//
//  Created by Kevin Zhou on 8/16/16.
//  Copyright © 2016 Kevin Zhou. All rights reserved.
//

import Foundation

class GameHandler {
    var score:Int
    var highScoreEasy:Int
    var highScoreMedium:Int
    var highScoreHard:Int

    var mode:Int
    class var sharedInstance:GameHandler {
        struct Singleton {
            static let instance = GameHandler()
        }
        
        return Singleton.instance
    }
    
    init(){
        score = 0
        highScoreEasy = 0
        highScoreMedium = 0
        highScoreHard = 0
        mode = 1
        let userDefaults = UserDefaults.standard
        
        highScoreEasy = userDefaults.integer(forKey: "highScoreEasy")
        highScoreMedium = userDefaults.integer(forKey: "highScoreMedium")
        highScoreHard = userDefaults.integer(forKey: "highScoreHard")

        
    }
    
    func saveGameStats() {
        let userDefaults = UserDefaults.standard
        if mode == 1{
            highScoreEasy = max(score,highScoreEasy)
            userDefaults.set(highScoreEasy, forKey: "highScoreEasy")

        }else if mode == 2{
            highScoreMedium = max(score,highScoreMedium)
            userDefaults.set(highScoreMedium, forKey: "highScoreMedium")

        }else if mode == 3{
            highScoreHard = max(score,highScoreHard)
            userDefaults.set(highScoreHard, forKey: "highScoreHard")

        }

        


        userDefaults.synchronize()
        
    }
    func resetHighScores(){
        let userDefaults = UserDefaults.standard
        highScoreEasy = 0
        highScoreMedium = 0
        highScoreHard = 0
        userDefaults.set(0, forKey: "highScoreEasy")
        userDefaults.set(0, forKey: "highScoreEasy")
        userDefaults.set(0, forKey: "highScoreEasy")
    }
}
