//
//  GameElements.swift
//  ColorCode
//
//  Created by Kevin Zhou on 7/28/16.
//  Copyright © 2016 Kevin Zhou. All rights reserved.
//

import SpriteKit
import Darwin
extension GameScene {

    func runTutorial() {
        let path = Bundle.main.path(forResource: "tutorial", ofType: "plist")
        let dict = NSDictionary(contentsOfFile: path!) as? [String:Any]
        finger = SKSpriteNode(imageNamed: "pointer.png")
        finger.size = CGSize(width: self.frame.size.width/10, height: self.frame.size.width/10*(94/69))
        finger.alpha = 0
        addChild(finger)
//        for i in 0 ..< (dict?.count)! {
        let string = "Step \(tutorialIndex!)"
            let step:NSDictionary = dict?[string] as! NSDictionary
            let pos1:Array = step["Position 1"] as! Array<Int>
            let pos2:Array = step["Position 2"] as! Array<Int>
            
            let controlPanelChild = controlPanel.children[0] as! SKShapeNode
            
            let xMargin = self.size.width/3.5
        
            let pos1x = (self.frame.size.width/2+xMargin*CGFloat(pos1[0]-2))+finger.frame.size.width/2
            let pos1y = (controlPanelChild.position.y + CGFloat(pos1[1]-2)*self.frame.size.height/15)-finger.frame.size.height/2
            
            let pos2x = (self.frame.size.width/2+xMargin*CGFloat(pos2[0]-2))+finger.frame.size.width/2
            let pos2y = (controlPanelChild.position.y + CGFloat(pos2[1]-2)*self.frame.size.height/15)-finger.frame.size.height/2
            
        
        
            let pos1Coords = CGPoint(x: pos1x, y: pos1y)
            let pos2Coords = CGPoint(x: pos2x, y: pos2y)
            finger.position = pos1Coords
            
//            finger.run(SKAction.move(to: pos2Coords, duration: 1))
        

            moveFinger(pos1: pos1Coords, pos2: pos2Coords)
        //crashes bc infinite loop
        
//            finger.run(SKAction.fadeOut(withDuration: 0.5) )
//            
//        }
    }
        
    func moveFinger(pos1:CGPoint, pos2:CGPoint) {
        self.finger.run(SKAction.fadeIn(withDuration: 0.5))
        delay(1){
            self.finger.run(SKAction.move(to: pos2, duration: 1))
            self.delay(1){
                self.finger.run(SKAction.fadeOut(withDuration: 0.5))
                self.delay(0.5){
                    self.finger.position = pos1
                    
                }
            }
        }

    }
    
    func runTutorial2() {
        if tutorialIndex == 1 {
            firstStep()
        }else if tutorialIndex == 2 {
            secondStep()
        }else if tutorialIndex == 3 {
            thirdStep()
        }
    }
    
    
    func firstStep(){
        let controlPanelChild = controlPanel.children[0] as! SKShapeNode
        
        
        let label = SKLabelNode(fontNamed: "Ablax")
        label.fontSize = 25
        label.fontColor = SKColor.white
        label.position = CGPoint(x: self.size.width / 2, y: controlPanelChild.position.y+controlPanelChild.frame.size.height/2+label.frame.size.height/2+10)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.text = "Add/Subtract a color"
        tutorialView.addChild(label)
        
        let label2 = SKLabelNode(fontNamed: "Ablax")
        label2.fontSize = 25
        label2.fontColor = SKColor.white
        label2.position = CGPoint(x: self.size.width / 2, y: controlPanelChild.position.y-controlPanelChild.frame.size.height/2-label.frame.size.height/2-10)
        label2.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label2.text = "from the ball to match the ring"
        tutorialView.addChild(label2)
    }
    
    func secondStep() {
        let tutorialNode1 = SKSpriteNode(imageNamed: "downArrow.png")
        let tutorialNode2 = SKSpriteNode(imageNamed: "downArrow.png")
        let tutorialNode3 = SKSpriteNode(imageNamed: "downArrow.png")
        
        let controlPanelChild = controlPanel.children[0] as! SKShapeNode
        
        let margin:CGFloat = self.frame.size.width/3.5
        
        
        tutorialNode1.size = CGSize(width: self.frame.size.width/10, height: self.frame.size.width/10)
        tutorialNode1.position = CGPoint(x:self.frame.size.width/2-margin, y:controlPanelChild.position.y-controlPanelChild.frame.size.height/2-tutorialNode1.size.height/2-10)
        
        tutorialNode2.size = CGSize(width: self.frame.size.width/10, height: self.frame.size.width/10)
        tutorialNode2.position = CGPoint(x:self.frame.size.width/2, y:controlPanelChild.position.y-controlPanelChild.frame.size.height/2-tutorialNode1.size.height/2-10)
        
        tutorialNode3.size = CGSize(width: self.frame.size.width/10, height: self.frame.size.width/10)
        tutorialNode3.position = CGPoint(x:self.frame.size.width/2+margin, y:controlPanelChild.position.y-controlPanelChild.frame.size.height/2-tutorialNode1.size.height/2-20)
        
        tutorialCover.removeFromParent()
        tutorialView.removeFromParent()
        controlPanel.removeFromParent()
        
        addChild(tutorialCover)
        addChild(tutorialView)
        addChild(controlPanel)
        
        tutorialView.addChild(tutorialNode1)
        tutorialView.addChild(tutorialNode2)
        tutorialView.addChild(tutorialNode3)
        
        let label = SKLabelNode(fontNamed: "Ablax")
        label.fontSize = 25
        label.fontColor = SKColor.white
        label.position = CGPoint(x: self.size.width / 2, y: controlPanelChild.position.y+controlPanelChild.frame.size.height/2+label.frame.size.height/2+10)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.text = "Swipe down to subtract a color"
        tutorialView.addChild(label)
    }

    
    
