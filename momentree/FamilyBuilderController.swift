//
//  FamilyBuilderController.swift
//  momentree
//
//  Created by Michael Inglis on 03/12/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import UIKit

class FamilyBuilderController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    @IBOutlet weak var addPersonFamilyBuilderButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fatherPicker: UIPickerView!
    @IBOutlet weak var motherPicker: UIPickerView!
    
    var pickerDataSource = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fatherPicker.dataSource = self
        fatherPicker.delegate = self
        motherPicker.dataSource = self
        motherPicker.delegate = self
        
        var tempDataSource = personArray
        
        let nullPerson = Person(name: "")
        tempDataSource.append(nullPerson)
        pickerDataSource = tempDataSource.reverse()
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count;
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerDataSource[row].name
    }

    
    @IBAction func addPersonButton(sender: AnyObject) {
        print(nameTextField.text!)
        if nameTextField.text! != "" {
            let newPerson = Person(name: nameTextField.text!)
            
            let fatherIndex = fatherPicker.selectedRowInComponent(0)
            if pickerDataSource[fatherIndex].name != "" {
                newPerson.setDad(pickerDataSource[fatherIndex])
            }
            
            let motherIndex = motherPicker.selectedRowInComponent(0)
            if pickerDataSource[motherIndex].name != "" {
                newPerson.setMum(pickerDataSource[motherIndex])
            }
            
            if pickerDataSource[fatherIndex].name != "" && pickerDataSource[motherIndex].name != "" {
                pickerDataSource[motherIndex].setSpouse(pickerDataSource[fatherIndex])
            }
            
            personArray.append(newPerson)
        }
        
    }
    
}