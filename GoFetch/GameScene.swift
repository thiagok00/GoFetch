//
//  GameScene.swift
//  GoFetch
//
//  Created by Ana Luiza Ferrer on 18/09/16.
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
    
    var catchedBalls = 0
    var bones = 3
    var scoreLabel: SKLabelNode!
    var bonesArray = [SKSpriteNode]()
    
    override func didMove(to view: SKView) {
    
        let bgNode = SKSpriteNode(imageNamed: "Grass")
        bgNode.size = self.size
        bgNode.zPosition = -1
        bgNode.position = CGPoint(x: bgNode.size.width/2, y: bgNode.size.height/2)
        addChild(bgNode)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "\(catchedBalls)"
        scoreLabel.fontSize = 40
        scoreLabel.position = CGPoint(x: size.width/2, y: size.height - 3*scoreLabel.frame.size.height)
        scoreLabel.fontColor = SKColor.black
        scoreLabel.zPosition = 10
        self.addChild(scoreLabel)
        
        var i = 0
        var x:CGFloat = 0
        while ( i < bones) {
            let newBone =  SKSpriteNode(imageNamed: "Bone")
            newBone.zPosition = 15
            newBone.size = CGSize(width: 298/8,height: 278/8)
            x = x + newBone.frame.width
            bonesArray.append(newBone)
            newBone.position = CGPoint(x: x,y: size.height - newBone.frame.size.height)
            addChild(newBone)
            i = i + 1
        }
        
        
        player.position = CGPoint(x: size.width * 0.5, y: player.size.height/2)
        player.zPosition = 10
        addChild(player)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addDog),
                SKAction.wait(forDuration: 1.0)
                ])
        ))
        
    }
    
    func removeBone() {
        
        bonesArray[bones-1].removeFromParent()
        bones = bones - 1
        
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addDog() {
        
        let dog = SKSpriteNode(imageNamed: "DogLeft1")
        dog.size = CGSize(width: 19*2.5, height: 33*2.5)
        dog.texture?.filteringMode = .nearest
        let randomDog = random(min: 1, max: 5)
        let texture1 = SKTexture(imageNamed: "DogLeft\(randomDog)")
        let texture2 = SKTexture(imageNamed: "DogRight\(randomDog)")
        let dogAnimation = SKAction.repeatForever(SKAction.animate(with: [texture1,texture2], timePerFrame: 0.3))
        
        dog.run(dogAnimation)
        
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
        
        let loseAction = SKAction.run() {
            self.removeBone()
            if self.bones < 1 {
                let reveal = SKTransition.fade(withDuration: 1)
                let gameOverScene = GameOverScene(size: self.size, score: self.catchedBalls)
                self.view?.presentScene(gameOverScene, transition: reveal)
            }
            
        }
        dog.run(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
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
        
        ball.removeFromParent()
        dog.removeFromParent()
        
        run(SKAction.playSoundFileNamed("woof.mp3", waitForCompletion: false))
        
        catchedBalls = catchedBalls + 1
        scoreLabel.text = "\(catchedBalls)"
        
        
        //PARTICULAS !!!
        //abre o arquivo sks
        let path = Bundle.main.path(forResource: "HearthParticle", ofType: "sks")
        let hearthParticle = NSKeyedUnarchiver.unarchiveObject(withFile: path!) as! SKEmitterNode
        
        //posicao e tamanho
        hearthParticle.targetNode = self.scene
        hearthParticle.position = dog.position
        hearthParticle.xScale = 0.3
        hearthParticle.yScale = 0.3
        //maximo de coracoes
        hearthParticle.numParticlesToEmit = 10
        
        self.addChild(hearthParticle)
        
        //da remove parente do emitter pra nao ficar deixando nodes atoa na tela
        let removeHearths = SKAction.sequence([SKAction.wait(forDuration: 2.0), SKAction.run({ hearthParticle.removeFromParent()})])
        run(removeHearths)
        
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
