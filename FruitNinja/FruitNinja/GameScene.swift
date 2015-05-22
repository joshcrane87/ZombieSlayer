//
//  GameScene.swift
//  FruitNinja
//
//  Created by Josh Crane on 5/22/15
//

import SpriteKit
import AVFoundation


let FruitCategoryName = "fruit"


class GameScene: SKScene,SKPhysicsContactDelegate {
    
    // This optional variable will help us to easily access our blade
    var blade:SWBlade?
    
    let bladeCategory:UInt32 = 0x1 << 0;
    let fruitCategory:UInt32 = 0x1 << 1;
    let leftHalfCategory:UInt32 = 0x1 << 2;
    let rightHalfCategory:UInt32 = 0x1 << 3;
    
    // This will help us to update the position of the blade
    // Set the initial value to 0
    var delta = CGPointZero
    
    var leftSprite:SKSpriteNode!
    var rightSprite:SKSpriteNode!
    var isSliced:Bool!
    var diffictultyLevel:Int!
    var gameTitle:SKLabelNode!
    var startButton: SKLabelNode!
    var currentScoreNode: SKLabelNode!
    var currentScore: Int!
    var timer:NSTimer!
    var partsArray:NSMutableArray!
    var fruitsArray:NSMutableArray!
    var lifes:Int!
    var lifesNode: SKLabelNode!
    var bgImage:SKSpriteNode!
    var isGameOver:Bool!
    
    //Bonus Nodes
    var bonus_fruits_number:SKLabelNode!
    var bonus_combo_word:SKLabelNode!
    var bonus_points_give:SKLabelNode!
    
    var comboHits: Int!
    var gameIsStarted:Bool!
    var checkIfNoFruits:NSTimer!
    var bestScoreNode:SKLabelNode!
    
    //InApp Buttons
    var removeAds:SKSpriteNode!
    var restore:SKSpriteNode!
    
    //Game Center Leaderboard
    var openLeaderboard:SKSpriteNode!
    
    //Social Button
    var shareGame:SKSpriteNode!
    
    //Music ON OFF Button
    var changeMusic:SKSpriteNode!
    var audioPlayer:AVAudioPlayer!
    
    //Counter for the score at gameover
    var incrementScoreTimer:NSTimer!
    var incrementScoreNumber:Int!
    
    var bombArray: NSMutableArray!
    var buttonArray: NSMutableArray!
    
    //Preload Sound
    var ImpactWatermelon:SKAction!
    var ImpactPlum:SKAction!
    var ImpactPineapple:SKAction!
    var ImpactStrawberry:SKAction!
    var BombFuse:SKAction!
    var NewBestScoreSound:SKAction!
    var ItemIncrementSound:SKAction!
    var MissSound:SKAction!
    var BombExplode:SKAction!
    var GameOverSound:SKAction!
    var BladeChansaw1:SKAction!
    var BladeChansaw2:SKAction!
    var BladeChansaw3:SKAction!
    var BladeChansaw4:SKAction!
    var BladeChansaw5:SKAction!
    var BladeChansaw6:SKAction!
    var Combo1:SKAction!
    var Combo2:SKAction!
    var Combo3:SKAction!
    var Combo4:SKAction!
    var Combo5:SKAction!
    var Combo6:SKAction!
    var Combo7:SKAction!
    var Combo8:SKAction!
    var BladeBlossom1:SKAction!
    var BladeBlossom2:SKAction!
    var BladeBlossom3:SKAction!
    var BladeBlossom4:SKAction!
    var GameStartSound:SKAction!
    
    override func didMoveToView(view: SKView) {
        self.backgroundColor = UIColor.blackColor()
        preloadAllSounds()
        
        comboHits = 0
        gameIsStarted = false
        
        self.physicsWorld.contactDelegate = self
        isSliced = false
        isGameOver = true
        self.physicsWorld.gravity = CGVectorMake(0, -9.8)
        
        diffictultyLevel = 1;
        bgImage = SKSpriteNode(imageNamed: "Background2.png")
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        bgImage.size = CGSizeMake(screenSize.width, screenSize.height)
        [self.addChild(bgImage)]
        bgImage.position = CGPointMake(screenSize.width/2,screenSize.height/2)
        
        
        gameTitle = SKLabelNode(text: "ZOMBIE SLAYER")
        gameTitle.fontColor = SKColor.whiteColor()
        gameTitle.fontName = GameFontName as String
        gameTitle.fontSize = 40
        gameTitle.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/1.3)
        [self.addChild(gameTitle)]
        