    func thirdStep() {
        let tutorialNode1 = SKSpriteNode(imageNamed: "upArrow.png")
        let tutorialNode2 = SKSpriteNode(imageNamed: "upArrow.png")
        let tutorialNode3 = SKSpriteNode(imageNamed: "upArrow.png")
        
        let controlPanelChild = controlPanel.children[0] as! SKShapeNode
        
        let margin:CGFloat = self.frame.size.width/3.5
        
        
        tutorialNode1.size = CGSize(width: self.frame.size.width/10, height: self.frame.size.width/5)
        tutorialNode1.position = CGPoint(x:self.frame.size.width/2-margin, y:controlPanelChild.position.y+controlPanelChild.frame.size.height/2+tutorialNode1.size.height/2+10)
        
        tutorialNode2.size = CGSize(width: self.frame.size.width/10, height: self.frame.size.width/5)
        tutorialNode2.position = CGPoint(x:self.frame.size.width/2, y:controlPanelChild.position.y+controlPanelChild.frame.size.height/2+tutorialNode1.size.height/2+10)
        
        tutorialNode3.size = CGSize(width: self.frame.size.width/10, height: self.frame.size.width/5)
        tutorialNode3.position = CGPoint(x:self.frame.size.width/2+margin, y:controlPanelChild.position.y+controlPanelChild.frame.size.height/2+tutorialNode1.size.height/2+10)
        
        tutorialView.addChild(tutorialNode1)
        tutorialView.addChild(tutorialNode2)
        tutorialView.addChild(tutorialNode3)
        
        let label = SKLabelNode(fontNamed: "Ablax")
        label.fontSize = 25
        label.fontColor = SKColor.white
        label.position = CGPoint(x: self.size.width / 2, y: controlPanelChild.position.y-controlPanelChild.frame.size.height/2-label.frame.size.height/2-20)
        label.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        label.text = "Swipe up to add a color"
        tutorialView.addChild(label)
    }
    
    func createBall() -> SKNode{
        
        let playerNode = SKNode()
        let ball = SKSpriteNode(imageNamed: "ball.png")
        ball.size = CGSize(width: self.size.width*0.1, height: self.size.width*0.1)
        playerNode.position = CGPoint(x: self.size.width / 5*2, y: self.size.height / 2 + self.size.height*0.15)
        playerNode.addChild(ball)
        
        return playerNode
    }
    
    
    
    func getRandomColor() -> SKColor{
        let randomRed:CGFloat = CGFloat(arc4random_uniform(255))/255
        let randomGreen:CGFloat = CGFloat(arc4random_uniform(255))/255
        let randomBlue:CGFloat = CGFloat(arc4random_uniform(255))/255
        
        return SKColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
        
    }
    
    func getFirstRandColor() -> SKColor {
        let randNum = arc4random_uniform(5)
        switch randNum {
        case 0:
            return SKColor.red
        case 1:
            return SKColor.orange
        case 2:
            return SKColor.yellow
        case 3:
            return SKColor.green
        case 4:
            return SKColor.blue
        case 5:
            return SKColor.purple
        default:
            return SKColor.clear
        }
    }

    func getSecondRandColor(firstColor: SKColor) -> SKColor {
        let randNum = arc4random()%2
        switch firstColor {
        case SKColor.red:
            if randNum == 0 {
                return SKColor.orange
            }else{
                return SKColor.purple
            }
        case SKColor.orange:
            if randNum == 0 {
                return SKColor.red
            }else{
                return SKColor.yellow
            }
        case SKColor.yellow:
            if randNum == 0 {
                return SKColor.green
            }else{
                return SKColor.orange
            }
        case SKColor.green:
            if randNum == 0 {
                return SKColor.blue
            }else{
                return SKColor.yellow
            }
        case SKColor.blue:
            if randNum == 0 {
                return SKColor.green
            }else{
                return SKColor.purple
            }
        case SKColor.purple:
            if randNum == 0 {
                return SKColor.blue
            }else{
                return SKColor.red
            }
        default:
            return SKColor.clear
        }
    }
    
    
    func switchKey<T, U>( myDict: inout [T:U], fromKey: T, toKey: T) {
        if let entry = myDict.removeValue(forKey: fromKey) {
            myDict[toKey] = entry
        }
    }
    
