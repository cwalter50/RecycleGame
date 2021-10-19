//
//  GameScene.swift
//  RecycleGame
//
//  Created by Christopher Walter on 10/19/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var recycleBin = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        createUI()
    }
    
    func createUI()
    {
//        anchorPoint = CGPoint(x: 0, y: 0)
        backgroundColor = SKColor.white
             
        let image = UIImage(named: "RecycleBin")
        let texture = SKTexture(image: image!)
        recycleBin = SKSpriteNode(texture: texture)
        recycleBin.position = CGPoint(x: size.width * 0.5, y: size.height * 0.5)
        recycleBin.size = CGSize(width: 50, height: 50)
        // 4
        addChild(recycleBin)
    }
    
    
    
}
