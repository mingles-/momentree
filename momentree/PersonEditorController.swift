//
//  PersonEditorController.swift
//  momentree
//
//  Created by Michael Inglis on 06/12/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import UIKit

class PersonEditorController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fatherPicker: UIPickerView!
    @IBOutlet weak var motherPicker: UIPickerView!
    var pickerDataSource = [Person]()
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fatherPicker.dataSource = self
        fatherPicker.delegate = self
        motherPicker.dataSource = self
        motherPicker.delegate = self

        let thePerson = personArray[selectedPersonIndex]
        let nullPerson = Person(name: "")
        
        var tempPersonArray = personArray
        tempPersonArray.append(nullPerson)
        var dadIndex = 0
        var mumIndex = 0
        
        nameLabel.text = thePerson.name

        var tempDataSource = personArray
        tempDataSource.append(nullPerson)
        pickerDataSource = tempDataSource.reverse()
        
        if thePerson.dad != nil {
            for p in pickerDataSource {
                if (p === thePerson.dad) {
                    break
                }
                dadIndex += 1
            }
        }
        
        if thePerson.mum != nil {
            for p in pickerDataSource {
                if (p === thePerson.mum) {
                    break
                }
                mumIndex += 1
            }
        }
        
        motherPicker.selectRow(mumIndex, inComponent: 0, animated: true)
        fatherPicker.selectRow(dadIndex, inComponent: 0, animated: true)
        
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
        
            let newPerson = personArray[selectedPersonIndex]
        
            let fatherIndex = fatherPicker.selectedRowInComponent(0)
            if pickerDataSource[fatherIndex].name != "" {
                newPerson.setDad(pickerDataSource[fatherIndex])
            } else {
                newPerson.removeDad()
            }
            
            let motherIndex = motherPicker.selectedRowInComponent(0)
            if pickerDataSource[motherIndex].name != "" {
                newPerson.setMum(pickerDataSource[motherIndex])
            } else {
                newPerson.removeMum()
            }
            
            if pickerDataSource[fatherIndex].name != "" && pickerDataSource[motherIndex].name != "" {
                pickerDataSource[motherIndex].setSpouse(pickerDataSource[fatherIndex])
                
            } else {
                newPerson.removeParents()
            }
        
            personArray.removeAtIndex(selectedPersonIndex)
            personArray.append(newPerson)
        }
        
    

    

}