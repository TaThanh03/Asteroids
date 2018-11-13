//
//  GameViewController.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 11/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    var currentGame: GameScene!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //let scene = GameScene(size: CGSize(width: 2048, height: 1536))
        currentGame = GameScene(size: CGSize(width: 2048, height: 1536))
        currentGame.viewController = self
        
        
        let view = self.view as! SKView
        // Load the SKScene from 'GameScene.sks'
        //if let scene = SKScene(fileNamed: "GameScene") {
        // Set the scale mode to scale to fit the window
        currentGame.scaleMode = .aspectFill
        view.showsFPS = true
        //view.showsNodeCount = true
        view.ignoresSiblingOrder = true
        
        let effectH = UIInterpolatingMotionEffect(keyPath: "centre.x", type: .tiltAlongHorizontalAxis)
        effectH.minimumRelativeValue = -50.0
        effectH.maximumRelativeValue = 50.0
        let effectV = UIInterpolatingMotionEffect(keyPath: "centre.y", type: .tiltAlongVerticalAxis)
        effectV.minimumRelativeValue = -50.0
        effectV.maximumRelativeValue = 50.0
        
        view.addMotionEffect(effectH)
        view.addMotionEffect(effectV)

        // Present the scene
        view.presentScene(currentGame)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
