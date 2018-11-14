//
//  SettingView.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 12/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit

class SettingView: UIView, UIPickerViewDelegate{
    var blurView = UIVisualEffectView()
    
    let scrollLabel = UILabel()
    let doneButton = UIButton(type: .system)
    var scrollLevel = UIPickerView()
    let myModelPickerLevel = ModelPickerLevel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let settingImage = UIImage(named: "Background")
        let scale = frame.width / settingImage!.size.width
        let settingImageView = UIImageView(image: settingImage)
        settingImageView.frame = CGRect(x: 0.0, y: 0.0, width: settingImage!.size.width*scale, height: settingImage!.size.height*scale)
        let blurEffect = UIBlurEffect(style: .light)
        blurView = UIVisualEffectView(effect: blurEffect)

        scrollLabel.text = "level you will chose"
        scrollLabel.textAlignment = NSTextAlignment.center
        
        doneButton.setTitle("Done", for: .normal)
        doneButton.addTarget(self.superview, action: #selector(GameViewController.actionSettingButtonDoneTouched), for: .touchUpInside)
        
        scrollLevel.dataSource = myModelPickerLevel
        scrollLevel.delegate = self
        scrollLevel.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 0.6)
        scrollLevel.selectedRow(inComponent: 0)
        
        self.addSubview(settingImageView)
        self.addSubview(blurView)
        self.addSubview(scrollLevel)
        self.addSubview(scrollLabel)
        self.addSubview(doneButton)
        
        self.drawInFormat(format: frame.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawInFormat (format: CGSize) {
        let centre_width = CGFloat(format.width/2)
        let centre_height = CGFloat(format.height/2)
        /*
        print("w %f", format.width)
        print("h %f", format.height)*/
        blurView.frame = CGRect(x: 0, y: 0, width: format.width, height: format.height)
        scrollLevel.frame = CGRect(x: centre_width - 100, y: centre_height - 30, width: 200, height: 60)
        scrollLabel.frame = CGRect(x: centre_width - 100, y: centre_height - 100, width: 200, height: 30)
        doneButton.frame = CGRect(x: centre_width - 100, y: centre_height + 100, width: 200, height: 30)
    }
    
    //return the title for elements in pickerVIew scrollLevel
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //print(row, myModelPickerLevel.getLevel(comp: row))
        return myModelPickerLevel.getLevel(comp: row)
    }
}
