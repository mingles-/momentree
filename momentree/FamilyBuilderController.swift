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
    
    @IBOutlet weak var fatherChangeMode: UIButton!
    @IBOutlet weak var motherChangeMode: UIButton!

    @IBOutlet weak var fatherPersonBox: UITextField!
    @IBOutlet weak var motherPersonBox: UITextField!
    
    var fatherMode = false
    var motherMode = false
    
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
        
        fatherPicker.hidden = true
        motherPicker.hidden = true
        
        
        
        
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
    
    @IBAction func addPersonButton(sender: AnyObject) {
        
        
        if nameTextField.text! != "" {
            
            let newPerson = Person(name: nameTextField.text!)
            let fatherIndex = fatherPicker.selectedRowInComponent(0)
            let motherIndex = motherPicker.selectedRowInComponent(0)
            
            if fatherMode {
                if pickerDataSource[fatherIndex].name != "" {
                    newPerson.setDad(pickerDataSource[fatherIndex])
                }
            } else {
                if fatherPersonBox.text! != "" {
                    let newFather = Person(name: fatherPersonBox.text!)
                    newPerson.setDad(newFather)
                    personArray.append(newFather)
                    print("added father")
                }
            }
            
            if motherMode {
                if pickerDataSource[motherIndex].name != "" {
                    newPerson.setMum(pickerDataSource[motherIndex])
                }
            } else {
                if motherPersonBox.text! != "" {
                    let newMother = Person(name: motherPersonBox.text!)
                    newPerson.setMum(newMother)
                    personArray.append(newMother)
                    print("added mother")
                }
            }
            
            if motherMode && fatherMode {
                if pickerDataSource[fatherIndex].name != "" && pickerDataSource[motherIndex].name != "" {
                    pickerDataSource[motherIndex].setSpouse(pickerDataSource[fatherIndex])
                }
            } else if motherPersonBox.text! != "" && fatherPersonBox.text! != "" {
                personArray[personArray.count-1].setSpouse(personArray[personArray.count-2])
            }
            
            personArray.append(newPerson)
            selectedPersonIndex = personArray.count-1

            print("added person" + newPerson.name)
            
        }
        
    }
    
}