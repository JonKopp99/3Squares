//
//  GameScene.swift
//  ThreeSquares
//
//  Created by Jonathan Kopp on 10/1/18.
//  Copyright © 2018 Jonathan Kopp. All rights reserved.
//
import Firebase
import SpriteKit
import Foundation
import GameplayKit
import Darwin
import UIKit


class GameScene: SKScene, UITextFieldDelegate{
var viewController: UIViewController?
var score = 0
var highScore = 0
var scoreText = SKLabelNode()
var statis = true
var lives = 0
var heart1 = SKSpriteNode(imageNamed: "rheart.png")
var heart2 = SKSpriteNode(imageNamed: "rheart.png")
var heart3 = SKSpriteNode(imageNamed: "rheart.png")

var button = UIButton()
var publish = UIButton()
var buttState = true
var disableCol = false
var moveInterval = 0.5
var daNum = 0.0
    
    
    override func didMove(to view: SKView) {
        // Called when the scene has been displayed
        drawSquares(name:"One");
        drawSquares(name:"Two");
        drawSquares(name:"Three");
        score = 0
        lives = 3
        scoreText.text = String(score)
        scoreText.fontSize = 65
        scoreText.fontColor = SKColor.green
        scoreText.position = CGPoint(x:view.bounds.width / 2, y:view.bounds.height-80)
        heart1.scale(to: CGSize(width: 20, height: 20))
        heart1.position = CGPoint(x: 20, y:view.bounds.height-20)
        heart1.name = "heart1"
        addChild(heart1)
        
        heart2.scale(to: CGSize(width: 20, height: 20))
        heart2.position = CGPoint(x: 40, y:view.bounds.height-20)
        heart2.name = "heart2"
        addChild(heart2)
        
        heart3.scale(to: CGSize(width: 20, height: 20))
        heart3.position = CGPoint(x: 60, y:view.bounds.height-20)
        heart3.name = "heart3"
        addChild(heart3)
        
        button = UIButton(frame: CGRect(x: view.bounds.width-50, y: 0, width: 50, height: 50))
        
        
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
    
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        self.view!.addSubview(button)
        highScore = loadHighScore()
       // let userDefaults = Foundation.UserDefaults.standard
        //userDefaults.set(0, forKey: "Key")
        
        
    }
    
