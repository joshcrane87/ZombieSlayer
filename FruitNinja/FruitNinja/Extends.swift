//
//  Extends.swift
//  FruitNinja
//
//  Created by Josh Crane on 5/22/15
//

import Foundation
import SpriteKit
/**
Arc Random for Double and Float
*/
public func arc4random <T: IntegerLiteralConvertible> (type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, Int(sizeof(T)))
    return r
}
public extension Int {
    /**
    Create a random num Int
    :param: lower number Int
    :param: upper number Int
    :return: random number Int
    By vikt0r40
    */
    public static func random (#lower: Int , upper: Int) -> Int {
        let x:UInt32 = UInt32(upper)-UInt32(lower)+UInt32(1);
        let result:Int =  Int(lower) + Int(arc4random_uniform(x))
        return result
    }
    
}
public extension Double {
    /**
    Create a random num Double
    :param: lower number Double
    :param: upper number Double
    :return: random number Double
    By vikt0r40
    */
    public static func random(#lower: Double, upper: Double) -> Double {
        let r = Double(arc4random(UInt64)) / Double(UInt64.max)
        return (r * (upper - lower)) + lower
    }
}
public extension Float {
    /**
    Create a random num Float
    :param: lower number Float
    :param: upper number Float
    :return: random number Float
    By vikt0r40
    */
    public static func random(#lower: Float, upper: Float) -> Float {
        let r = Float(arc4random(UInt32)) / Float(UInt32.max)
        return (r * (upper - lower)) + lower
    }
}
extension SKAction {
    class func shake(duration:CGFloat, amplitudeX:Int = 3, amplitudeY:Int = 3) -> SKAction {
        let numberOfShakes = duration / 0.015 / 2.0
        var actionsArray:[SKAction] = []
        for index in 1...Int(numberOfShakes) {
            let dx = CGFloat(arc4random_uniform(UInt32(amplitudeX))) - CGFloat(amplitudeX / 2)
            let dy = CGFloat(arc4random_uniform(UInt32(amplitudeY))) - CGFloat(amplitudeY / 2)
            let forward = SKAction.moveByX(dx, y:dy, duration: 0.015)
            let reverse = forward.reversedAction()
            actionsArray.append(forward)
            actionsArray.append(reverse)
        }
        return SKAction.sequence(actionsArray)
    }
}