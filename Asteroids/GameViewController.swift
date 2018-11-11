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

    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: CGSize(width: 2048, height: 1536))
        
        
            let view = self.view as! SKView
            // Load the SKScene from 'GameScene.sks'
            //if let scene = SKScene(fileNamed: "GameScene") {
            // Set the scale mode to scale to fit the window
            scene.scaleMode = .aspectFill
            view.showsFPS = true
            view.showsNodeCount = true
            
            view.ignoresSiblingOrder = true
            // Present the scene
            view.presentScene(scene)
        
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
