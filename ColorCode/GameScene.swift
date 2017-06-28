//
//  GameScene.swift
//  ColorCode
//
//  Created by Kevin Zhou on 7/27/16.
//  Copyright (c) 2016 Kevin Zhou. All rights reserved.
//

import SpriteKit
import SceneKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    
    var countdownTimer:Timer!
    
    var count = 3
    var countdownNode:SKNode!
    var countDownLabel:SKLabelNode!
    var countdownBar:SKShapeNode!
    
    var ball:SKNode!
    var ballSprite:SKSpriteNode!

    var gameView:SKNode!
    
    var nextBallColor:SKColor!
    
    var moveRate:CGFloat!
    var shrinkNumber:CGFloat!
    var shrinkCounter:CGFloat!
    
    var gameStarted:Bool!
    var ballMoved:Bool!
    
    var scoreLabel:SKLabelNode!

    var passedFinish:Bool!
    
    var merging:Bool!
    
    var mode:Int!
    
    var ringInPlay:SKSpriteNode!
    var ringOnView:SKSpriteNode!
    var ringOutsideView:SKSpriteNode!
    var ringView:SKNode!
    
    var controlPanel:SKNode!
    
    var movingBall:SKSpriteNode!
    
    var updateCounter:CGFloat!
    
    var padding: CGFloat = 40.0
    
    var gameCenter: CGPoint!
    
    var selectedColor: SKColor!
    var selectedIndicator: SKShapeNode!
    
    var transitionDone:Bool!
    
    var finger:SKSpriteNode!
    
    var posSize:CGSize!
    
    var tutorialTimer:Timer!
    var inTutorial:Bool!
    var tutorialIndex:Int!
    var tutorialCover:SKShapeNode!
    
    var tutorialView:SKNode!
    
    var inIncorrect:Bool!
    
    
    var backButton:SKSpriteNode!
    enum CollisionTypes: UInt32 {
        case circle = 1
        case ball = 2
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    


    


    
    override init(size:CGSize) {
        super.init(size: size)
        
        mode = GameHandler.sharedInstance.mode
        gameCenter = CGPoint(x: self.size.width / 2, y: self.size.height / 5*3)
        gameStarted = false
        backgroundColor = SKColor(red: 53/255, green: 53/255, blue: 50/255, alpha: 1.0)
        transitionDone = true
        
        inIncorrect = false
        merging = false
        passedFinish = false
        moveRate = 150
        GameHandler.sharedInstance.score = 0
        ballMoved = false
        nextBallColor = SKColor.clear
        updateCounter = 150
        selectedColor = SKColor.red
        shrinkCounter = 0

        backButton = SKSpriteNode(imageNamed: "backButton.png")
        backButton.size = CGSize(width: 12.5, height: 31.25)
        backButton.position = CGPoint(x: backButton.size.width*1.5, y: self.size.height-45)
        addChild(backButton)
        
        scoreLabel = SKLabelNode(fontNamed: "ablax")
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = SKColor(red: 251/255, green: 252/255, blue: 235/255, alpha: 1.0)
        scoreLabel.position = CGPoint(x: self.frame.size.width-50, y: self.size.height-45)
        scoreLabel.horizontalAlignmentMode = .center
        scoreLabel.verticalAlignmentMode = .center
        
        scoreLabel.text = "0"
        addChild(scoreLabel)
        
        ball = createBall()
        
        
        ballSprite = ball.children[0] as! SKSpriteNode
        ballSprite.colorBlendFactor = 1.0

        ballSprite.alpha = 0
        
        ringView = SKNode()

        ringInPlay = createRing()
        ringView.addChild(ringInPlay)
        let ringChild = ringInPlay.children[0] as! SKSpriteNode
        let visualRingChild = ringInPlay.children[1] as! SKSpriteNode
        
        ballSprite.color = getSecondRandColor(firstColor: ringChild.color)
        
        
        
        shrinkNumber = (ringChild.frame.size.width-self.frame.width*0.2)/CGFloat(6-mode)
        posSize = CGSize(width: ringChild.size.width-shrinkNumber, height: ringChild.size.height-shrinkNumber)
        
        createControlPanel()
        
        let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
        if !launchedBefore  {
            UserDefaults.standard.set(true, forKey: "launchedBefore")
            
            tutorialCover = SKShapeNode(rect: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
            tutorialCover.fillColor = .black
            tutorialCover.alpha = 0.75
            addChild(tutorialCover)
            
            tutorialIndex = 1
            ballSprite.color = SKColor.orange
            ringChild.color = SKColor.red
            tutorialView = SKNode()
            inTutorial = true
//                self.tutorialTimer = Timer.scheduledTimer(timeInterval: 3, target: self, selector:#selector(self.runTutorial), userInfo: nil, repeats: true)
            runTutorial2()
            addChild(tutorialView)
        
        }else{
            inTutorial = false
        }
        
        addChild(ringView)
        addChild(ball)
        ballSprite.run(SKAction.fadeIn(withDuration: 0.5))
        
        
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        self.physicsWorld.contactDelegate = self
        
        let circlePath = UIBezierPath(arcCenter: gameCenter, radius: visualRingChild.size.width/2, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)

        
        // Set physics
        let physicsBody = SKPhysicsBody.init(edgeLoopFrom: circlePath.cgPath)
        self.physicsBody = physicsBody
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.isDynamic = true
        self.physicsBody!.mass = 0
        self.physicsBody!.friction = 0
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.restitution = 1
        self.physicsBody!.categoryBitMask = CollisionTypes.circle.rawValue
        self.physicsBody!.contactTestBitMask = CollisionTypes.ball.rawValue
        //self.circulo.physicsBody!.collisionBitMask = 0
        
        
        
        //Prepare ball
        
        // Set physics
        ball.physicsBody = SKPhysicsBody(circleOfRadius: 9)
        ball.physicsBody!.affectedByGravity = true
        ball.physicsBody!.restitution = 0.8
        ball.physicsBody!.linearDamping = 0
        ball.physicsBody!.friction = 0.3
        ball.physicsBody?.isDynamic = true
        ball.physicsBody!.mass = 0.5
        ball.physicsBody!.allowsRotation = true
        ball.physicsBody!.contactTestBitMask = CollisionTypes.ball.rawValue
        ball.physicsBody!.contactTestBitMask = CollisionTypes.circle.rawValue
        //ball.physicsBody!.collisionBitMask = 0
        
        
        
        
        
        
        
        delay(0.5) {
            if (!self.inTutorial) {
                self.startCountdown()
            }
        }
        
        


        

    }
    
    func startCountdown() {
        countdownNode = SKNode()
        
        countdownBar = SKShapeNode(rectOf: CGSize(width: self.size.width, height: self.size.height/15))
        countdownBar.fillColor = SKColor.black
        countdownBar.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        countDownLabel = SKLabelNode(fontNamed: "ablax")
        countDownLabel.fontColor = SKColor(red: 251/255, green: 252/255, blue: 230/255, alpha: 1.0)
        countDownLabel.fontSize = self.size.width/10
        countDownLabel.verticalAlignmentMode = .center
        countDownLabel.horizontalAlignmentMode = .center
        countDownLabel.position = countdownBar.position

        countdownNode.alpha = 0
        
        countdownNode.addChild(countdownBar)
        countdownNode.addChild(countDownLabel)
        
        addChild(countdownNode)
        

        
        delay(0.5) { 
            self.countDownLabel.text = "READY?"
            self.countdownNode.run(SKAction.fadeIn(withDuration: 0.5))
        }
        

            
        
        
        

        delay(1.25) {
            
            self.countdownTimer = Timer.scheduledTimer(timeInterval: 0.75, target: self, selector: #selector(GameScene.updateStartingCountdown), userInfo: nil, repeats: true)

            
        }




    }
    
    func updateStartingCountdown() {
        if(count > 1) {
            count -= 1
            countDownLabel.text = "SET..."
        }else if(count == 1){
            countDownLabel.text = "GO!"
            count -= 1
        }else if(count == 0){
            countDownLabel.text = nil
            count = 3
            self.countdownNode.run(SKAction.fadeOut(withDuration: 0.5))
    
            
            delay(1) {
                self.countdownNode.removeFromParent()
                self.countdownTimer.invalidate()
                self.startGame()
            }

        }
        
    }
    
    func createControlPanel() {
        controlPanel = SKNode()
        let iconSize = self.size.width*0.1
        let xMargin:CGFloat = self.frame.width/3.5
        
        let panel = SKShapeNode(rectOf: CGSize(width: self.frame.width*0.9, height: self.frame.height/10), cornerRadius: 15)
        panel.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.2)
        panel.fillColor = .black
        panel.lineWidth = 0
        panel.alpha = 0.25

        var multiplyIndex:CGFloat = 0
        
        for i in 0 ..< 3 {
            var color = SKColor()
            switch i {
            case 0:
                color = SKColor.red
                multiplyIndex = -1
            case 1:
                color = SKColor.yellow
                multiplyIndex = 0
            case 2:
                color = SKColor.blue
                multiplyIndex = 1
            default:
                color = SKColor.clear
            }
            let addSprite = SKSpriteNode(imageNamed: "ball.png")
            addSprite.position = CGPoint(x: self.frame.size.width/2+(xMargin*multiplyIndex), y: panel.position.y)
            addSprite.colorBlendFactor = 1.0
            addSprite.color = color
            addSprite.size = CGSize(width: iconSize, height: iconSize)
            controlPanel.addChild(addSprite)
        }
        selectedIndicator = SKShapeNode(rectOf: CGSize(width: iconSize, height: 5), cornerRadius: 5)
        selectedIndicator.fillColor = SKColor(red: 251/255, green: 252/255, blue: 235/255, alpha: 1)
        selectedIndicator.lineWidth = 0
        
        selectedIndicator.position = CGPoint(x: self.frame.size.width/2-xMargin, y: panel.position.y-(iconSize/2+5))
        controlPanel.addChild(selectedIndicator)
        
        controlPanel.insertChild(panel, at: 0)
        addChild(controlPanel)
    }
    
    func startGame() {

        self.gameStarted = true

    }

    override func update(_ currentTime: TimeInterval){
        if gameStarted && !(inTutorial!) {
            let inPlayVisual = ringInPlay.children[1] as! SKSpriteNode
            let inPlayRing = ringInPlay.children[0] as! SKSpriteNode
            var colorComp1 = ballSprite.color.components
            colorComp1.red = Float(round(2*Double(colorComp1.red)))/2
            colorComp1.green = Float(round(2*Double(colorComp1.green)))/2
            colorComp1.blue = Float(round(2*Double(colorComp1.blue)))/2
            
            //finger
//            if selectedColor == SKColor.yellow && tutorialIndex == 1{
//                tutorialIndex = 2
//            }else if selectedColor == SKColor.blue && tutorialIndex == 3{
//                tutorialIndex = 4
//            }
            
            if colorComp1 == inPlayRing.color.components && (transitionDone)!{
                transitionDone = false

                
                if self.moveRate < CGFloat(150+mode*50) {
                    self.moveRate = self.moveRate-CGFloat(mode)*5
                }
                shrinkCounter = 0
                let score = Int(self.scoreLabel.text!)!+1
                GameHandler.sharedInstance.score = score
                self.scoreLabel.text = "\(score)"
                

                
                self.delay(0.1) {
                    let fadingRing = self.createRing()
                    let ringToFade = fadingRing.children[0] as! SKSpriteNode
                    let visualRingToFade = fadingRing.children[1] as! SKSpriteNode
                    
                    ringToFade.size = inPlayRing.size
                    visualRingToFade.size = inPlayVisual.size
                    ringToFade.color = inPlayRing.color
                    inPlayRing.alpha = 0
                    self.insertChild(fadingRing, at: 4)
                    ringToFade.run(SKAction.fadeOut(withDuration: 0.5))
                    
                    self.physicsBody = nil
                    self.ballSprite.color = SKColor(colorLiteralRed: colorComp1.red, green: colorComp1.green, blue: colorComp1.blue, alpha: 1)
                    inPlayRing.color = self.getSecondRandColor(firstColor: self.ballSprite.color)
                    //finger
//                    if self.tutorialIndex == 3{
//                        inPlayRing.color = SKColor.purple
//                    }
                    inPlayRing.size = CGSize(width: self.frame.size.width*0.7, height: self.frame.size.width*0.7)
                    inPlayVisual.size = CGSize(width: self.frame.size.width*0.6, height: self.frame.size.width*0.6)
                    self.updatePhysicsBody()
                    inPlayRing.run(SKAction.fadeIn(withDuration: 0.1))
                    self.delay(0.5){
                        fadingRing.removeFromParent()
                    }
                }
                self.updateCounter = 50
                self.posSize = CGSize(width: self.frame.size.width*0.7-self.shrinkNumber, height: self.frame.size.width*0.7-self.shrinkNumber)
                self.delay(1) {
                    self.transitionDone = true
                }
                
            }else if (updateCounter > moveRate && (transitionDone)!){
                if Int(inPlayVisual.frame.size.width) > Int(0.1 * self.size.width) {

                    let shrinkSize = self.shrinkNumber/12
                    
                    inPlayRing.size = CGSize(width: inPlayRing.size.width-shrinkSize, height: inPlayRing.size.width-shrinkSize)
                    inPlayVisual.size = CGSize(width: inPlayVisual.size.width-shrinkSize, height: inPlayVisual.size.width-shrinkSize)
                    updatePhysicsBody()
                    
                    
                    if shrinkCounter == CGFloat(5-mode) {
//                        gameStarted = nil
                        delay(0.1){
                            self.updateCounter = 0
                            inPlayRing.run(SKAction.resize(toWidth: 0, height: 0, duration: 1.0))
                            inPlayVisual.run(SKAction.resize(toWidth: 0, height: 0, duration: 0.5))
                            self.ballSprite.run(SKAction.resize(toWidth: 0, height: 0, duration: 0.5))
                            self.shrinkCounter = 0
                            self.delay(1) {
                                self.endGame()
                            }
                        }
                    }
                    
                    
                    if inPlayRing.size.width <= posSize.width {
                        updateCounter = 0
                        NSLog("Hi")
                        shrinkCounter = shrinkCounter + 1
                        posSize = CGSize(width: inPlayRing.size.width-shrinkNumber, height: inPlayRing.size.height-shrinkNumber)

                    }
                }

        }else{
            updateCounter = updateCounter + 1
        }
 
            
        }
    }

    
    func updatePhysicsBody() {
        let inPlayVisual = ringInPlay.children[1] as! SKSpriteNode
        let circlePath = UIBezierPath(arcCenter: inPlayVisual.position, radius: inPlayVisual.size.width/2, startAngle: CGFloat(0), endAngle:CGFloat(M_PI * 2), clockwise: true)
        let physicsBody = SKPhysicsBody.init(edgeLoopFrom: circlePath.cgPath)
        self.physicsBody = physicsBody
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.usesPreciseCollisionDetection = true
        self.physicsBody!.isDynamic = true
        self.physicsBody!.mass = 0
        self.physicsBody!.friction = 0
        self.physicsBody!.linearDamping = 0
        self.physicsBody!.angularDamping = 0
        self.physicsBody!.restitution = 1
        self.physicsBody!.categoryBitMask = CollisionTypes.circle.rawValue
        self.physicsBody!.contactTestBitMask = CollisionTypes.ball.rawValue

    }
    
    func newExplosion(range: CGFloat, start: CGFloat, speed: CGFloat){
        //instantiate explosion emitter
        let explosion = SKEmitterNode(fileNamed: "explosion.sks")
        explosion?.position = gameCenter
            switch selectedColor {
            case SKColor.red:
                explosion?.particleColor = SKColor(colorLiteralRed: 51, green: 0, blue: 0, alpha: 1)
            case SKColor.yellow:
                explosion?.particleColor = SKColor(colorLiteralRed: 51, green: 51, blue: 0, alpha: 1)
            case SKColor.blue:
                explosion?.particleColor = SKColor(colorLiteralRed: 0, green: 0, blue: 51, alpha: 1)
            default:
                explosion?.particleColor = SKColor.clear
            }
        
        explosion?.numParticlesToEmit = 50

        explosion?.emissionAngleRange = range
        explosion?.emissionAngle = start
        explosion?.particleSpeed = speed
            
        insertChild(explosion!, at: self.children.count)
        delay(0.5) {
            explosion?.removeFromParent()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if inTutorial!{
            
            tutorialView.removeAllChildren()
            if tutorialIndex < 3 {
                tutorialIndex = tutorialIndex+1
                runTutorial2()
            }else{
                tutorialIndex = 0
                inTutorial = false
                tutorialCover.run(SKAction.fadeOut(withDuration: 0.5))
                delay(0.5){
                    self.tutorialCover.removeFromParent()
                    self.tutorialCover.removeFromParent()
                    self.controlPanel.removeFromParent()
                    
                    self.insertChild(self.controlPanel, at: 2)
                }
                self.startCountdown()
            }
            
            //arrows
        }else{

            let location = touches.first?.location(in: controlPanel)
            let nodesAtPoint = nodes(at: location!)
            if !nodesAtPoint.isEmpty{
                if (location?.x)! > backButton.position.x-backButton.size.width &&
                    (location?.x)! < backButton.position.x+backButton.size.width &&
                    (location?.y)! > backButton.position.y-backButton.size.height &&
                    (location?.y)! < backButton.position.y+backButton.size.height{
                    let transition = SKTransition.fade(withDuration: 0.5)
                    let titleScene = TitleScene(size: self.size)
                    self.view?.presentScene(titleScene, transition: transition)
                }else if((gameStarted)!){
                    for i in 0 ..< nodesAtPoint.count {
                        let panel = nodesAtPoint[i]
                        if floor(panel.position.y) == floor(self.frame.height*0.125) {
                            let xMargin:CGFloat = self.frame.width/3.5
                            for i in 0 ..< 3 {
                                let ballwidth = self.size.width*0.1
                                if (location?.x)! > self.frame.size.width/2+xMargin*CGFloat((i-1))-ballwidth &&
                                (location?.x)! < self.frame.size.width/2+xMargin*CGFloat((i-1))+ballwidth &&
                                (location?.y)! > panel.position.y-ballwidth &&
                                (location?.y)! < panel.position.y+ballwidth {
                                    switch i {
                                    case 0:
                                        selectedColor = SKColor.red
                                        selectedIndicator.run(SKAction.moveTo(x: self.frame.size.width/2+xMargin*CGFloat(-1), duration: 0.1))
                                    case 1:
                                        selectedColor = SKColor.yellow
                                        selectedIndicator.run(SKAction.moveTo(x: self.frame.size.width/2+xMargin*CGFloat(0), duration: 0.1))
                                    case 2:
                                        selectedColor = SKColor.blue
                                        selectedIndicator.run(SKAction.moveTo(x: self.frame.size.width/2+xMargin*CGFloat(1), duration: 0.1))
                                    default:
                                        selectedColor = SKColor.clear
                                    }
                                    
                                    
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (gameStarted)! {
            let touch = touches.first
            let location = touch?.location(in: controlPanel)
            let previousLocation = touch?.previousLocation(in: controlPanel)
            let xMargin:CGFloat = self.frame.width/3.5
            let panel = controlPanel.children[0]
            
            let ballwidth = self.size.width*0.1
            for i in 0 ..< 3 {
                if (location?.y)! > panel.position.y-ballwidth &&
                    (location?.y)! < panel.position.y+ballwidth &&
                    (location?.x)! > self.frame.size.width/2+xMargin*CGFloat((i-1))-ballwidth &&
                    (location?.x)! < self.frame.size.width/2+xMargin*CGFloat((i-1))+ballwidth {
                    switch i {
                    case 0:
                        selectedColor = SKColor.red
                        selectedIndicator.run(SKAction.moveTo(x: self.frame.size.width/2+xMargin*CGFloat(-1), duration: 0.1))
                    case 1:
                        selectedColor = SKColor.yellow
                        selectedIndicator.run(SKAction.moveTo(x: self.frame.size.width/2+xMargin*CGFloat(0), duration: 0.1))
                    case 2:
                        selectedColor = SKColor.blue
                        selectedIndicator.run(SKAction.moveTo(x: self.frame.size.width/2+xMargin*CGFloat(1), duration: 0.1))
                    default:
                        selectedColor = SKColor.clear
                    }
                    
                    
                }
            }
            
            var posBall = SKSpriteNode()
            switch selectedColor {
            case SKColor.red:
                posBall = controlPanel.children[1] as! SKSpriteNode
            case SKColor.yellow:
                posBall = controlPanel.children[2] as! SKSpriteNode
            case SKColor.blue:
                posBall = controlPanel.children[3] as! SKSpriteNode
            default:
                break
            }
            
            
            let upPos = panel.position.y+panel.frame.size.height/2
            let downPos = panel.position.y-panel.frame.size.height/2
            if !merging && (previousLocation?.y)! < upPos && (previousLocation?.y)! > downPos && (!inIncorrect){

                if (location?.y)! < downPos{
                    //right
                    var multiplyIndex:CGFloat = 0
                    switch selectedColor {
                    case SKColor.red:
                        multiplyIndex = 1
                    case SKColor.yellow:
                        multiplyIndex = 0
                    case SKColor.blue:
                        multiplyIndex = -1
                    default:
                        multiplyIndex = 0
                    }
                    
                    let bExpression1 = posBall.position.y+posBall.frame.size.width/2
                    let bExpression2 = gameCenter.y
                    let a = (self.size.width/3.5)-ballwidth/4
                    let b = (self.size.height-bExpression1-bExpression2)
                    let c = sqrt((a*a)+(b*b))
                    let angleA = asin(b/c)*CGFloat(M_PI)

                    var ballColorComp = ballSprite.color.components
                    ballColorComp.red = Float(round(2*Double(ballColorComp.red)))/2
                    ballColorComp.green = Float(round(2*Double(ballColorComp.green)))/2
                    ballColorComp.blue = Float(round(2*Double(ballColorComp.blue)))/2
                    ballSprite.color = SKColor(colorLiteralRed: ballColorComp.red, green: ballColorComp.green, blue: ballColorComp.blue, alpha: 1)
                    //finger
//                    if tutorialIndex == 2 && ballSprite.color == SKColor.orange && selectedColor == SKColor.yellow {
//                        tutorialIndex = 3
//                    }
                    let color = self.calculateColor(color: ballSprite.color, color2: self.selectedColor, add: false)
                    let colorComps = color.components
                    let inPlayRing = ringInPlay.children[0] as! SKSpriteNode
                    if multiplyIndex != 0{
                        newExplosion(range: 0, start: CGFloat(M_PI/2)+(multiplyIndex*angleA), speed: c*4)
                    }else{
                        newExplosion(range: 0, start: CGFloat(M_PI/2*3), speed: b)
                    }
                    if colorComps == inPlayRing.color.components{
                        ballSprite.run(SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.5))
                    }else{
                        showIncorrect()
                    }
                    
                    
                }else if (location?.y)! > upPos && (!inIncorrect){
                    //left

                    var colorComp = self.ballSprite.color.components
                    colorComp.red = Float(round(2*Double(colorComp.red)))/2
                    colorComp.green = Float(round(2*Double(colorComp.green)))/2
                    colorComp.blue = Float(round(2*Double(colorComp.blue)))/2
                    self.ballSprite.color = SKColor(colorLiteralRed: colorComp.red, green: colorComp.green, blue: colorComp.blue, alpha: 1)
                    
//finger
//                        if self.tutorialIndex == 4 && self.ballSprite.color == SKColor.red && self.selectedColor == SKColor.blue {
//                            self.tutorialTimer.invalidate()
//                            self.tutorialIndex = 0
//                        }
                    let color = self.calculateColor(color: self.ballSprite.color, color2: self.selectedColor, add: true)
                    let colorComps = color.components
                    let inPlayRing = self.ringInPlay.children[0] as! SKSpriteNode
                    
                        let animateBall = SKSpriteNode(imageNamed: "ball.png")
                        animateBall.size = ballSprite.size
                        animateBall.colorBlendFactor = 1.0
                        animateBall.color = selectedColor
                        animateBall.position = posBall.position
                        addChild(animateBall)
                        animateBall.run(SKAction.moveTo(x: gameCenter.x, duration: 0.2))
                        animateBall.run(SKAction.moveTo(y: gameCenter.y, duration: 0.2))
                        merging = true
                        let visualRing = ringInPlay.children[1] as! SKSpriteNode
                        delay(0.15) {
                            animateBall.run(SKAction.fadeOut(withDuration: 0.2))
                            self.delay(0.2){
                            animateBall.removeFromParent()
                                self.newExplosion(range: 360, start: 0, speed: visualRing.size.width)
                                if colorComps == inPlayRing.color.components{
                                    self.ballSprite.run(SKAction.colorize(with: color, colorBlendFactor: 1.0, duration: 0.5))
                                }else{
                                    self.showIncorrect()
                                }
                            }
                        }

                }
            }
        }


        

    }

    func showIncorrect(){
        let incorrectView = SKShapeNode(rectOf: CGSize(width: self.frame.size.width/2, height: self.frame.size.width/2), cornerRadius: 20)
        incorrectView.position = gameCenter
        incorrectView.alpha = 0
        
        let incorrectPanel = SKShapeNode(rectOf: CGSize(width: self.frame.size.width/2, height: self.frame.size.width/2), cornerRadius: 20)
        incorrectPanel.position = CGPoint(x:0, y:0)
        incorrectPanel.fillColor = .black
        incorrectPanel.alpha = 0.5
        
        
        let xMark = SKSpriteNode(imageNamed: "wrongMark.png")
        xMark.size = CGSize(width: self.frame.size.width*0.25, height: self.frame.size.width*0.25)
        xMark.position = CGPoint(x: 0, y: self.frame.size.height/32)
        
        let incorrectLabel = SKLabelNode(fontNamed: "Ablax")
        incorrectLabel.fontSize = self.frame.size.height/35
        incorrectLabel.fontColor = SKColor.white
        incorrectLabel.position = CGPoint(x: 0, y: -self.size.height/32*3)
        incorrectLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        incorrectLabel.text = "Incorrect"
        
        incorrectView.addChild(incorrectPanel)
        incorrectView.addChild(xMark)
        incorrectView.addChild(incorrectLabel)
        addChild(incorrectView)
        
        incorrectView.run(SKAction.fadeIn(withDuration: 0.1))
        inIncorrect = true
        delay(0.6){
            incorrectView.run(SKAction.fadeOut(withDuration: 0.3))
            self.delay(0.3){
                incorrectView.removeFromParent()
                self.inIncorrect = false
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        merging = false
    }

    func delay(_ delay:Double, closure:@escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }

    func didBegin(_ contact: SKPhysicsContact) {
        // elements
        if (contact.bodyA.categoryBitMask == CollisionTypes.circle.rawValue &&
            contact.bodyB.categoryBitMask == CollisionTypes.ball.rawValue) {
            print("contact between circle and ball")
        }
    }
    
    func endGame() {
        GameHandler.sharedInstance.saveGameStats()
        
        let transition = SKTransition.fade(withDuration: 0.5)
        let endGameScene = EndGame(size: self.size)
        self.view?.presentScene(endGameScene, transition: transition)
    }
    
}
