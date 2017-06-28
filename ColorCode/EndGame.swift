//
//  EndGame.swift
//  ColorCode
//
//  Created by Kevin Zhou on 8/16/16.
//  Copyright © 2016 Kevin Zhou. All rights reserved.
//

import Foundation
import SpriteKit

class EndGame: SKScene {
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        self.backgroundColor = SKColor(red: 53/255, green: 53/255, blue: 50/255, alpha: 1.0)
        
        let titleLabel = SKLabelNode(fontNamed: "Ablax")
        titleLabel.fontSize = 50
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height/5*4)
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        titleLabel.text = "GAME OVER"
        addChild(titleLabel)
        
        let startLabel = SKLabelNode(fontNamed: "Ablax")
        startLabel.fontSize = 30
        startLabel.fontColor = SKColor.white
        startLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height/5)
        startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        startLabel.text = "Tap anywhere to restart"
        addChild(startLabel)
        
        let scoreLabel = SKLabelNode(fontNamed: "Ablax")
        scoreLabel.fontSize = 60
        scoreLabel.fontColor = SKColor.white
        scoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height/5*3)
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        scoreLabel.text = "\(GameHandler.sharedInstance.score)"
        addChild(scoreLabel)
        
        
        let highScoreLabel = SKLabelNode(fontNamed: "Ablax")
        highScoreLabel.fontSize = 30
        highScoreLabel.fontColor = SKColor.white
        highScoreLabel.position = CGPoint(x: self.size.width / 2, y: self.size.height/5*2)
        highScoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        if GameHandler.sharedInstance.mode == 1 {
            highScoreLabel.text = "Easy High Score: \(GameHandler.sharedInstance.highScoreEasy)"

        }else if GameHandler.sharedInstance.mode == 2 {
            highScoreLabel.text = "Medium High Score: \(GameHandler.sharedInstance.highScoreMedium)"

        }else if GameHandler.sharedInstance.mode == 3 {
            highScoreLabel.text = "Hard High Score: \(GameHandler.sharedInstance.highScoreHard)"

        }
        addChild(highScoreLabel)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let transition = SKTransition.fade(withDuration: 0.5)
        let gameScene = TitleScene(size: self.size)
        self.view?.presentScene(gameScene, transition: transition)
    }
    
}