    func createRing() -> SKSpriteNode{
        let ring = SKSpriteNode()
        
        
        let ringSprite = SKSpriteNode(imageNamed: "ball.png")
        let color = getFirstRandColor()
        ringSprite.color = color
        ringSprite.colorBlendFactor = 1.0
        ringSprite.position = gameCenter
        ringSprite.size = CGSize(width: self.frame.size.width*0.7, height: self.frame.size.width*0.7)
        ring.size = CGSize(width: self.frame.size.width*0.7, height: self.frame.size.width*0.7)
        ring.addChild(ringSprite)
        
        let visualRing = SKSpriteNode(imageNamed: "ball.png")
        visualRing.size = CGSize(width: self.frame.size.width*0.6, height: self.frame.size.width*0.6)
        visualRing.colorBlendFactor = 1.0
        visualRing.color = self.backgroundColor
        visualRing.position = gameCenter
        ring.addChild(visualRing)
        
        return ring
    }
    
    func calculateColor(color: SKColor, color2: SKColor, add: Bool) -> SKColor {
        var color1comp = color.components
        color1comp.red = Float(round(10*Double(color1comp.red)))/10
        color1comp.green = Float(round(10*Double(color1comp.green)))/10
        color1comp.blue = Float(round(10*Double(color1comp.blue)))/10
        let color1 = SKColor(colorLiteralRed: color1comp.red, green: color1comp.green, blue: color1comp.blue, alpha: 1.0)
        if color1 == SKColor.blue && color2 == SKColor.yellow {
            if add {
                return SKColor.green
            }
        }else if color1 == SKColor.yellow && color2 == SKColor.blue{
            if add {
                return SKColor.green
            }
        }else if color1 == SKColor.green && color2 == SKColor.blue{
            if !add {
                return SKColor.yellow
            }
        }else if color1 == SKColor.green && color2 == SKColor.yellow{
            if !add {
                return SKColor.blue
            }
        }else if color1 == SKColor.green && color2 != SKColor.blue && color2 != SKColor.yellow{
            if !add{
                return SKColor.green
            }
        }

        if (!add) {
            if color1 != SKColor.red && color1 != SKColor.blue && color1 != SKColor.yellow {
                let red:Float = color1.components.red*2-color2.components.red
                let green:Float = color1.components.green*2-color2.components.green
                let blue:Float = color1.components.blue*2-color2.components.blue
                
                if red < 0 || green < 0 || blue < 0{
                    return color1
                }else{
                    return SKColor(colorLiteralRed: red,
                                   green: green,
                                   blue: blue,
                                   alpha: 1)
                }
                

            }else{
                return color1
            }
            
        }else{
                let red:Float = (color1.components.red+color2.components.red)/2
                let green:Float = (color1.components.green+color2.components.green)/2
                let blue:Float = (color1.components.blue+color2.components.blue)/2
                
                return SKColor(colorLiteralRed: red,
                               green: green,
                               blue: blue,
                               alpha: 1)
        }
    }


    
}

extension TitleScene {
    
    func createBall(hardness:Int) -> SKNode{
        let ball = SKNode()
        let sprite = SKSpriteNode(imageNamed: "ball")
        sprite.size = CGSize(width: 40, height: 40)
        ball.addChild(sprite)
        switch hardness {
        case 1:
            ball.position = CGPoint(x: -self.size.width/4, y: 35)
            break
        case 2:
            ball.position = CGPoint(x: 0, y: 35)
            break
        case 3:
            ball.position = CGPoint(x: self.size.width/4, y: 35)
            break
        default:
            break
        }
        
        

        
        return ball
    }

    func createSeparator(yPos:CGFloat){
        let separator = SKShapeNode(rectOf: CGSize(width: self.frame.size.width*0.9, height: 1))
        separator.fillColor = .black
        separator.lineWidth = 0
        separator.position = CGPoint(x: 0, y: yPos)
        settingsNode.addChild(separator)
    }
    
}

extension UIColor {
    
    var coreImageColor: CoreImage.CIColor? {
        return CoreImage.CIColor(color: self)  // The resulting Core Image color, or nil
    }
    
    var components:(red: Float, green: Float, blue: Float, alpha: Float) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0, a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (Float(r),Float(g),Float(b),Float(a))
    }
}
