//
//  SettingView.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 12/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit

class SettingView: UIView, UIPickerViewDelegate{
    let scrollLabel = UILabel()
    let doneLabel = UILabel()
    var scrollLevel = UIPickerView()
    let myModelPickerLevel = ModelPickerLevel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        scrollLabel.text = "level you will chose"
        scrollLabel.textAlignment = NSTextAlignment.center
        
        doneLabel.text = "Done"
        doneLabel.textAlignment = NSTextAlignment.center
        
        scrollLevel.dataSource = myModelPickerLevel
        scrollLevel.delegate = self
        scrollLevel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        scrollLevel.selectedRow(inComponent: 0)
        
        self.addSubview(scrollLevel)
        self.addSubview(scrollLabel)
        self.addSubview(doneLabel)
        
        self.drawInFormat(format: frame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawInFormat (format: CGSize) {
        /*let border_head : CGFloat
        let border_bottom : CGFloat
        let border_side_left : CGFloat
        let border_side_right : CGFloat*/
        let centre : CGFloat
    
        /*border_head = CGFloat(0)
        border_bottom = CGFloat(format.height)
        border_side_left = CGFloat(format.width)
        border_side_right = CGFloat(0)*/
        centre = CGFloat(format.width/2)
        
        print("w %f", format.width)
        print("h %f", format.height)
        
        scrollLevel.frame = CGRect(x: centre, y: 100, width: 200, height: 30)
        scrollLabel.frame = CGRect(x: centre, y: 50, width: 200, height: 30)
        doneLabel.frame = CGRect(x: centre, y: 200, width: 200, height: 30)
    }
}