    //Pause button pressed function
    @objc func buttonAction(sender: UIButton!) {
        if(buttState)
        {
            
            button.setImage(#imageLiteral(resourceName: "play"), for: .normal)
            drawPause()
            buttState=false
            childNode(withName: "One")?.isPaused = true
            childNode(withName: "Two")?.isPaused = true
            childNode(withName: "Three")?.isPaused = true
        }
        else
        {
            
            button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
            buttState = true
            removePause()
            childNode(withName: "One")?.isPaused = false
            childNode(withName: "Two")?.isPaused = false
            childNode(withName: "Three")?.isPaused = false
        }
    }
    
    
    //Creates the heart falling down animation
    func heartAnimation(pos:CGPoint)
    {
        let hearta = SKSpriteNode(imageNamed: "rheart.png")
        hearta.position = pos
        hearta.scale(to: CGSize(width: 20, height: 20))
        hearta.alpha = 1
        let fade = SKAction(named: "heart")!
        addChild(hearta)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fade,remove])
        hearta.run(sequence)
    }
    
    
    //turns squares red when one goes out of bounds
    func damage()
    {
        let action = SKAction(named: "dealDamage")
        childNode(withName: "One")?.run(action!)
        childNode(withName: "Two")?.run(action!)
        childNode(withName: "Three")?.run(action!)

    }
    
    
    //Adds square animation when one is tapped upon
    func squareAnimation(pos: CGPoint)
    {
        let size = CGSize(width: 80, height: 80)
        let square = SKSpriteNode(texture: nil, color: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), size: size)
        square.position = pos
        addChild(square)
        var fade = SKAction(named: "fade")!
        if(disableCol)
        {
            square.color = #colorLiteral(red: 0.2078431373, green: 1, blue: 0, alpha: 1)
            fade = SKAction(named: "fade2")!
        }
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fade,remove])
        square.run(sequence)
    }
    
    
    //draws the pause scene
    func drawPause()
    {
        self.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
        updateHighScore()
        //Squares
        let size = CGSize(width: (view?.bounds.width)!-20, height: 300)
        let square = SKSpriteNode(texture: nil, color: #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1), size: size)
        let disableColors = SKSpriteNode(texture: nil, color: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), size: CGSize(width: (view?.bounds.width)!-40, height: 60))
        let hs = SKSpriteNode(texture: nil, color: #colorLiteral(red: 1, green: 0.2527923882, blue: 1, alpha: 1), size: CGSize(width: (view?.bounds.width)!-40, height: 60))
        let ps = SKSpriteNode(texture: nil, color: #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1), size: CGSize(width: (view?.bounds.width)!-40, height: 60))
        
        square.alpha = 0.70
        //High Score label Node
        let pL = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
        pL.text = "High Score: \(highScore)"
        pL.fontSize = 45
        pL.fontColor = SKColor.white
        //Disable colors label node
        let dcL = SKLabelNode(fontNamed: "AvenirNextCondensed-Regular")
        dcL.text = "Disable Flashy Colors"
        dcL.fontSize = 30
        dcL.fontColor = SKColor.white
        
        //HomeLabel
        let hsL = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
        hsL.text = "Home"
        hsL.fontSize = 45
        hsL.fontColor = SKColor.white
        
        let psL = SKLabelNode(fontNamed: "AvenirNextCondensed-Bold")
        psL.text = "Resume"
        psL.fontSize = 45
        psL.fontColor = SKColor.white
        if(self.disableCol)
        {
            disableColors.color = #colorLiteral(red: 0, green: 0.4784313725, blue: 1, alpha: 1)
            dcL.fontColor = SKColor.white
            dcL.text = "Enable Flashy Colors"
        }
        else{
            dcL.fontColor = SKColor.black
            disableColors.color = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
        //Positon Setter
        if let view = self.view{
            square.position.x = view.bounds.width / 2
            square.position.y = view.bounds.height / 2
            disableColors.position.x = view.bounds.width / 2
            disableColors.position.y = view.bounds.height / 2 + 40
            hs.position.x = view.bounds.width / 2
            hs.position.y = view.bounds.height / 2-100
            ps.position.x = view.bounds.width / 2
            ps.position.y = view.bounds.height / 2-30
            
            pL.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 100)
            dcL.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 + 25)
            hsL.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 115)
            psL.position = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2 - 45)
        }
        disableColors.name = "dColors"
        square.name = "pauseSquare"
        hs.name = "Home"
        ps.name = "Resume"
        pL.name = "pauseLabel"
        dcL.name = "dColorsLabel"
        hsL.name = "HomeL"
        psL.name = "ResumeL"
        
       
        addChild(square)
        addChild(disableColors)
        addChild(hs)
        addChild(ps)
        
        addChild(pL)
        addChild(dcL)
        addChild(hsL)
        addChild(psL)
    }
    
    //Resume to game
    func resumePressed()
    {
        buttState = true
        removePause()
        button.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        childNode(withName: "One")?.isPaused = false
        childNode(withName: "Two")?.isPaused = false
        childNode(withName: "Three")?.isPaused = false
        
    }
    
    //Removes all the pause nodes that were added to the view
    func removePause()
    {
        childNode(withName: "pauseSquare")?.removeFromParent()
        childNode(withName: "pauseLabel")?.removeFromParent()
        childNode(withName: "dColors")?.removeFromParent()
        childNode(withName: "dColorsLabel")?.removeFromParent()
        childNode(withName: "Home")?.removeFromParent()
        childNode(withName: "HomeL")?.removeFromParent()
        childNode(withName: "Resume")?.removeFromParent()
        childNode(withName: "ResumeL")?.removeFromParent()
    }
    
    
    //draws all the hearts
    func drawHearts()
    {
        for k in 1...3 {
            childNode(withName: "heart\(String(k))")?.removeFromParent()
        }
        if(lives==3)
        {
           heart1.position.y = view!.bounds.height-20
           heart2.position.y = view!.bounds.height-20
           heart3.position.y = view!.bounds.height-20
           addChild(self.heart1)
           heart1.run(SKAction(named: "heartFadeBack")!)
           addChild(self.heart2)
           heart2.run(SKAction(named: "heartFadeBack")!)
           addChild(self.heart3)
           heart3.run(SKAction(named: "heartFadeBack")!)
        }
        else if(lives==2)
        {
            addChild(self.heart1)
            addChild(self.heart2)
        }
        else if(lives==1)
        {
            addChild(self.heart1)
        }
        else{}
            
    }
    
    //Used for end game scene with fading colors!
    override func update(_ currentTime: TimeInterval) {
        if(statis == false && disableCol == false)
        {
            if (self.daNum >= 1){
                self.daNum = 0.0
            }
            else
            {
                self.daNum += 0.01
            }
            //color t=color(c,255,255);
            //let color = UIColor(displayP3Hue: CGFloat(daNum), saturation: 1, brightness: 1)
            let color = UIColor(hue: CGFloat(self.daNum), saturation: 1, brightness: 1, alpha: 1)
            self.backgroundColor = color
        }
        
    }
    
    
    //updates score
    func updateScore()
    {
        scoreText.removeFromParent()
        scoreText.text = String(score)
        addChild(scoreText)
    }
    
    //Sets username by textField.
    func setUserName()
    {
        statis = true
        self.backgroundColor = #colorLiteral(red: 0.3333333433, green: 0.3333333433, blue: 0.3333333433, alpha: 1)
        let textFieldFrame = CGRect(origin: CGPoint(x: (view?.bounds.width)!/2, y: (view?.bounds.height)!/2), size: CGSize(width: (view?.bounds.width)!-20, height: 30))
        let textField = UITextField(frame: textFieldFrame)
        textField.delegate = self
        textField.returnKeyType = .done
        //textField.characterRange(at: CGPoint(x: 0, y: 12))
        textField.center = (self.view?.center)!
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Enter Name (14 characters max)"
        
        view?.addSubview(textField)
        
    
        
        
        //let userDefaults = Foundation.UserDefaults.standard
        //userDefaults.set(username, forKey: "Username")
    }
    
    
    //Adds text to userDefaults
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        
        textField.resignFirstResponder()
        var newText = textField.text!
        if(textField.text!.count>10){
            newText = newText[0..<15]
        }
        let userDefaults = Foundation.UserDefaults.standard
        userDefaults.set(newText, forKey: "Username")
        textField.removeFromSuperview()
        return true
    }
    
    
    //Loads username from userdefaults
    func getUserName()->String
    {
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.string(forKey: "Username")
        if(value==nil)
        {
            return ""
        }
        return value!
    }
    
    //Saves highscore to userdefualts
    func saveHighScore()
    {
        if(score>=highScore)
        {
            let userDefaults = Foundation.UserDefaults.standard
            userDefaults.set(highScore, forKey: "Key")
        }
    }
    
    //loads highscore from userdefualts
    func loadHighScore()->Int
    {
        let userDefaults = Foundation.UserDefaults.standard
        let value = userDefaults.integer(forKey: "Key")
        return value
    }
    
    
    //Returns a random color as long as flashy colors are enabled
    func ranColor()->SKColor
    {
        var ranColor = #colorLiteral(red: 0.2078431373, green: 1, blue: 0, alpha: 1)
        if(self.disableCol==false)
        {
        let ran1 = CGFloat(arc4random_uniform(UInt32(255 - 0 + 1)))
        let ran2 = CGFloat(arc4random_uniform(UInt32(255 - 0 + 1)))
        let ran3 = CGFloat(arc4random_uniform(UInt32(255 - 0 + 1)))
        ranColor = SKColor(displayP3Red: ran1/255, green: ran2/255, blue: ran3/255, alpha: 1)
        }
        
        return ranColor
    }
    

    
    //draws the restart scene
    func restartSquare()
    {
        scoreText.removeFromParent()
        scoreText.fontSize = 30
        scoreText.text = "GAME OVER SCORE: \(String(score))"
        let rT = SKLabelNode(fontNamed: "AvenirNext-Regular")
        rT.name = "RestartL"
        rT.text = "Tap to Restart"
        rT.fontSize = 45
        rT.fontColor = SKColor.white
        let size2 = CGSize(width: 280, height: 80)
        let square2 = SKSpriteNode(texture: nil, color: UIColor.clear, size: size2)
        
        square2.name = "Restart"
        if let view = self.view{
            square2.position.x = view.bounds.width / 2
            square2.position.y = view.bounds.height/2
            rT.position = CGPoint(x:view.bounds.width / 2, y:view.bounds.height/2)
            square2.size = CGSize(width: view.bounds.width, height: view.bounds.height)
        }
        addChild(square2)
        addChild(rT)
        addChild(scoreText)
        saveHighScore()
        
        if(score>=highScore)
        {
            publish = UIButton(frame: CGRect(x: 0, y: (view?.bounds.height)! - 80, width: (view?.bounds.width)!, height: 80))
            
            publish.backgroundColor = .white
            publish.setTitle("Add highscore to leaderboard", for: .normal)
            publish.setTitleColor(.black, for: .normal)
            publish.addTarget(self, action: #selector(publishButtonAction), for: .touchUpInside)
            self.view!.addSubview(publish)
        }
    }
    
    
    //Adds their highscore to the firebase!
    @objc func publishButtonAction(sender: UIButton!) {
        if(getUserName()=="")
        {
            setUserName()
        }
        else
        {
            
            let userDefaults = Foundation.UserDefaults.standard
            var value = userDefaults.string(forKey: "UID")
            if(value==nil)
            {
                let ref2 = Database.database().reference().childByAutoId().key
                
                userDefaults.set(ref2, forKey: "UID")
                value=ref2
            }
            let ref = Database.database().reference().child("HighScores").child(value!)
            ref.child("score").setValue(self.highScore)
            ref.child("name").setValue(getUserName())
            
            self.viewController!.performSegue(withIdentifier: "goL", sender: self)
            
        }
    }
    
    
    //updates hihgscore
    func updateHighScore()
    {
        if(self.score>=self.highScore)
        {
            self.highScore = self.score
        }
    }
    
    
    //Everything important happens here. This is where i check all interactions
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let positionInScene = touch.location(in: self)
            let name = self.atPoint(positionInScene).name
            if name != nil{
                if(buttState){
                    if(name!=="One"||name!=="Two"||name!=="Three")
                    {
                        let color = childNode(withName: name!) as! SKSpriteNode
                        if(disableCol==false)
                        {
                            self.backgroundColor = color.color
                        }
                        
                        
                        squareAnimation(pos: childNode(withName: name!)!.position)
                        childNode(withName: name!)?.removeFromParent()
                        self.drawSquares(name: name!)
                        updateHighScore()
                        score += 1
                        updateScore()
                        
                    }
                    
                    
                }
                if(name!=="Resume"||name!=="ResumeL")
                {
                    resumePressed()
                }
                if(name!=="dColors"||name!=="dColorsLabel")
                {
                    
                    if(self.disableCol)
                    {
                        self.disableCol = false
                    }
                    else{
                        self.backgroundColor = #colorLiteral(red: 0.1298420429, green: 0.1298461258, blue: 0.1298439503, alpha: 1)
                        self.disableCol = true
                    }
                    self.removePause()
                    self.drawPause()
                }
                if(name! == "Home"||name! == "HomeL")
                {
                    self.homePressed()
                }
                if(name! == "Restart"||name! == "RestartL")
                {
                    removeAllChildren()
                    self.statis=true
                    self.lives=3
                    self.drawHearts()
                    self.score=0
                    self.moveInterval = 0.5
                    self.drawSquares(name:"One");
                    self.drawSquares(name:"Two");
                    self.drawSquares(name:"Three");
                    scoreText.fontSize = 65
                    button.isHidden = false
                    
                    for v in view!.subviews{
                        if v is UIButton{
                            let v2 = v as! UIButton
                            if(v2.titleLabel!.text == "Add highscore to leaderboard")
                            {
                                v2.removeFromSuperview()
                            }
                        }
                        if v is UITextField{
                            v.removeFromSuperview()
                        }
                    }
                    
                    
                }
            }
        }
    }
    
    
    //Seques to home
    func homePressed()
    {
        self.removeAllChildren()
        self.viewController!.performSegue(withIdentifier: "toHome", sender: self)
    }
    
    //how fast the squares will move!
    func getMoveAction(down: Bool)->SKAction
    {
        var moveDec = 0.004
        
        
        
        if(self.score<50)
        {
            moveDec = 0.0035
        }
        else if(self.score>50)
        {
            moveDec = 0.0015
        }
        else if(self.score>300)
        {
            moveDec = 0.001
        }

        if(self.moveInterval>0.01)
        {
            self.moveInterval-=moveDec
        }
 
        if(down==false)
        {
            return SKAction.moveBy(x: 0, y: -100, duration: self.moveInterval)
        }
        return SKAction.moveBy(x: 0, y: 100, duration: self.moveInterval)
    }
   
    
    //Draws the square nodes and gives them all actions!
    func drawSquares(name: String)
    {
        
        let size = CGSize(width: 80, height: 80)
        let square = SKSpriteNode(texture: nil, color: ranColor(), size: size)
        square.name = name
        //true up false down
        var downOrUp = true
        if(Int.random(in: 0 ... 10)==5)//
        {
            downOrUp = false
        }
        if let view = self.view{
            //let bounds = CGFloat.random(in: 80 ... view.bounds.width-40)
            //square.position.x = CGFloat(arc4random_uniform(UInt32((view.bounds.width) - 0 + 1)))
            square.position.x = CGFloat.random(in: 40 ... view.bounds.width-40)
            square.position.y = 40
            if(downOrUp==false)//
            {
                square.position.y = view.bounds.height + 40
            }
        }
        let huh = SKAction.customAction(withDuration: 0.001) { (square, _) in
            if(square.position.y>(self.view?.bounds.height)!+80 || square.position.y < -80)//
            {
                square.position.x = CGFloat.random(in: 40 ... (self.view?.bounds.width)!-40)
                square.position.y = 40
                if(downOrUp==false)
                {
                    square.position.y = self.view!.bounds.height + 40
                }
                //self.childNode(withName: "heart\(String(self.lives))")?.removeFromParent()
                let pos = self.childNode(withName: "heart\(String(self.lives))")?.position
                self.heartAnimation(pos: pos!)
                //self.childNode(withName: "heart\(String(self.lives))")?.run(SKAction(named: "heart")!)
                self.lives-=1
                self.drawHearts()
                self.damage()
                
                
                if(self.lives<=0)
                {
                    self.statis=false
                    self.restartSquare()
                    self.childNode(withName: "One")?.removeFromParent()
                    self.childNode(withName: "Two")?.removeFromParent()
                    self.childNode(withName: "Three")?.removeFromParent()
                    self.updateHighScore()
                    self.button.isHidden = true
                }
            }
           
        }
        let group = SKAction.sequence([getMoveAction(down: downOrUp),huh])
        if(statis){
            let repeatAnimation = SKAction.repeatForever(group)
            square.run(repeatAnimation)
            addChild(square)
    }
}
    
    
}

//An extension so i can substring a string easier because swift makes it annoying to do.
extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let idx1 = index(startIndex, offsetBy: max(0, range.lowerBound))
        let idx2 = index(startIndex, offsetBy: min(self.count, range.upperBound))
        return String(self[idx1..<idx2])
    }
}
