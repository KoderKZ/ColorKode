//
//  TitleScene.swift
//  ColorCode
//
//  Created by Kevin Zhou on 8/12/16.
//  Copyright © 2016 Kevin Zhou. All rights reserved.
//

import Foundation

import SpriteKit

class TitleScene: SKScene {
    
    var titleSceneNode:SKSpriteNode!
    
    var modeLabel:SKLabelNode!
    var easyBall:SKNode!
    var mediumBall:SKNode!
    var hardBall:SKNode!
    var startLabel:SKLabelNode!
    var settingsIcon:SKSpriteNode!
    var movedAmount:CGFloat!
    var maskNode:SKSpriteNode!
    
    var settingsNode:SKSpriteNode!
    var settingsTitle:SKLabelNode!
    var resetScoresButton:SKLabelNode!
    var redoTutorialLabel:SKLabelNode!
    var redoTutorialImage:SKSpriteNode!
    var shareLabel:SKLabelNode!
    var redoTutorialCheck:SKSpriteNode!
    
    var inSettings:Bool!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        
        movedAmount = 0
        
        inSettings = false
        
        setUpSettings()
        
        let titleLabel = SKLabelNode(fontNamed: "Ablax")
        titleLabel.fontSize = 50
        titleLabel.fontColor = SKColor.white
        titleLabel.position = CGPoint(x: 0, y: self.size.height/4)
        titleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        titleLabel.text = "COLOR KODE"
        titleSceneNode.addChild(titleLabel)
        
        startLabel = SKLabelNode(fontNamed: "Ablax")
        startLabel.fontSize = 40
        startLabel.fontColor = SKColor.white
        startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        startLabel.position = CGPoint(x: 0, y: -self.size.height/4)
        startLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        startLabel.text = "PLAY"
        titleSceneNode.addChild(startLabel)
        
        easyBall = createBall(hardness: 1)
        let ballSprite1 = easyBall.children[0] as! SKSpriteNode
        ballSprite1.color = SKColor.green
        ballSprite1.colorBlendFactor = 1.0
        ballSprite1.size = CGSize(width: 60, height: 60)
        titleSceneNode.addChild(easyBall)
        
        mediumBall = createBall(hardness: 2)
        let ballSprite2 = mediumBall.children[0] as! SKSpriteNode
        ballSprite2.color = SKColor.yellow
        ballSprite2.colorBlendFactor = 1.0
        titleSceneNode.addChild(mediumBall)
        
        hardBall = createBall(hardness: 3)
        let ballSprite3 = hardBall.children[0] as! SKSpriteNode
        ballSprite3.color = SKColor.red
        ballSprite3.colorBlendFactor = 1.0
        titleSceneNode.addChild(hardBall)
        
        modeLabel = SKLabelNode(fontNamed: "Ablax")
        modeLabel.fontSize = 25
        modeLabel.fontColor = SKColor.white
        modeLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        modeLabel.position = CGPoint(x: 0, y: -20)
        modeLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        modeLabel.text = "EASY"
        titleSceneNode.addChild(modeLabel)
        
        settingsIcon = SKSpriteNode(imageNamed: "settingsIcon.png")
        settingsIcon.size = CGSize(width: 30, height: 36)
        settingsIcon.position = CGPoint(x: 0, y: -self.frame.size.height/2+settingsIcon.frame.height)
        titleSceneNode.addChild(settingsIcon)
        
