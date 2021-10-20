//
//  GameScene.swift
//  RecycleGame
//
//  Created by Christopher Walter on 10/19/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var recycleBin = SKSpriteNode()
    var scoreLabel = SKLabelNode()
    var bottom = SKSpriteNode()
    
    var score = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        
        createUI()
        
        startTrash()
        
        let borderBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.physicsBody = borderBody
        
        physicsWorld.contactDelegate = self
    }
    
    func removeNode(node: SKNode, addScore: Int)
    {
        score += addScore
        node.removeFromParent()
    }
    func didEnd(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.categoryBitMask == 2
        {
            // trash hit recycle bin
            // categoryBitMask 5 == trash, categoryBitMask 3 == recycle
            if contact.bodyB.categoryBitMask == 5
            {
                removeNode(node: contact.bodyB.node!, addScore: -10)
            }
            else
            {
                removeNode(node: contact.bodyB.node!, addScore: 10)
            }
            
        }
        else if contact.bodyB.categoryBitMask == 2
        {
            // trash hit recycle bin
            // categoryBitMask 5 == trash, categoryBitMask 3 == recycle
            
            if contact.bodyB.categoryBitMask == 5
            {
                removeNode(node: contact.bodyA.node!, addScore: -10)
            }
            else
            {
                removeNode(node: contact.bodyA.node!, addScore: 10)
            }
            
        }
        else if contact.bodyA.categoryBitMask == 4
        {
            // trash hit bottom
            if contact.bodyB.categoryBitMask == 3
            {
                removeNode(node: contact.bodyB.node!, addScore: -5)
            }
            else
            {
                removeNode(node: contact.bodyB.node!, addScore: 0)
            }
        }
        else if contact.bodyB.categoryBitMask == 4
        {
            // trash hit bottom
            if contact.bodyB.categoryBitMask == 3
            {
                removeNode(node: contact.bodyA.node!, addScore: -5)
            }
            else
            {
                removeNode(node: contact.bodyA.node!, addScore: 0)
            }
        }
        
    }
    
    func createUI()
    {
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -3)
        backgroundColor = SKColor.white
        
        let image = UIImage(named: "RecycleBin")
        let texture = SKTexture(image: image!)
        recycleBin = SKSpriteNode(texture: texture)
        recycleBin.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        recycleBin.size = CGSize(width: 50, height: 50)
        recycleBin.name = "RecycleBin"
        
//        recycleBin.physicsBody = SKPhysicsBody(texture: texture, size: recycleBin.size)
        recycleBin.physicsBody = SKPhysicsBody(rectangleOf: recycleBin.frame.size)
        recycleBin.physicsBody?.categoryBitMask = 2
        recycleBin.physicsBody?.contactTestBitMask = 3
        recycleBin.physicsBody?.isDynamic = false
        addChild(recycleBin)
        
        scoreLabel = SKLabelNode(text: "0")
        scoreLabel.position = CGPoint(x: size.width*0.8, y: size.height * 0.75)
        scoreLabel.fontSize = 50
        scoreLabel.fontColor = UIColor.darkText
        addChild(scoreLabel)
        
        // create bottom to detect if we miss an item
        bottom = SKSpriteNode(color: .green, size: CGSize(width: size.width, height: 20))
        bottom.position = CGPoint(x: frame.width * 0.5, y: 0)
        bottom.physicsBody = SKPhysicsBody(rectangleOf: bottom.frame.size)
        bottom.physicsBody!.isDynamic = false
        bottom.name = "bottom"
        bottom.physicsBody?.categoryBitMask = 4
        addChild(bottom)

    }
    
    func startTrash()
    {
        let wait = SKAction.wait(forDuration: 1.2)
        let sequence = SKAction.sequence([wait, SKAction.run(createTrash)])
        let forever = SKAction.repeatForever(sequence)
        
        run(forever)
    }
    
    func createTrash()
    {
        
        let images = ["newspaper", "waterbottle", "tv", "trash"]
        let randomString = images.randomElement()
        let image = UIImage(named: randomString!)!
        let texture = SKTexture(image: image)
        let trash = SKSpriteNode(texture: texture)
        let randX = CGFloat.random(in: 0...size.width)
        trash.position = CGPoint(x: randX, y: size.height*0.9)
        trash.size = CGSize(width: 35, height: 35)
        trash.name = randomString
        
        addChild(trash)

//        trash.physicsBody = SKPhysicsBody(texture: texture, size: trash.size)
        trash.physicsBody = SKPhysicsBody(rectangleOf: trash.frame.size)
//        recycleBin.physicsBody = SKPhysicsBody(circleOfRadius: 12)
        if randomString == "tv" || randomString == "trash"
        {
            trash.physicsBody?.categoryBitMask = 5
        }
        else
        {
            trash.physicsBody?.categoryBitMask = 3
        }
        
        trash.physicsBody?.contactTestBitMask = 2 | 4
        
    }
    
    var isFingerOnBin = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let location = touches.first!.location(in: self)
        
        if recycleBin.contains(location)
        {
            isFingerOnBin = true
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if isFingerOnBin
        {
            let location = touches.first!.location(in: self)
            
            recycleBin.position = CGPoint(x: location.x, y: recycleBin.position.y)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isFingerOnBin = false
    }
    
    
    
    
    
}
