//
//  GameScene.swift
//  GoFetch
//
//  Created by Thiago De Angelis on 18/09/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import SpriteKit

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Dog   : UInt32 = 0b1
    static let Ball: UInt32 = 0b10
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    let player = SKSpriteNode(imageNamed: "Girl")
    
    override func didMove(to view: SKView) {
    
        backgroundColor = SKColor.white
        player.position = CGPoint(x: size.width * 0.5, y: player.size.height/2)
        addChild(player)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addDog),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addDog() {
        
        let dog = SKSpriteNode(imageNamed: "Dog1Left")
        dog.size = CGSize(width: 128/2, height: 152/2)
        
        dog.physicsBody = SKPhysicsBody(rectangleOf: dog.size)
        dog.physicsBody?.isDynamic = true
        dog.physicsBody?.categoryBitMask = PhysicsCategory.Dog
        dog.physicsBody?.contactTestBitMask = PhysicsCategory.Ball
        dog.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        let actualX = random(min: dog.size.width/2, max: size.width - dog.size.width/2)
        
        dog.position = CGPoint(x: actualX, y: size.height + dog.size.height/2)
        addChild(dog)
        
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: actualX, y: -dog.size.height/2), duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        dog.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        physicsWorld.contactDelegate = self
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        let ball = SKSpriteNode(imageNamed: "TennisBall")
        ball.position = player.position
        ball.size = CGSize(width: 118/4, height: 102/4)
        
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.categoryBitMask = PhysicsCategory.Ball
        ball.physicsBody?.contactTestBitMask = PhysicsCategory.Dog
        ball.physicsBody?.collisionBitMask = PhysicsCategory.None
        ball.physicsBody?.usesPreciseCollisionDetection = true
        
        let offset = touchLocation - ball.position
        
        if (offset.y < 0) { return }
        
        addChild(ball)
        
        let direction = offset.normalized()
        
        let shootAmount = direction * 1000
        
        let realDest = shootAmount + ball.position
    
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        ball.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func ballDidCollideWithDog(ball:SKSpriteNode, dog:SKSpriteNode) {
        print("Catch")
        ball.removeFromParent()
        dog.removeFromParent()
        
        run(SKAction.playSoundFileNamed("woof.mp3", waitForCompletion: false))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.Dog != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Ball != 0)) {
            ballDidCollideWithDog(ball: firstBody.node as! SKSpriteNode, dog: secondBody.node as! SKSpriteNode)
            
        }
        
    }
    
}
