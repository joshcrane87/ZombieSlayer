//
//  Fruits.swift
//  FruitNinja
//
//  Created by Josh Crane on 5/22/15
//

import Foundation
import SpriteKit

class Fruits: SKSpriteNode {
    
    var isSliced: Bool?
    var type: Int?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        println("init is nil")
    }
    init(texture: SKTexture!, color: UIColor!, size: CGSize, type:Int, categoryBitMask:UInt32, contactTestBitmask:UInt32, collisionBitmask:UInt32)
    {
        super.init(texture: texture, color: color, size: size)
        
        if(type == 0) {
            self.texture = SKTexture(imageNamed: waterMelonFullImage as String)
            self.type = 0
            self.size = CGSizeMake(75, 75)
        }
        else if(type == 1) {
            self.texture = SKTexture(imageNamed: kiwiFullImage as String)
            self.type = 1
            self.size = CGSizeMake(75, 75)
        }
        else if(type == 2) {
            self.texture = SKTexture(imageNamed: lemonFullImage as String)
            self.type = 2
            self.size = CGSizeMake(75, 75)
        }
        else if(type == 3) {
            self.texture = SKTexture(imageNamed: pineAppleFullImage as String)
            self.type = 3
            self.size = CGSizeMake(50, 75)
        }
        else if(type == 4) {
            self.texture = SKTexture(imageNamed: strawberryFullImage as String)
            self.type = 4
            self.size = CGSizeMake(75, 75)
        }
        else if(type == 5) {
            self.texture = SKTexture(imageNamed: bombFullImage as String)
            self.type = 5
            self.size = CGSizeMake(60, 75)
        }
        
        self.isSliced = false
        
        self.position = CGPointMake(size.width/2, -20);
        self.physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
        self.physicsBody?.categoryBitMask = categoryBitMask
        self.physicsBody?.contactTestBitMask = contactTestBitmask
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = true
        self.physicsBody?.affectedByGravity = true
        
        let randomNumInt = Float.random(lower: 0.4, upper: 0.5)
        self.physicsBody?.mass = CGFloat(randomNumInt)
        
        
    }
}