        titleSceneNode.addChild(maskNode)
    }
    
    func setUpSettings(){
        settingsNode = SKSpriteNode(imageNamed:"settingsPage.png")
        settingsNode.size = CGSize(width: self.frame.size.width, height: self.frame.size.height/2)
        settingsNode.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/4)
        addChild(settingsNode)
        
        let settingsMargin:CGFloat = 20
        let settingsNodeMargin:CGFloat = settingsNode.frame.size.height/6
        let settingsLabelX:CGFloat = -settingsNode.frame.size.width/2+settingsMargin
        
        settingsTitle = SKLabelNode(text: "Settings")
        settingsTitle.fontSize = 40
        settingsTitle.position = CGPoint(x: settingsLabelX+settingsTitle.frame.size.width/2, y: settingsNode.frame.size.height/2-settingsTitle.frame.size.height/2-settingsMargin)
        settingsTitle.fontColor = .black
        settingsTitle.horizontalAlignmentMode = .center
        settingsTitle.verticalAlignmentMode = .center
        settingsNode.addChild(settingsTitle)
        
        createSeparator(yPos: settingsTitle.position.y-settingsTitle.frame.size.height/2-settingsNodeMargin/2)
        
        redoTutorialLabel = SKLabelNode(text: "Redo Tutorial")
        redoTutorialLabel.fontSize = 30
        redoTutorialLabel.position = CGPoint(x: settingsLabelX+redoTutorialLabel.frame.size.width/2, y: settingsTitle.position.y-settingsTitle.frame.size.height/2-settingsNodeMargin-redoTutorialLabel.frame.size.height/2)
        redoTutorialLabel.fontColor = .black
        redoTutorialLabel.horizontalAlignmentMode = .center
        redoTutorialLabel.verticalAlignmentMode = .center
        settingsNode.addChild(redoTutorialLabel)
        
        redoTutorialImage = SKSpriteNode(imageNamed: "uncheckedBox.png")
        redoTutorialImage.position = CGPoint(x: settingsMargin+redoTutorialLabel.position.x+redoTutorialLabel.frame.size.width/2,
                                             y: settingsTitle.position.y-settingsTitle.frame.size.height/2-settingsNodeMargin-redoTutorialLabel.frame.size.height/2)
        redoTutorialImage.size = CGSize(width: redoTutorialLabel.frame.size.height, height: redoTutorialLabel.frame.size.height)
        settingsNode.addChild(redoTutorialImage)

        redoTutorialCheck = SKSpriteNode(imageNamed: "check.png")
        redoTutorialCheck.position = CGPoint(x: settingsMargin+redoTutorialLabel.position.x+redoTutorialLabel.frame.size.width/2,
                                             y: settingsTitle.position.y-settingsTitle.frame.size.height/2-settingsNodeMargin-redoTutorialLabel.frame.size.height/2)
        redoTutorialCheck.size = CGSize(width: redoTutorialLabel.frame.size.height*2/3, height: redoTutorialLabel.frame.size.height*2/3)
        redoTutorialCheck.alpha = 0
        settingsNode.addChild(redoTutorialCheck)
        
        createSeparator(yPos: redoTutorialLabel.position.y-redoTutorialLabel.frame.size.height/2-settingsNodeMargin/2)
        
        resetScoresButton = SKLabelNode(text: "Reset High Scores")
        resetScoresButton.fontSize = 30
        resetScoresButton.position = CGPoint(x: settingsLabelX+resetScoresButton.frame.size.width/2,
                                             y: redoTutorialLabel.position.y-redoTutorialLabel.frame.size.height/2-settingsNodeMargin-resetScoresButton.frame.size.height/2)
        resetScoresButton.fontColor = .black
        resetScoresButton.horizontalAlignmentMode = .center
        resetScoresButton.verticalAlignmentMode = .center
        settingsNode.addChild(resetScoresButton)
        
        createSeparator(yPos: resetScoresButton.position.y-resetScoresButton.frame.size.height/2-settingsNodeMargin/2)
