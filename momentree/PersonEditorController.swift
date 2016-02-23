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
    
    
    @IBOutlet weak var fatherChangeMode: UIButton!
    @IBOutlet weak var motherChangeMode: UIButton!
    
    @IBOutlet weak var fatherPersonBox: UITextField!
    @IBOutlet weak var motherPersonBox: UITextField!
    
    var fatherMode = true
    var motherMode = true
    
    
    
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

        print("editing " + thePerson.name)
        
        var tempDataSource = personArray
        tempDataSource.append(nullPerson)
        pickerDataSource = tempDataSource.reverse()
        
        fatherPersonBox.hidden = true
        motherPersonBox.hidden = true
        
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
        
            // set dad or remove dad
            let fatherIndex = fatherPicker.selectedRowInComponent(0)
            if pickerDataSource[fatherIndex].name != "" {
                print("setting " + newPerson.name + " dad")
                newPerson.setDad(pickerDataSource[fatherIndex])
            } else {
                print("removing " + newPerson.name + " dad")
                newPerson.removeDad()
            }
        
        
            // set mum or remove mum
            let motherIndex = motherPicker.selectedRowInComponent(0)
            if pickerDataSource[motherIndex].name != "" {
                print("setting " + newPerson.name + " mum")
                newPerson.setMum(pickerDataSource[motherIndex])
            } else {
                print("removing " + newPerson.name + " mum")
                newPerson.removeMum()
            }
        
        
            // assuming both aren't 0, set parents as spouse
            
            if pickerDataSource[fatherIndex].name != "" && pickerDataSource[motherIndex].name != "" {
                
                pickerDataSource[motherIndex].setSpouse(pickerDataSource[fatherIndex])
        }
//            } else {
//                print("does this")
//                newPerson.removeParents()
//            }
    
        
            personArray[selectedPersonIndex] = newPerson

        
        
        }
    
    @IBAction func fatherModeChangePressed(sender: AnyObject) {
        
        if fatherMode {
            fatherMode = false
        } else {
            fatherMode = true
        }
        
        if fatherMode {
            fatherPicker.hidden = false
            fatherPersonBox.hidden = true
            fatherChangeMode.setTitle("add new father", forState: .Normal)
        } else {
            fatherPicker.hidden = true
            fatherPersonBox.hidden = false
            fatherChangeMode.setTitle("add existing father", forState: .Normal)
        }
        
        
        
    }
    
    @IBAction func motherChangeModePressed(sender: AnyObject) {
        
        if motherMode {
            motherMode = false
        } else {
            motherMode = true
        }
        
        if motherMode {
            motherPicker.hidden = false
            motherPersonBox.hidden = true
            motherChangeMode.setTitle("add new mother", forState: .Normal)
        } else {
            motherPicker.hidden = true
            motherPersonBox.hidden = false
            motherChangeMode.setTitle("add existing mother", forState: .Normal)
        }
        
    }
        
    

    

}