        startButton = SKLabelNode(text: "SLICE TO START")
        startButton.fontColor = SKColor.whiteColor()
        startButton.fontName = GameFontName as String
        startButton.fontSize = 30
        startButton.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/1.6)
        [self.addChild(startButton)]
        
        currentScoreNode = SKLabelNode(text: "0")
        currentScoreNode.fontColor = SKColor.whiteColor()
        currentScoreNode.fontName = GameFontName as String
        currentScoreNode.fontSize = 30
        if(NSUserDefaults.standardUserDefaults().boolForKey("isPurchased") == true) {
            currentScoreNode.position = CGPointMake(view.frame.size.width/2, view.frame.size.height-60)
        }
        else {
            if(showiAD == true) {
                currentScoreNode.position = CGPointMake(view.frame.size.width/2, view.frame.size.height-100)
            }
            else {
                currentScoreNode.position = CGPointMake(view.frame.size.width/2, view.frame.size.height-60)
            }
            
        }
        
        [self.addChild(currentScoreNode)]
        currentScoreNode.hidden = true
        
        lifesNode = SKLabelNode(text: "Lifes:0")
        lifesNode.fontColor = SKColor.whiteColor()
        lifesNode.fontName = GameFontName as String
        lifesNode.fontSize = 30
        if(NSUserDefaults.standardUserDefaults().boolForKey("isPurchased") == true) {
           lifesNode.position = CGPointMake(view.frame.size.width/1.2, view.frame.size.height-60)
        }
        else {
            if(showiAD == true) {
                lifesNode.position = CGPointMake(view.frame.size.width/1.2, view.frame.size.height-100)
            }
            else {
                lifesNode.position = CGPointMake(view.frame.size.width/1.2, view.frame.size.height-60)
            }
           
        }
        
        [self.addChild(lifesNode)]
        lifesNode.hidden = true
        
        currentScore = 0
        lifes = playerLifes
        partsArray = NSMutableArray()
        fruitsArray = NSMutableArray()
        bombArray = NSMutableArray()
        buttonArray = NSMutableArray()
        
        self.view?.multipleTouchEnabled = false
        
        //WATERMELON THAT START THE GAME WHEN SLICED
        var number = 0
        var fruit = Fruits( texture: nil, color: UIColor.clearColor(), size: self.frame.size, type: number, categoryBitMask: fruitCategory, contactTestBitmask: bladeCategory, collisionBitmask: 0)

        fruit.position = CGPointMake(startButton.position.x, startButton.position.y-60)
        [self.addChild(fruit)]
        fruit.physicsBody?.affectedByGravity = false
        let rotateAction = SKAction.rotateByAngle(2, duration: 2)
        let repeatForever = SKAction.repeatActionForever(rotateAction)
        fruit.runAction(repeatForever)
        buttonArray.addObject(fruit)
        
        //COMBO LABELS
        bonus_fruits_number = SKLabelNode(text: "")
        bonus_fruits_number.fontColor = SKColor.yellowColor()
        bonus_fruits_number.fontName = GameFontName as String
        bonus_fruits_number.fontSize = 20
        
        [self.addChild(bonus_fruits_number)]
        bonus_combo_word = SKLabelNode(text: "COMBO")
        bonus_combo_word.fontColor = SKColor.yellowColor()
        bonus_combo_word.fontName = GameFontName as String
        bonus_combo_word.fontSize = 20
       
        [self.addChild(bonus_combo_word)]
        bonus_points_give = SKLabelNode(text: "")
        bonus_points_give.fontColor = SKColor.yellowColor()
        bonus_points_give.fontName = GameFontName as String
        bonus_points_give.fontSize = 20
        
        [self.addChild(bonus_points_give)]
        bonus_combo_word.setScale(0)
        bonus_fruits_number.setScale(0)
        bonus_points_give.setScale(0)
        
        //BEST SCORE NODE
        bestScoreNode = SKLabelNode(text: "BEST:")
        bestScoreNode.fontColor = SKColor.whiteColor()
        bestScoreNode.fontName = GameFontName as String
        bestScoreNode.fontSize = 30
        bestScoreNode.position = CGPointMake(view.frame.size.width/2, view.frame.size.height/3)
        [self.addChild(bestScoreNode)]
        bestScoreNode.hidden = true
        
        //In-App Remove Ads Button
        //In-App Restore Button
        //Game Center
        //Social
        //Music
        initialiseTheMainMenuButtons(view)
        
        var backgroundSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("Music-menu", ofType: "mp3")!)
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
        
        var error:NSError?
        audioPlayer = AVAudioPlayer(contentsOfURL: backgroundSound, error: &error)
        audioPlayer.prepareToPlay()
        setBackgroundMusicToPlay(true)
        
        
    }
    
    func showBonus(hits:Int, fruitPosition:CGPoint) {
        bonus_combo_word.setScale(0)
        bonus_fruits_number.setScale(0)
        bonus_points_give.setScale(0)
        playComboSound(hits)
        var bonus:Int = 0
        if hits == 3 || hits == 4 {
            currentScore = currentScore + 3
            bonus = 3
        }
        else if hits == 5 || hits == 6 {
            currentScore = currentScore + 5
            bonus = 5
        }
        else if hits == 7 || hits == 8 {
            currentScore = currentScore + 7
            bonus = 7
        }
        else {
            currentScore = currentScore + 9
            bonus = 9
        }
        
        var fruitsSliced = "\(hits) HITS"
        var pointsGiven = "+\(bonus) POINTS"
        bonus_fruits_number.text = fruitsSliced
        bonus_points_give.text = pointsGiven
        
        bonus_fruits_number.position = fruitPosition
        bonus_combo_word.position = CGPointMake(bonus_fruits_number.position.x, bonus_fruits_number.position.y - 20)
        bonus_points_give.position = CGPointMake(bonus_combo_word.position.x, bonus_combo_word.position.y-20)
        
        let scaleUpAction = SKAction.scaleTo(1, duration: 0.4)
        let scaleDownAction = SKAction.scaleTo(0, duration: 0.4)
        let delay = SKAction.waitForDuration(1.0)
        let sequence = SKAction.sequence([scaleUpAction,delay,scaleDownAction])
        
        bonus_combo_word.runAction(sequence)
        bonus_fruits_number.runAction(sequence)
        bonus_points_give.runAction(sequence)
        
    }
    func spawnFruits() {
        comboHits = 0
        
        if(diffictultyLevel == 1) {

            var number1 = Int.random(lower: 0, upper: 5)
            var fruit2 = Fruits( texture: nil, color: UIColor.clearColor(), size: self.frame.size, type: number1, categoryBitMask: fruitCategory, contactTestBitmask: bladeCategory, collisionBitmask: 0)

            [self.addChild(fruit2)]
            if (number1 != 5) {
                playFruitThrowSound(number1)
                fruitsArray.addObject(fruit2)
            }
            else {
                playBombFuseSound()
                bombArray.addObject(fruit2)
                fruit2.zPosition = 1000
            }
            fruit2.physicsBody?.applyImpulse(CGVectorMake(generateRandomX(), generateRandomY()))
            
        }
        else if (diffictultyLevel == 2){
            for (var i = 0; i < FruitsToFireInLevel2; i++) {
                var number = Int.random(lower: 0, upper: 5)
                var fruit = Fruits( texture: nil, color: UIColor.clearColor(), size: self.frame.size, type: number, categoryBitMask: fruitCategory, contactTestBitmask: bladeCategory, collisionBitmask: 0)
                [self.addChild(fruit)]
                if (number != 5) {
                    playFruitThrowSound(number)
                    fruitsArray.addObject(fruit)
                }
                else {
                    println("NUMBER IS: \(number) PLAYING BOMB SOUND")
                    playBombFuseSound()
                    bombArray.addObject(fruit)
                    fruit.zPosition = 1000
                }
                fruit.physicsBody?.applyImpulse(CGVectorMake(generateRandomX(), generateRandomY()))
                playFruitThrowSound(number)
            }
        }
        else if (diffictultyLevel == 3) {
            for (var i = 0; i < FruitsToFireInLevel3; i++) {
                
                var number = Int.random(lower: 0, upper: 5)
                var fruit = Fruits( texture: nil, color: UIColor.clearColor(), size: self.frame.size, type: number, categoryBitMask: fruitCategory, contactTestBitmask: bladeCategory, collisionBitmask: 0)
                [self.addChild(fruit)]
                if (number != 5) {
                    playFruitThrowSound(number)
                    fruitsArray.addObject(fruit)
                }
                else {
                    println("NUMBER IS: \(number) PLAYING BOMB SOUND")
                    playBombFuseSound()
                    bombArray.addObject(fruit)
                    fruit.zPosition = 1000
                }
                fruit.physicsBody?.applyImpulse(CGVectorMake(generateRandomX(), generateRandomY()))
                playFruitThrowSound(number)
            }
        }
        else if (diffictultyLevel == 4) {
            for (var i = 0; i < FruitsToFireInLevel4; i++) {
                var number = Int.random(lower: 0, upper: 5)
                var fruit = Fruits( texture: nil, color: UIColor.clearColor(), size: self.frame.size, type: number, categoryBitMask: fruitCategory, contactTestBitmask: bladeCategory, collisionBitmask: 0)
                [self.addChild(fruit)]
                if (number != 5) {
                    playFruitThrowSound(number)
                    fruitsArray.addObject(fruit)
                }
                else {
                    println("NUMBER IS: \(number) PLAYING BOMB SOUND")
                    playBombFuseSound()
                    bombArray.addObject(fruit)
                    fruit.zPosition = 1000
                }
                fruit.physicsBody?.applyImpulse(CGVectorMake(generateRandomX(), generateRandomY()))
                playFruitThrowSound(number)
            }
        }
        else {
            for (var i = 0; i < FruitsToFireInLevel5; i++) {
                var number = Int.random(lower: 0, upper: 5)
                var fruit = Fruits( texture: nil, color: UIColor.clearColor(), size: self.frame.size, type: number, categoryBitMask: fruitCategory, contactTestBitmask: bladeCategory, collisionBitmask: 0)
                [self.addChild(fruit)]
                if (number != 5) {
                    playFruitThrowSound(number)
                    fruitsArray.addObject(fruit)
                }
                else {
                    println("NUMBER IS: \(number) PLAYING BOMB SOUND")
                    playBombFuseSound()
                    bombArray.addObject(fruit)
                    fruit.zPosition = 1000
                }
                fruit.physicsBody?.applyImpulse(CGVectorMake(generateRandomX(), generateRandomY()))
            }
        }
    }
    func generateRandomX() -> CGFloat {
        var fruitWidth = CGFloat(arc4random_uniform(30))
        let fruitWidthPlusMinus = Int(arc4random_uniform(2))
        if(fruitWidthPlusMinus == 0) {
            fruitWidth = -fruitWidth
        }

        return fruitWidth
    }
    func generateRandomY() -> CGFloat {
        var fruitHeight = CGFloat(Float.random(lower: 400, upper: 600))
        return fruitHeight
    }
    func presentBladeAtPosition(position:CGPoint) {
        blade = SWBlade(position: position, target: self, color: UIColor.whiteColor())
        self.addChild(blade!)
        blade?.enablePhysics(bladeCategory, contactTestBitmask: fruitCategory, collisionBitmask: fruitCategory)
    }
    func removeBlade() {
        delta = CGPointZero
        blade!.removeFromParent()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        let any_object: AnyObject? = touches.first!;
        let touchLocation = any_object!.locationInNode(self)
        presentBladeAtPosition(touchLocation)
        comboHits = 0
    }
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let any_object: AnyObject? = touches.first!
        let currentPoint = any_object!.locationInNode(self)
        let previousPoint = any_object!.previousLocationInNode(self)
        delta = CGPoint(x: currentPoint.x - previousPoint.x, y: currentPoint.y - previousPoint.y)
    }
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        removeBlade()
        playBladeSound()
        isSliced = false
        comboHits = 0
        
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            if startButton.containsPoint(location) {
                //startTheGame()
            }
        }
        let touch:UITouch = touches.first! as! UITouch
        let positionInScene = touch.locationInNode(self)
        let touchedNode = self.nodeAtPoint(positionInScene)
        if(isGameOver == true) {
            if let name = touchedNode.name
            {
                if name == "ShowLeaderboard"
                {
                    println("Leaderboard")
                    GamecenterUtils.sharedGamecenterUtils.showLeaderboardOnViewController(self.view?.window?.rootViewController, leaderboardID: GameCenterLeaderboardID)
                }
                else if name == "RestorePurchase" {
                    println("Restore")
                    InAppUtils.sharedInAppUtils.restorePurchase()
                }
                else if name == "RemoveAds" {
                    println("Removeads")
                    InAppUtils.sharedInAppUtils.removeAds(InAppIDString)
                }
                else if name == "ChangeMusic" {
                    println("ChangeMusic")
                    if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
                        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "isMusicOn")
                        changeMusic.texture = SKTexture(imageNamed: "musicButtonOff.png")
                        audioPlayer.pause()
                    }
                    else {
                        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "isMusicOn")
                        audioPlayer.play()
                        changeMusic.texture = SKTexture(imageNamed: "musicButtonOn.png")
                    }
                }
                else if name == "ShareGame" {
                    println("Share Game")
                    shareTheGame()
                    
                }
            }
        }
    }
    func shareTheGame() {
        var message = ShareMessage;
        var url = NSURL(string: ShareItunesLink as String);
        var image = UIImage(named: ShareImageName as String);
        var activityItems:NSArray = [message,url!,image!];
        
        var contr = UIActivityViewController(activityItems: activityItems as [AnyObject], applicationActivities: nil);
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            contr.popoverPresentationController?.sourceView = self.view;
            var sourceRect = contr.popoverPresentationController?.sourceRect;
            contr.popoverPresentationController?.sourceRect = CGRectMake(0, self.frame.size.height, self.frame.size.width, sourceRect!.size.height);
        }
        self.view?.window?.rootViewController?.presentViewController(contr, animated: true, completion: nil)
    }
    func startTheGame() {
        playGameStartSound()
        if(NSUserDefaults.standardUserDefaults().boolForKey("isPurchased") == true) {
            currentScoreNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-60)
        }
        else {
            if(showiAD == true) {
                currentScoreNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-100)
            }
            else {
                currentScoreNode.position = CGPointMake(self.frame.size.width/2, self.frame.size.height-60)
            }
            
        }
        if(NSUserDefaults.standardUserDefaults().boolForKey("isPurchased") == true) {
            lifesNode.position = CGPointMake(self.frame.size.width/1.2, self.frame.size.height-60)
        }
        else {
            if(showiAD == true) {
                lifesNode.position = CGPointMake(self.frame.size.width/1.2, self.frame.size.height-100)
            }
            else {
                lifesNode.position = CGPointMake(self.frame.size.width/1.2, self.frame.size.height-60)
            }
            
        }

        if isGameOver == true {
            println("Staring the game")
            setBackgroundMusicToPlay(false)
            hideAllButtons(true)
            currentScore = 0
            diffictultyLevel = 1
            startButton.hidden = true
            gameTitle.hidden = true
            currentScoreNode.hidden = false
            currentScoreNode.text = "\(currentScore)"
            lifesNode.hidden = false
            lifes = playerLifes
            isGameOver = false
            lifesNode.text = "Lifes:\(lifes)"
            timer = NSTimer.scheduledTimerWithTimeInterval(2.0, target: self, selector: Selector("spawnFruits"), userInfo: nil, repeats: true)
            bestScoreNode.hidden = true
        }
    }
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        removeBlade()
    }
    func explosion(pos: CGPoint) {
        var emitterNode = SKEmitterNode(fileNamed: "ExplosionParticle.sks")
        emitterNode.particlePosition = pos
        self.addChild(emitterNode)
        // Don't forget to remove the emitter node after the explosion
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode.removeFromParent() })
    }
    func cutWatermelon(pos: CGPoint, color: NSString) {
        var emitterNode = SKEmitterNode(fileNamed: "watermelonParticle.sks")
        emitterNode.particlePosition = pos
        if color.isEqualToString("red") {
            emitterNode.particleColorSequence = nil;
            emitterNode.particleColorBlendFactor = 1.0;
            emitterNode.particleColor = SKColor.redColor();
        }
        else if color.isEqualToString("green") {
            emitterNode.particleColorSequence = nil;
            emitterNode.particleColorBlendFactor = 1.0;
            emitterNode.particleColor = SKColor.greenColor();
        }
        else if color.isEqualToString("yellow") {
            emitterNode.particleColorSequence = nil;
            emitterNode.particleColorBlendFactor = 1.0;
            emitterNode.particleColor = SKColor.yellowColor();
        }

        self.addChild(emitterNode)
        // Don't forget to remove the emitter node after the explosion
        self.runAction(SKAction.waitForDuration(2), completion: { emitterNode.removeFromParent() })
        
    }
    func didBeginContact(contact: SKPhysicsContact) {
        if gameIsStarted == false {
            startTheGame()
            gameIsStarted = true
        }
        if isGameOver == false {
            if let fruit = contact.bodyA.node as? Fruits {
                if fruit.isSliced == false {
                    
                    let shake = SKAction.shake(0.2, amplitudeX: 4, amplitudeY: 2)
                    bgImage.runAction(shake)
                    
                    if(fruitsArray.count > 0) {
                        fruitsArray.removeObjectAtIndex(0)
                    }
                    currentScore = currentScore + 1
                    println("\(currentScore)")
                    if(currentScore > 4) {
                        diffictultyLevel = 2
                    }
                    if(currentScore > 10) {
                        diffictultyLevel = 3
                    }
                    if(currentScore > 30) {
                        diffictultyLevel = 4
                    }
                    if(currentScore > 100) {
                        diffictultyLevel = 5
                    }

                    currentScoreNode.text = String(currentScore)
                    
                    if(fruit.type == 0) {
                        cutWatermelon(fruit.position, color: "red")
                        leftSprite = SKSpriteNode(imageNamed: waterMelonLeftPartImage as String)
                        rightSprite = SKSpriteNode(imageNamed: waterMelonRightPartImage as String)
                        leftSprite.size = CGSizeMake(50, 50)
                        comboHits = comboHits + 1
                        playImpactSound(0)
                    }
                    else if(fruit.type == 1) {
                        cutWatermelon(fruit.position, color: "green")
                        leftSprite = SKSpriteNode(imageNamed: kiwiLeftPartImage as String)
                        rightSprite = SKSpriteNode(imageNamed: kiwiRightPartImage as String)
                        leftSprite.size = CGSizeMake(50, 50)
                        comboHits = comboHits + 1
                        playImpactSound(1)
                    }
                    else if(fruit.type == 2) {
                        cutWatermelon(fruit.position, color: "yellow")
                        leftSprite = SKSpriteNode(imageNamed: lemonLeftPartImage as String)
                        rightSprite = SKSpriteNode(imageNamed: lemonRightPartImage as String )
                        leftSprite.size = CGSizeMake(50, 50)
                        comboHits = comboHits + 1
                        playImpactSound(2)
                    }
                    else if(fruit.type == 3) {
                        cutWatermelon(fruit.position, color: "yellow")
                        leftSprite = SKSpriteNode(imageNamed: pineAppleLeftPartImage as String)
                        rightSprite = SKSpriteNode(imageNamed: pineAppleRightPartImage as String)
                        leftSprite.size = CGSizeMake(50, 50)
                        comboHits = comboHits + 1
                        playImpactSound(3)
                    }
                    else if(fruit.type == 4) {
                        cutWatermelon(fruit.position, color: "red")
                        leftSprite = SKSpriteNode(imageNamed: strawberryLeftPartImage as String)
                        rightSprite = SKSpriteNode(imageNamed: strawberryRightPartImage as String)
                        leftSprite.size = CGSizeMake(50, 50)
                        comboHits = comboHits + 1
                        playImpactSound(4)
                    }
                    else if(fruit.type == 5) {
                        explosion(fruit.position)
                        fruit.removeFromParent()
                        gameOver()
                        playImpactSound(5)
                        return
                    }
                   
                    if(comboHits >= 3) {
                        showBonus(comboHits, fruitPosition: fruit.position)
                    }
                    
                    leftSprite.position = CGPointMake(fruit.position.x+10, fruit.position.y)
                    leftSprite.physicsBody = SKPhysicsBody(rectangleOfSize: leftSprite.size)
                    leftSprite.physicsBody?.categoryBitMask = leftHalfCategory
                    leftSprite.physicsBody?.contactTestBitMask = rightHalfCategory
                    leftSprite.physicsBody?.collisionBitMask = rightHalfCategory
                    leftSprite.physicsBody?.dynamic = true
                    leftSprite.physicsBody?.allowsRotation = true
                    leftSprite.physicsBody?.mass = 1
                    rightSprite.size = CGSizeMake(50, 50)
                    rightSprite.position = CGPointMake(fruit.position.x-10, fruit.position.y)
                    rightSprite.physicsBody = SKPhysicsBody(rectangleOfSize: rightSprite.size)
                    rightSprite.physicsBody?.categoryBitMask = rightHalfCategory
                    rightSprite.physicsBody?.contactTestBitMask = leftHalfCategory
                    rightSprite.physicsBody?.collisionBitMask = leftHalfCategory
                    rightSprite.physicsBody?.dynamic = true
                    rightSprite.physicsBody?.allowsRotation = true
                    rightSprite.physicsBody?.mass = 0.8
                    
                    [self.addChild(leftSprite)]
                    [self.addChild(rightSprite)]
                    partsArray.addObject(leftSprite)
                    partsArray.addObject(rightSprite)
                    
                    leftSprite.physicsBody?.applyImpulse(CGVectorMake(-5, 0), atPoint: CGPointMake(5, 5))
                    rightSprite.physicsBody?.applyImpulse(CGVectorMake(5, 0), atPoint: CGPointMake(5, 5))
                    
                    fruit.removeFromParent()
                    
                    fruit.isSliced = true
                    
                }
            }
        }
    }
    override func update(currentTime: CFTimeInterval) {
        // if the blade is available
        
        //CLEAR THE HALFS THE FULL FRUITS AND THE BOMBS IF THEY ARE BEYOND THE SCREEN
        if isGameOver == false {
            if partsArray.count > 0 {
                for (var i = 0; i < partsArray.count; i++) {
                    var part = partsArray.objectAtIndex(i) as! SKSpriteNode
                    if(part.position.y < -100) {
                        part.removeFromParent()
                        partsArray.removeObjectAtIndex(i)
                    }
                }
            }
            if fruitsArray.count > 0 {
                for (var i = 0; i < fruitsArray.count; i++) {
                    var fruit = fruitsArray.objectAtIndex(i) as! SKSpriteNode
                    if(fruit.position.y < -100) {
                        fruit.removeFromParent()
                        fruitsArray.removeObjectAtIndex(i)
                        lifes = lifes - 1
                        playMissSound()
                        lifesNode.text = "Lifes:\(lifes)"
                        if(lifes == 0) {
                            gameOver()
                        }
                    }
                }
            }
            if bombArray.count > 0 {
                for (var i = 0; i < bombArray.count; i++) {
                    var bomb = bombArray.objectAtIndex(i) as! SKSpriteNode
                    if(bomb.position.y < -100) {
                        bomb.removeFromParent()
                        bombArray.removeObjectAtIndex(i)
                    }
                }
            }

        }
        if blade != nil {
            // Here you add the delta value to the blade position
            let newPosition = CGPoint(x: blade!.position.x + delta.x, y: blade!.position.y + delta.y)
            // Set the new position
            blade!.position = newPosition
            // it's important to reset delta at this point,
            // You are telling the blade to only update his position when touchesMoved is called
            delta = CGPointZero
            
            var fruit = childNodeWithName(FruitCategoryName) as! SKSpriteNode!
            
        }
    }
    func connectNode1(node1:SKSpriteNode, node2:SKSpriteNode)
    {
        let midPoint = CGPoint(x:(node1.position.x + node2.position.x)/2,y:(node1.position.y + node2.position.y)/2)
        let joint = SKPhysicsJointFixed.jointWithBodyA(node1.physicsBody, bodyB: node2.physicsBody, anchor: midPoint)
    
        [self.physicsWorld.addJoint(joint)]
    }
    func gameOver() {
        
        hideAllButtons(false)
        isGameOver = true
        incrementScoreNumber = 0
        timer.invalidate()
        timer = nil
        
        gameTitle.hidden = false
        gameTitle.text = "GAME OVER"
        startButton.hidden = false
        startButton.text = "Slice To Play Again"
        bestScoreNode.hidden = false
        
        
        if(currentScore > NSUserDefaults.standardUserDefaults().integerForKey("BestScore")) {
            NSUserDefaults.standardUserDefaults().setInteger(currentScore, forKey: "BestScore")
           // bestScoreNode.text = "Best:\(currentScore)"
            playNewHighscoreSound()
            self.view?.userInteractionEnabled = false
            incrementScoreTimer = NSTimer.scheduledTimerWithTimeInterval(0.03, target: self, selector: Selector("incrementTheScoreWithSound"), userInfo: nil, repeats: true)
            GamecenterUtils.sharedGamecenterUtils.reportScore(currentScore, leaderboardID: GameCenterLeaderboardID)
        }
        else {
            let bestScore = NSUserDefaults.standardUserDefaults().integerForKey("BestScore") as Int
            bestScoreNode.text = "Best:\(bestScore)"
        }
        
        //Add the water melon for play again
        var number = 0
        var fruit = Fruits( texture: nil, color: UIColor.clearColor(), size: self.frame.size, type: number, categoryBitMask: fruitCategory, contactTestBitmask: bladeCategory, collisionBitmask: 0)

        fruit.position = CGPointMake(startButton.position.x, startButton.position.y-60)
        println("\(fruit.position)")
        fruit.physicsBody?.affectedByGravity = false
        [self.addChild(fruit)]
        buttonArray.addObject(fruit)
        let moveAction = SKAction.moveTo(CGPointMake(startButton.position.x, startButton.position.y-60), duration: 0)
        fruit.runAction(moveAction)
        
        let rotateAction = SKAction.rotateByAngle(2, duration: 2)
        let repeatForever = SKAction.repeatActionForever(rotateAction)
        fruit.runAction(repeatForever)
        
        print("GAME OVER")
        
        checkIfNoFruits = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self,selector: Selector("checkIfScreenEmpty") , userInfo: nil, repeats: true)
        
    }
    func incrementTheScoreWithSound() {
        incrementScoreNumber = incrementScoreNumber + 1
        playIncrementScore()
        bestScoreNode.text = "Best:\(incrementScoreNumber)"
        if incrementScoreNumber == currentScore {
            incrementScoreTimer.invalidate()
            incrementScoreTimer=nil
            self.view?.userInteractionEnabled = true
        }
        
        
    }
    func checkIfScreenEmpty() {
        if partsArray.count > 0 {
            for (var i = 0; i < partsArray.count; i++) {
                var part = partsArray.objectAtIndex(i) as! SKSpriteNode
                if(part.position.y < -100) {
                    part.removeFromParent()
                    partsArray.removeObjectAtIndex(i)
                }
            }
        }
        
        if fruitsArray.count > 0 {
            for (var i = 0; i < fruitsArray.count; i++) {
                var fruit = fruitsArray.objectAtIndex(i) as! SKSpriteNode
                fruit.removeFromParent()
                fruitsArray.removeObjectAtIndex(i)
            }
        }
        
        if bombArray.count > 0 {
            for (var i = 0; i < bombArray.count; i++) {
                var bomb = bombArray.objectAtIndex(i) as! SKSpriteNode
                if(bomb.position.y < -100) {
                    bomb.removeFromParent()
                    bombArray.removeObjectAtIndex(i)
                }
            }
        }
        
        println("\(partsArray.count), fruits count \(fruitsArray.count)")
        if(partsArray.count <= 0 && fruitsArray.count <= 0) {
            gameIsStarted = false
            playGameOver()
            setBackgroundMusicToPlay(true)
            checkIfNoFruits.invalidate()
            checkIfNoFruits = nil
        }
    }
    func initialiseTheMainMenuButtons(view:SKView) {
        
        openLeaderboard = SKSpriteNode(imageNamed: "leaderboardButton.png")
        openLeaderboard.size = CGSizeMake(30, 30)
        openLeaderboard.position = CGPointMake(view.frame.size.width/2-95, view.frame.size.height/4)
        openLeaderboard.name = "ShowLeaderboard"
        self.addChild(openLeaderboard)
        
        restore = SKSpriteNode(imageNamed: "restore.png")
        restore.size = CGSizeMake(35, 35)
        restore.position = CGPointMake(openLeaderboard.position.x+50, openLeaderboard.position.y)
        restore.name = "RestorePurchase"
        self.addChild(restore)
        
        removeAds = SKSpriteNode(imageNamed: "noads.png")
        removeAds.size = CGSizeMake(45, 45)
        removeAds.position = CGPointMake(restore.position.x+50, restore.position.y)
        removeAds.name = "RemoveAds"
        self.addChild(removeAds)
        
        changeMusic = SKSpriteNode(imageNamed: "musicButtonOn.png")
        changeMusic.size = CGSizeMake(30, 30)
        changeMusic.position = CGPointMake(removeAds.position.x+50, removeAds.position.y)
        changeMusic.name = "ChangeMusic"
        self.addChild(changeMusic)
        
        shareGame = SKSpriteNode(imageNamed: "socialButton.png")
        shareGame.size = CGSizeMake(30, 30)
        shareGame.position = CGPointMake(changeMusic.position.x+50, changeMusic.position.y)
        shareGame.name = "ShareGame"
        self.addChild(shareGame)
        
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            changeMusic.texture = SKTexture(imageNamed: "musicButtonOn.png")
        }
        else {
            changeMusic.texture = SKTexture(imageNamed: "musicButtonOff.png")
        }
        
    }
    func hideAllButtons(hide:Bool) {
        if hide == true {
            shareGame.hidden = true
            changeMusic.hidden = true
            removeAds.hidden = true
            restore.hidden = true
            openLeaderboard.hidden = true
            
        }
        else {
            shareGame.hidden = false
            changeMusic.hidden = false
            removeAds.hidden = false
            restore.hidden = false
            openLeaderboard.hidden = false
        }
    }
    func setBackgroundMusicToPlay(play:Bool) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            if play == true {
                audioPlayer.play()
            }
            else {
                audioPlayer.pause()
            }
        }
    }
    func playBladeSound() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            let randomNumber = Int.random(lower: 1, upper: 4)
            if(randomNumber == 1) {
                runAction(BladeBlossom1)
            }
            else if(randomNumber == 2) {
                runAction(BladeBlossom2)
            }
            else if(randomNumber == 3) {
                runAction(BladeBlossom3)
            }
            else if(randomNumber == 4) {
                runAction(BladeBlossom4)
            }
            else {
                runAction(BladeBlossom1)
            }
        }
    }
    func playComboSound(level:Int) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            //8 Types
            if(level == 1) {
                runAction(Combo1)
            }
            else if(level == 2) {
                runAction(Combo2)
            }
            else if(level == 3) {
                runAction(Combo3)
            }
            else if(level == 4) {
                runAction(Combo4)
            }
            else if(level == 5) {
                runAction(Combo5)
            }
            else if(level == 6) {
                runAction(Combo6)
            }
            else if(level == 7) {
                runAction(Combo7)
            }
            else if(level == 8) {
                runAction(Combo8)
            }
            else {
                runAction(Combo8)
            }
        }
    }
    func playImpactSound(foodType:Int){
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            if(foodType != 5) {
                
                let randomNumber = Int.random(lower: 1, upper: 6)
                if(randomNumber == 1) {
                    runAction(BladeChansaw1)
                }
                else if(randomNumber == 2) {
                    runAction(BladeChansaw2)
                }
                else if(randomNumber == 3) {
                    runAction(BladeChansaw3)
                }
                else if(randomNumber == 4) {
                    runAction(BladeChansaw4)
                }
                else if(randomNumber == 5) {
                    runAction(BladeChansaw5)
                }
                else if(randomNumber == 6) {
                    runAction(BladeChansaw6)
                }
                else {
                    runAction(BladeChansaw1)
                }
            }
            else {
                runAction(BombExplode)
            }
        }
    }
    func playGameOver() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            runAction(GameOverSound)
        }
    }
    func playFruitThrowSound(foodType:Int) {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            if(foodType == 0) {
                //watermelon
                runAction(ImpactWatermelon)
            }
            else if(foodType == 1) {
                //Kiwi
                runAction(ImpactPlum)
            }
            else if(foodType == 2) {
                //lemon
                runAction(ImpactPineapple)
            }
            else if(foodType == 3) {
                //pineapple
                runAction(ImpactPineapple)
            }
            else if(foodType == 4) {
                //strawberry
                runAction(ImpactStrawberry)
            }
        }
    }
    func playBombFuseSound() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            runAction(BombFuse)
        }
    }
    func playNewHighscoreSound() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            runAction(NewBestScoreSound)
        }
    }
    func playIncrementScore() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            runAction(ItemIncrementSound)
        }
    }
    func playMissSound() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            runAction(MissSound)
        }
    }
    func playGameStartSound() {
        if (NSUserDefaults.standardUserDefaults().boolForKey("isMusicOn") == true) {
            runAction(GameStartSound)
        }
    }
    func preloadAllSounds() {
        
        self.ImpactWatermelon = SKAction.playSoundFileNamed("Impact-Watermelon.mp3", waitForCompletion: false)
        self.ImpactPlum = SKAction.playSoundFileNamed("Impact-Plum.mp3", waitForCompletion: false)
        self.ImpactPineapple = SKAction.playSoundFileNamed("Impact-Pineapple.mp3", waitForCompletion: false)
        self.ImpactStrawberry = SKAction.playSoundFileNamed("Impact-Strawberry.mp3", waitForCompletion: false)
        self.BombFuse = SKAction.playSoundFileNamed("Bomb-Fuse.mp3", waitForCompletion: false)
        self.NewBestScoreSound = SKAction.playSoundFileNamed("New-best-score.mp3", waitForCompletion: false)
        self.ItemIncrementSound = SKAction.playSoundFileNamed("item-increment.mp3", waitForCompletion: false)
        self.MissSound = SKAction.playSoundFileNamed("gank.mp3", waitForCompletion: false)
        self.BombExplode = SKAction.playSoundFileNamed("Bomb-explode.mp3", waitForCompletion: false)
        self.GameOverSound = SKAction.playSoundFileNamed("Game-over.mp3", waitForCompletion: false)
        self.BladeChansaw1 = SKAction.playSoundFileNamed("blade-chainsaw-impact-1.mp3", waitForCompletion: false)
        self.BladeChansaw2 = SKAction.playSoundFileNamed("blade-chainsaw-impact-2.mp3", waitForCompletion: false)
        self.BladeChansaw3 = SKAction.playSoundFileNamed("blade-chainsaw-impact-3.mp3", waitForCompletion: false)
        self.BladeChansaw4 = SKAction.playSoundFileNamed("blade-chainsaw-impact-4.mp3", waitForCompletion: false)
        self.BladeChansaw5 = SKAction.playSoundFileNamed("blade-chainsaw-impact-5.mp3", waitForCompletion: false)
        self.BladeChansaw6 = SKAction.playSoundFileNamed("blade-chainsaw-impact-6.mp3", waitForCompletion: false)
        self.Combo1 = SKAction.playSoundFileNamed("combo-1.mp3", waitForCompletion: false)
        self.Combo2 = SKAction.playSoundFileNamed("combo-2.mp3", waitForCompletion: false)
        self.Combo3 = SKAction.playSoundFileNamed("combo-3.mp3", waitForCompletion: false)
        self.Combo4 = SKAction.playSoundFileNamed("combo-4.mp3", waitForCompletion: false)
        self.Combo5 = SKAction.playSoundFileNamed("combo-5.mp3", waitForCompletion: false)
        self.Combo6 = SKAction.playSoundFileNamed("combo-6.mp3", waitForCompletion: false)
        self.Combo7 = SKAction.playSoundFileNamed("combo-7.mp3", waitForCompletion: false)
        self.Combo8 = SKAction.playSoundFileNamed("combo-8.mp3", waitForCompletion: false)
        self.BladeBlossom1 = SKAction.playSoundFileNamed("blade-cherry-blossom-1-1.mp3", waitForCompletion: false)
        self.BladeBlossom2 = SKAction.playSoundFileNamed("blade-cherry-blossom-1-2.mp3", waitForCompletion: false)
        self.BladeBlossom3 = SKAction.playSoundFileNamed("blade-cherry-blossom-1-3.mp3", waitForCompletion: false)
        self.BladeBlossom4 = SKAction.playSoundFileNamed("blade-cherry-blossom-1-4.mp3", waitForCompletion: false)
        self.GameStartSound = SKAction.playSoundFileNamed("Game-start.mp3", waitForCompletion: false)
    }
}






