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
 
 class ScrollScene: SKScene , SKPhysicsContactDelegate{
    var background:SKSpriteNode!
    
    var screenSize = UIScreen.main.bounds
    var Screen:CGRect!
    var location:CGPoint!
    
    var scroll:SKSpriteNode!
    
    
    var bgMusic:AVAudioPlayer!
    
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        
        let bgMusicURL:NSURL = Bundle.main.url(forResource: "backstory", withExtension: "wav" )! as NSURL
        do { bgMusic = try AVAudioPlayer(contentsOf: bgMusicURL as URL, fileTypeHint: nil) }
        catch _{
            return print("no music file")
        }
        bgMusic.numberOfLoops = 0
        bgMusic.prepareToPlay()
        bgMusic.play()
        
        Screen = CGRect(x: 0, y: 0, width: screenSize.width * 2, height: screenSize.height * 2)
        
        background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 0 + screenSize.width, y: 0 + screenSize.height)
        background.zPosition = -1
        self.addChild(background)
        
        scroll = SKSpriteNode(imageNamed: "scroll")
        scroll.position = CGPoint(x: (0 + screenSize.width) , y: 0 - scroll.size.height / 2)
        scroll.size = CGSize(width: Screen.width, height: scroll.size.height)
        self.addChild(scroll)
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
       
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
    }
    
    
    
    
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            
            self.touchDown(atPoint: t.location(in: self))
            location = t.location(in: self)
            if Screen.contains(location) {
                bgMusic.stop()
                let transition = SKTransition.reveal(with: .down, duration: 1.0)
                
                let nextScene = GameScene(size: scene!.size)
                nextScene.scaleMode = .aspectFill
                
                scene?.view?.presentScene(nextScene, transition: transition)
            }
            
            
        }
    }
    
    
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
    
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        scroll.position.y += 0.25
        
    }
 }
