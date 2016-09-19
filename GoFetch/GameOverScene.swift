//
//  GameOverScene.swift
//  GoFetch
//
//  Created by Ana Luiza Ferrer on 18/09/16.
//  Copyright © 2016 BEPiD. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, score:Int) {
        
        super.init(size: size)
        
        let bgNode = SKSpriteNode(imageNamed: "Grass")
        bgNode.size = self.size
        bgNode.zPosition = -1
        bgNode.position = CGPoint(x: bgNode.size.width/2, y: bgNode.size.height/2)
        addChild(bgNode)
        
        let message = "Score: \(score)"
        
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.black
        label.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(label)
        label.name = "Replay"
    
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        let node = self.atPoint(touchLocation)

        if node.name == "Replay" {
            self.restartGame()
        }
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func restartGame() {
        let reveal = SKTransition.fade(withDuration: 1.0)
        let scene = GameScene(size: size)
        self.view?.presentScene(scene, transition:reveal)
    }
    
    
}
