//
//  SettingScene.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 12/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import SpriteKit
import GameplayKit

class SettingScene: SKScene, UIPickerViewDelegate {
    
    let blablaLabel = SKLabelNode(fontNamed: "Avenir-Black")
    let myModelPickerLevel = ModelPickerLevel()
    let backGround = SKSpriteNode(imageNamed: "Background")
    
    override func didMove(to view: SKView) {
        
        backGround.size = self.size
        backGround.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        backGround.zPosition = 0
        self.addChild(backGround)
        
        view.backgroundColor = .clear
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        //view.insertSubview(blurView, at: 101)
        self.view?.addSubview(blurView)
        
        
        blablaLabel.text = "Back"
        blablaLabel.fontSize = 70
        blablaLabel.fontColor = SKColor.green
        blablaLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        blablaLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.top
        blablaLabel.position = CGPoint(x: self.size.width*0.02, y: self.size.height*0.85)
        blablaLabel.zPosition = 100
        self.addChild(blablaLabel)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            if node == blablaLabel{
                NSLog( "setting touched")
                if let view = view {
                    let transition:SKTransition = SKTransition.fade(withDuration: 1)
                    let scene:SKScene = GameScene(size: self.size)
                    scene.scaleMode = .aspectFill
                    view.presentScene(scene, transition: transition)
                }
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return myModelPickerLevel.getLevel(comp: component)
    }
}