//
//        shareLabel = SKLabelNode(text: "Share...")
//        shareLabel.fontSize = 30
//        shareLabel.position = CGPoint(x: settingsLabelX+shareLabel.frame.size.width/2,
//                                      y: resetScoresButton.position.y-shareLabel.frame.size.height/2-settingsNodeMargin-shareLabel.frame.size.height/2)
//        shareLabel.fontColor = .black
//        shareLabel.horizontalAlignmentMode = .center
//        shareLabel.verticalAlignmentMode = .center
//        settingsNode.addChild(shareLabel)
        
        
        titleSceneNode = SKSpriteNode(color: SKColor(red: 30/255, green: 100/255, blue: 30/255, alpha: 1.0), size: self.frame.size)
        titleSceneNode.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        addChild(titleSceneNode)
        
        maskNode = SKSpriteNode(color: SKColor.black, size: self.frame.size)
        maskNode.alpha = 0
        maskNode.position = CGPoint(x: 0, y: 0)

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self)
        let previousLocation = touch?.previousLocation(in: self)

        if movedAmount > self.frame.size.width/7 {
            titleSceneNode.run(SKAction.moveTo(y: self.frame.size.height, duration: 0.5))
            maskNode.run(SKAction.fadeAlpha(to: 0.5, duration: 0.5))
            inSettings = true
        }else if ((location?.y)! > (previousLocation?.y)!) {
            movedAmount = movedAmount + (location?.y)!-(previousLocation?.y)!
        }else if movedAmount < -self.frame.size.width/5 {
            titleSceneNode.run(SKAction.moveTo(y: self.frame.size.height/2, duration: 0.5))
            maskNode.run(SKAction.fadeAlpha(to: 0, duration: 0.5))
            inSettings = false
        }else if ((location?.y)! < (previousLocation?.y)!) {
            movedAmount = movedAmount + (location?.y)!-(previousLocation?.y)!
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movedAmount = 0
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch = touches.first?.location(in: titleSceneNode)
        if !inSettings{
            let startSize = startLabel.frame.size
            let startPos = CGPoint(x: 0, y: -self.size.height/4)
            if (touch?.x)! > startPos.x-startSize.width &&
               (touch?.x)! < startPos.x+startSize.width &&
               (touch?.y)! > startPos.y-startSize.height*2 &&
               (touch?.y)! < startPos.y+startSize.height*2{
                if (easyBall.children[0] as! SKSpriteNode).size == CGSize(width: 60, height: 60) {
                    GameHandler.sharedInstance.mode = 1
                }else if (mediumBall.children[0] as! SKSpriteNode).size == CGSize(width: 60, height: 60){
                    GameHandler.sharedInstance.mode = 2
                }else if (hardBall.children[0] as! SKSpriteNode).size == CGSize(width: 60, height: 60){
                    GameHandler.sharedInstance.mode = 3
                }
                let transition = SKTransition.fade(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            }
            let ballPosY = easyBall.position.y
            let ballSize = CGSize(width: 70, height: 70)
            if (touch?.y)! > ballPosY-ballSize.height/2 &&
               (touch?.y)! < ballPosY+ballSize.height/2{
                
                let easyBallPos = easyBall.position
                let mediumBallPos = mediumBall.position
                let hardBallPos = hardBall.position
                
                let bigSize = CGSize(width: 60, height: 60)
                let smallSize = CGSize(width: 40, height: 40)
                
                let easyBallChild = easyBall.children[0] as! SKSpriteNode
                let mediumBallChild = mediumBall.children[0] as! SKSpriteNode
                let hardBallChild = hardBall.children[0] as! SKSpriteNode
                
                if (touch?.x)! > easyBallPos.x-ballSize.width/2 &&
                   (touch?.x)! < easyBallPos.x+ballSize.width/2 {
                    titleSceneNode.color = SKColor(red: 30/255, green: 100/255, blue: 30/255, alpha: 1.0)
                    easyBallChild.size = bigSize
                    mediumBallChild.size = smallSize
                    hardBallChild.size = smallSize
                    modeLabel.text = "EASY"
                }else if (touch?.x)! > mediumBallPos.x-ballSize.width/2 &&
                         (touch?.x)! < mediumBallPos.x+ballSize.width/2{
                    titleSceneNode.color = SKColor(red: 100/255, green: 100/255, blue: 30/255, alpha: 1.0)
                    easyBallChild.size = smallSize
                    mediumBallChild.size = bigSize
                    hardBallChild.size = smallSize
                    modeLabel.text = "MEDIUM"
                }else if (touch?.x)! > hardBallPos.x-ballSize.width/2 &&
                         (touch?.x)! < hardBallPos.x+ballSize.width/2{
                    titleSceneNode.color = SKColor(red: 100/255, green: 30/255, blue: 30/255, alpha: 1.0)
                    easyBallChild.size = smallSize
                    mediumBallChild.size = smallSize
                    hardBallChild.size = bigSize
                    modeLabel.text = "HARD"
                }

            }
        }else{
            touch = touches.first?.location(in: settingsNode)
            if (touch?.y)! < self.frame.size.height/8 && (touch?.y)! > 0{
                if redoTutorialCheck.alpha == 0{
                    redoTutorialCheck.alpha = 1
                    UserDefaults.standard.set(false, forKey: "launchedBefore")
                }else{
                    redoTutorialCheck.alpha = 0
                    UserDefaults.standard.set(true, forKey: "launchedBefore")
                }
            }else if (touch?.y)! < 0 && (touch?.y)! > -self.frame.size.height/8{
                GameHandler.sharedInstance.resetHighScores()
                let alert = UIAlertController(title: "High Scores Reset!", message: "", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
                self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}

