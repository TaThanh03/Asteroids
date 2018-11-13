//
//  ModelPickerLevel.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 12/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit

class ModelPickerLevel: NSObject, UIPickerViewDataSource {
    private let levels = [ "", "Easy", "Normal", "Hard", "Jedi", "Sith", "Jar Jar Binks"]
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
    
    func getLevel (comp: Int) -> String {
        return levels[comp]
    }
}
