//
//  MenuScreen.swift
//  SpaceRace
//
//  Created by Cade Conklin on 4/4/17.
//  Copyright © 2017 Cade Conklin. All rights reserved.
//

//
//  GameScene.swift
//  SpaceRace
//
//  Created by Cade Conklin on 3/15/17.
//  Copyright © 2017 Cade Conklin. All rights reserved.
//

import SpriteKit
import GameplayKit
import UIKit
import AVKit
import AVFoundation

class GameScene: SKScene , SKPhysicsContactDelegate{
    
    private var sparkNode : SKEmitterNode?
    var background:SKSpriteNode!
    var startbutton:SKSpriteNode!
    var title:SKSpriteNode!
    var scrollButton:UIButton!
    var helpButton:UIButton!
    var highScoreLabel:SKLabelNode!
    var startingSize:CGFloat = 0.0
    
    
    var timer:Timer!
    var screenSize = UIScreen.main.bounds
    var location:CGPoint!
    
    
    var bgMusic:AVAudioPlayer!
    
    var menuScore:Int!
    
    var growing = true

    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        menuScore = MenuScene().getHighScore()

        
        let bgMusicURL:NSURL = Bundle.main.url(forResource: "intro song", withExtension: "wav" )! as NSURL
        do { bgMusic = try AVAudioPlayer(contentsOf: bgMusicURL as URL, fileTypeHint: nil) }
        catch _{
            return print("no music file")
        }
        bgMusic.numberOfLoops = -1
        bgMusic.prepareToPlay()
        bgMusic.play()
        
        
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0 + screenSize.width, y: 0 + screenSize.height)
        //background.size = CGSize(width: screenSize.width * 2, height: screenSize.height * 2)
        background.zPosition = -1
        self.addChild(background)
        
        startbutton = SKSpriteNode(imageNamed: "start2")
        startbutton.position = CGPoint(x: 0 + screenSize.width, y: 0 + screenSize.height)
        self.addChild(startbutton)
        
        scrollButton = UIButton(frame: CGRect(x: 0 + 25, y: screenSize.height - 60, width: 100, height: 50))
        let image = UIImage(named: "tokenfish")
        scrollButton.setImage(image, for: .normal)
        scrollButton.addTarget(self, action: #selector(scrollButtonAction(sender:)), for: .touchUpInside)
        
        helpButton = UIButton(frame: CGRect(x: screenSize.width - 100, y: screenSize.height - 60, width: 100, height: 50))
        let helpimage = UIImage(named: "help")
        helpButton.setImage(helpimage, for: .normal)
        helpButton.addTarget(self, action: #selector(helpButtonAction(sender:)), for: .touchUpInside)
        self.view?.addSubview(helpButton)
        
        title = SKSpriteNode(imageNamed: "logo")
        title.position = CGPoint(x: screenSize.width, y: (screenSize.height * 2) - title.size.height * 2.5)
        startingSize = title.size.width
        title.size = CGSize(width: title.size.width * 2, height: title.size.height * 2)
        self.addChild(title)
        
        highScoreLabel = SKLabelNode(text: "High Score: \(menuScore)")
        highScoreLabel.text = NSString(format: "Highscore: %i", menuScore) as String
        highScoreLabel.position = CGPoint(x: screenSize.width, y: ((screenSize.height * 2) / 4))
        highScoreLabel.fontName = "AmericanTypewriter-Bold"
        highScoreLabel.fontSize = 48
        highScoreLabel.fontColor = UIColor.white
        self.addChild(highScoreLabel)
        
        // Create shape node to use during mouse interaction
        self.sparkNode = SKEmitterNode(fileNamed: "Explosion3")
        self.sparkNode?.zPosition = 2
        
        if let sparkNode = self.sparkNode {
            //sparkNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            sparkNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), SKAction.fadeOut(withDuration: 0.1),
                                             SKAction.removeFromParent()]))
            
        }
        
        
        
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.045, target: self, selector: #selector(update(_:)), userInfo: nil, repeats: true)
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.sparkNode?.copy() as! SKEmitterNode? {
            n.position = pos
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if var n = self.sparkNode?.copy() as! SKEmitterNode? {
            let explosionRandom = Int(arc4random() % UInt32(5) + 1)
            n = SKEmitterNode(fileNamed: "Explosion\(explosionRandom)")!
            n.position = pos
            self.addChild(n)
            self.run(SKAction.wait(forDuration: 0.2)) {
                n.removeFromParent()
            }
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.sparkNode?.copy() as! SKEmitterNode? {
            n.position = pos
            self.addChild(n)
        }
    }
    
    
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            self.touchDown(atPoint: t.location(in: self))
            location = t.location(in: self)
            if startbutton.contains(location) {
                bgMusic.stop()
                scrollButton.isHidden = true
                helpButton.isHidden = true
                let transition = SKTransition.crossFade(withDuration: 2.0)
                
                let nextScene = MenuScene(size: scene!.size)
                nextScene.scaleMode = .aspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
            
        }
    }
    
    //movement of the spaceship
    //movement of the aliens
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch : AnyObject in touches {
            location = touch.location(in: self)
            
        }
        for t in touches { self.touchMoved(toPoint: t.location(in: self))
            
        }
    }
    
    
    
    
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    
    func scrollButtonAction(sender: UIButton!) {
        bgMusic.stop()
        scrollButton.isHidden = true
        helpButton.isHidden = true
        let transition = SKTransition.crossFade(withDuration: 1.0)
        
        let nextScene = ScrollScene(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        
        scene?.view?.presentScene(nextScene, transition: transition)
    }
    func helpButtonAction(sender: UIButton!) {
        bgMusic.stop()
        scrollButton.isHidden = true
        helpButton.isHidden = true
        let transition = SKTransition.doorsOpenHorizontal(withDuration: 1.0)
        
        let nextScene = HelpScene(size: scene!.size)
        nextScene.scaleMode = .aspectFill
        
        scene?.view?.presentScene(nextScene, transition: transition)
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if  growing == true{
            title.size.width += 2
            title.size.height += 2
        }
        if growing == false{
            title.size.width -= 2
            title.size.height -= 2
        }
        if title.size.width > startingSize * 2.5 || title.size.width < startingSize  * 2{
            growing = !growing
        }
        
    }
}
