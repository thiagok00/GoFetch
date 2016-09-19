//
//  HomeScene.swift
//  GoFetch
//
//  Created by Ana Luiza Ferrer on 9/19/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation
import SpriteKit

class HomeScene: SKScene {
    
    var nameLabel: SKLabelNode!
    
    override func didMove(to view: SKView) {
        
        let bgNode = SKSpriteNode(imageNamed: "Grass")
        bgNode.size = self.size
        bgNode.zPosition = -1
        bgNode.position = CGPoint(x: bgNode.size.width/2, y: bgNode.size.height/2)
        addChild(bgNode)
        
        nameLabel = SKLabelNode(fontNamed: "Arial Rounded MT Bold")
        nameLabel.text = "Go Fetch!"
        nameLabel.fontSize = 60
        nameLabel.position = CGPoint(x: size.width/2, y: size.height*2/3)
        nameLabel.fontColor = SKColor.black
        nameLabel.zPosition = 10
        self.addChild(nameLabel)
        
        let playLabel = SKLabelNode(fontNamed: "Arial Rounded MT Bold")
        playLabel.text = "Play"
        playLabel.fontSize = 40
        playLabel.fontColor = SKColor.black
        playLabel.position = CGPoint(x: size.width/2, y: size.height/8)
        addChild(playLabel)
        playLabel.name = "Play"
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addDogLeft),
                SKAction.wait(forDuration: 5.0),
                SKAction.run(addDogRight),
                SKAction.wait(forDuration: 5.0)
                ])
        ))
        
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let node = self.atPoint(touchLocation)
        
        if node.name == "Play" {
            self.startGame()
        }
        
        
    }
    
    func startGame() {
        let reveal = SKTransition.fade(withDuration: 1.0)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:reveal)
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addDogLeft() {
        
        let dog = SKSpriteNode(imageNamed: "WalkLeft1.1")
        dog.size = CGSize(width: 147/1.5, height: 107/1.5)
        dog.zPosition = 15
        dog.texture?.filteringMode = .nearest
        let randomDog = Int(random(min: 1, max: 5))
        let texture1 = SKTexture(imageNamed: "WalkLeft\(randomDog).1")
        let texture2 = SKTexture(imageNamed: "WalkLeft\(randomDog).2")
        let dogAnimation = SKAction.repeatForever(SKAction.animate(with: [texture1,texture2], timePerFrame: 0.3))
        
        dog.run(dogAnimation)
        
        let actualY = random(min: size.height - dog.size.height/2, max: dog.size.height/2)
        
        dog.position = CGPoint(x: size.width + dog.size.width/2, y: actualY)
        addChild(dog)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: -dog.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
    
        dog.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func addDogRight() {
        
        let dog = SKSpriteNode(imageNamed: "WalkRight1.1")
        dog.size = CGSize(width: 147/1.5, height: 107/1.5)
        dog.zPosition = 15
        dog.texture?.filteringMode = .nearest
        let randomDog = Int(random(min: 1, max: 5))
        let texture1 = SKTexture(imageNamed: "WalkRight\(randomDog).1")
        let texture2 = SKTexture(imageNamed: "WalkRight\(randomDog).2")
        let dogAnimation = SKAction.repeatForever(SKAction.animate(with: [texture1,texture2], timePerFrame: 0.3))
        
        dog.run(dogAnimation)
        
        let actualY = random(min: size.height - dog.size.height/2, max: dog.size.height/2)
        
        dog.position = CGPoint(x: -dog.size.width, y: actualY)
        addChild(dog)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: size.width + dog.size.width/2, y: actualY), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        
        dog.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
}
