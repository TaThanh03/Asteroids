//
//  ModelPickerLevel.swift
//  Asteroids
//
//  Created by TA Trung Thanh on 12/11/2018.
//  Copyright © 2018 TA Trung Thanh. All rights reserved.
//

import UIKit

class ModelPickerLevel: NSObject, UIPickerViewDataSource {
    private let levels = [ "Easy", "Normal", "Hard", "Jedi", "Sith", "Jar Jar Binks"]
    
    func getLevel (comp: Int) -> String {
        return levels[comp]
    }
    
    //UIPickerViewDataSource protocol
    
    // Number of columns of data
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return levels.count
    }
    
    // The data to return from the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return levels[row]
    }
}
