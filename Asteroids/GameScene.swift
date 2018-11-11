//
//  GameScene.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 11/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let spaceShip = SKSpriteNode(imageNamed: "Spaceship")
    let backGround = SKSpriteNode(imageNamed: "Background")
    let lazeSound = SKAction.playSoundFileNamed("lazesound.mp3", waitForCompletion: false) //set to false to move on to the next action right away
    var gameArea: CGRect
    
    override init(size: CGSize) {
        /*
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth)/2*/
        self.gameArea = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //this function will run as soon as the screen load up
    override func didMove(to view: SKView) {
        backGround.size = self.size
        //backGround.setScale(1)
        backGround.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        //set the background in the depth (it must be the lowest in the stack)
        backGround.zPosition = 0
        //add background to view
        self.addChild(backGround)
        
        spaceShip.setScale(1.8)
        spaceShip.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        spaceShip.zPosition = 2
        self.addChild(spaceShip)
        
        startNewLevel()
    }
    
    func startNewLevel() {
        let spawn = SKAction.run(spawnAsteroid)
        let waitToSpawn = SKAction.wait(forDuration: 0.7)
        let spawnSequence = SKAction.sequence([spawn, waitToSpawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever)
    }
    
    
    func fireLaze() {
        let lazeBeam = SKSpriteNode(imageNamed: "Lazebeam")
        lazeBeam.setScale(0.5)
        lazeBeam.position.x = spaceShip.position.x
        lazeBeam.position.y = spaceShip.position.y + spaceShip.size.height/4
        lazeBeam.zPosition = 1
        self.addChild(lazeBeam)
        
        //move up the screen and delete
        let moveLazeBeam = SKAction.moveTo(y: self.size.height + lazeBeam.size.height, duration: 1)
        let deleteLazeBeam = SKAction.removeFromParent()
        
        //use sequence (a list of action to handle set of action)
        let lazeBeamSequence = SKAction.sequence([lazeSound, moveLazeBeam, deleteLazeBeam])
        lazeBeam.run(lazeBeamSequence)
    }
    
    func spawnAsteroid() {
        //start at a random in the top and move to a random point at the bottom
        let randomXStart = Float.random(in: Float(gameArea.minX) ... Float(gameArea.maxX))
        let randomXEnd = Float.random(in: Float(gameArea.minX) ... Float(gameArea.maxX))
        let startPoint = CGPoint(x: CGFloat(randomXStart), y: self.size.height * 1.2)
        let endPoint = CGPoint(x: CGFloat(randomXEnd), y: -self.size.height * 0.2)
        var asteroidString = "Asteroide"
        asteroidString += String(Int.random(in: 1 ... 8))
        NSLog(asteroidString)
        let randomAsteroid = SKSpriteNode(imageNamed: asteroidString)
        randomAsteroid.setScale(3)
        randomAsteroid.position = startPoint
        randomAsteroid.zPosition = 2
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        fireLaze()
    }
    
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
    
    /*
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }*/
    
    
}
