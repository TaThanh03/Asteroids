//
//  GameScene.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 11/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene, SKPhysicsContactDelegate {
    weak var viewController: GameViewController!
    weak var settingView: SettingView!
    
    var gameArea: CGRect
    var gameScore = 0
    
    let settingLabel = SKLabelNode(fontNamed: "Avenir-Black")
    let scoreLabel = SKLabelNode(fontNamed: "Avenir-Black")
    let playLabel = SKLabelNode(fontNamed: "Avenir-Black")
    
    let spaceShip = SKSpriteNode(imageNamed: "Spaceship")
    let backGround = SKSpriteNode(imageNamed: "Background")
    let explosionSound = SKAction.playSoundFileNamed("explosion.mp3", waitForCompletion: false)
    let lazeSound = SKAction.playSoundFileNamed("lazesound.mp3", waitForCompletion: false) //set to false to move on to the next action right away
    struct physicsCategories{
        static let None: UInt32 = 0
        static let Spaceship: UInt32 = 0b1 //1
        static let LazeBeam: UInt32 = 0b10 //2
        static let Asteroide: UInt32 = 0b100 //4
    }
    
    
    override init(size: CGSize) {
        /*let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth)/2*/
        gameArea = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        settingLabel.name = "settingLabel"
        scoreLabel.name = "scoreLabel"
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //this function will run as soon as the screen load up
    override func didMove(to view: SKView) {
        //to handle contact
        self.physicsWorld.contactDelegate = self
        
        //set the background in the depth (it must be the lowest in the stack)
        backGround.size = self.size
        backGround.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.green
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        scoreLabel.position = CGPoint(x: self.size.width*0.02, y: self.size.height*0.85)
        scoreLabel.zPosition = 100
        self.addChild(scoreLabel)
        
        settingLabel.text = "Settings"
        settingLabel.fontSize = 70
        settingLabel.fontColor = SKColor.green
        settingLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        settingLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        settingLabel.position = CGPoint(x: self.size.width*0.98, y: self.size.height*0.85)
        settingLabel.zPosition = 100
        self.addChild(settingLabel)
        
        playLabel.text = "Play"
        playLabel.fontSize = 100
        playLabel.fontColor = SKColor.green
        playLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.center
        playLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.center
        playLabel.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        playLabel.zPosition = 100
        self.addChild(playLabel)
        
        spawnSpaceship()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        //contact hold the informations about 2 body contact to each other
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else {
            body1 = contact.bodyB
            body2 = contact.bodyA
        }//after this, the body with lower categoryBitMask asign to body1
        
        //spaceship hit asteroide
        if body1.categoryBitMask == physicsCategories.Spaceship && body2.categoryBitMask == physicsCategories.Asteroide {//if player hit asterroide
            //delete player and asteroide
            // ? : to avoid protential bug that will crash the game, if 2 asteroid hit 1 player, it will try to delete 2 times the player
            //only do this if these exist a node
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            //stop the game
            if self.action(forKey: "newLevel") != nil {
                self.removeAction(forKey: "newLevel")
            }
            playLabel.isHidden = false
        }
        
        //laze hit asteroide
        if body1.categoryBitMask == physicsCategories.LazeBeam && body2.categoryBitMask == physicsCategories.Asteroide && (body2.node?.position.y)! < self.size.height{//if laze hit asterroide and if the asteroid is on the screen
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            body1.node?.removeFromParent()
            body2.node?.removeFromParent()
            addScore()
        }
    }
    
    
    func startNewLevel(levelNumber: Int) {
        var levelDuration: TimeInterval
        if self.action(forKey: "newLevel") != nil {
            self.removeAction(forKey: "newLevel")
        }
        switch levelNumber {
        case 0:
            levelDuration = 1.2
        case 1:
            levelDuration = 1
        case 2:
            levelDuration = 0.8
        case 3:
            levelDuration = 0.5
        case 4:
            levelDuration = 0.3
        case 5:
            levelDuration = 0.1
        default:
            levelDuration = 0.5
            print("Cannot find level")
        }
        spaceShip.removeFromParent()
        spawnSpaceship()
        gameScore = 0
        scoreLabel.text = "Score: \(gameScore)"
        let spawn = SKAction.run(spawnAsteroid)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "newLevel")
    }
    
    func addScore() {
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
    }
    
    func fireLaze() {
        let lazeBeam = SKSpriteNode(imageNamed: "Lazebeam")
        lazeBeam.setScale(0.5)
        lazeBeam.position.x = spaceShip.position.x
        lazeBeam.position.y = spaceShip.position.y + spaceShip.size.height/4
        lazeBeam.zPosition = 1
        lazeBeam.physicsBody = SKPhysicsBody(rectangleOf: lazeBeam.size)
        lazeBeam.physicsBody!.affectedByGravity = false
        lazeBeam.physicsBody!.categoryBitMask = physicsCategories.LazeBeam
        lazeBeam.physicsBody!.collisionBitMask = physicsCategories.None //Ignore all other objects
        lazeBeam.physicsBody!.contactTestBitMask = physicsCategories.Asteroide
        self.addChild(lazeBeam)
        
        //move up the screen and delete
        let moveLazeBeam = SKAction.moveTo(y: self.size.height + lazeBeam.size.height, duration: 1)
        let deleteLazeBeam = SKAction.removeFromParent()
        
        //use sequence (a list of action to handle set of action)
        let lazeBeamSequence = SKAction.sequence([lazeSound, moveLazeBeam, deleteLazeBeam])
        lazeBeam.run(lazeBeamSequence)
    }
    
    func spawnSpaceship() {
        spaceShip.setScale(1.8)
        spaceShip.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        spaceShip.zPosition = 2
        spaceShip.physicsBody = SKPhysicsBody(rectangleOf: spaceShip.size)
        spaceShip.physicsBody!.affectedByGravity = false
        spaceShip.physicsBody!.categoryBitMask = physicsCategories.Spaceship
        spaceShip.physicsBody!.collisionBitMask = physicsCategories.None //Ignore all other objects
        spaceShip.physicsBody!.contactTestBitMask = physicsCategories.Asteroide //Only contact with asteroide
        //Assign spaceship to the right category (to make it interact with only the right object)
        self.addChild(spaceShip)
    }
    
    
    func spawnAsteroid() {
        //start at a random in the top and move to a random point at the bottom
        let randomXStart = Float.random(in: Float(gameArea.minX) ... Float(gameArea.maxX))
        let randomXEnd = Float.random(in: Float(gameArea.minX) ... Float(gameArea.maxX))
        let startPoint = CGPoint(x: CGFloat(randomXStart), y: self.size.height * 1.2)
        let endPoint = CGPoint(x: CGFloat(randomXEnd), y: -self.size.height * 0.2)
        var asteroidString = "Asteroide"
        asteroidString += String(Int.random(in: 1 ... 8))
        //NSLog(asteroidString)
        let randomAsteroid = SKSpriteNode(imageNamed: asteroidString)
        randomAsteroid.setScale(3)
        randomAsteroid.position = startPoint
        randomAsteroid.zPosition = 2
        randomAsteroid.physicsBody = SKPhysicsBody(circleOfRadius: randomAsteroid.size.width/2)
        randomAsteroid.physicsBody!.affectedByGravity = false
        randomAsteroid.physicsBody!.categoryBitMask = physicsCategories.Asteroide
        randomAsteroid.physicsBody!.collisionBitMask = physicsCategories.None //Ignore all other objects
        randomAsteroid.physicsBody!.contactTestBitMask = physicsCategories.Spaceship | physicsCategories.LazeBeam //only colide with these 2
        self.addChild(randomAsteroid)
        
        let randomDuration = Double.random(in: 1.3 ... 3)
        let moveAsteroide = SKAction.move(to: endPoint, duration: randomDuration)
        let deleteAsteroide = SKAction.removeFromParent()
        let asteroideSequence = SKAction.sequence([moveAsteroide, deleteAsteroide])
        //make it spin!
        let randomInt = Int.random(in: -1 ... 1)
        randomAsteroid.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi * Double(randomInt)), duration: 1)))
        
        randomAsteroid.run(asteroideSequence)
        
    }
    
    func spawnExplosion(spawnPosition: CGPoint) {
        let explosion = SKSpriteNode(imageNamed: "Explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 2, duration: 0.1)
        let fadeOut = SKAction.fadeOut(withDuration: 0.2)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        explosion.run(explosionSequence)
    }
    
    //handle movement of spaceship
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches{
            //where we touched the screen?
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            spaceShip.position.x += amountDragged
            //make sure spaceship not out of gameArea
            if spaceShip.position.x > gameArea.maxX - spaceShip.size.width/2{
                spaceShip.position.x = gameArea.maxX - spaceShip.size.width/2
            }
            if spaceShip.position.x < gameArea.minX + spaceShip.size.width/2{
                spaceShip.position.x = gameArea.minX + spaceShip.size.width/2
            }
        }
        
    }
    
    //Handle all buttons in the screen
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == playLabel {
                startNewLevel(levelNumber: (viewController.settingView?.scrollLevel.selectedRow(inComponent: 0))!)
                    //settingView?.scrollLevel.selectedRow(inComponent: 0))
                playLabel.isHidden = true
            }
            if node == settingLabel {
                //if in game, stop the game
                if self.action(forKey: "newLevel") != nil {
                    self.removeAction(forKey: "newLevel")
                }
                viewController.settingView?.isHidden = false
            }
            if node == scoreLabel {
                //if in game, stop the game
                if self.action(forKey: "newLevel") != nil {
                    self.removeAction(forKey: "newLevel")
                }
            }
        
        }
        if spaceShip.parent != nil {
            fireLaze()
        }
        
    }
    
}
