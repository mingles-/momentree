//
//  FamilyBuilderController.swift
//  momentree
//
//  Created by Michael Inglis on 03/12/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import UIKit
import Photos

class FamilyBuilderController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    
    @IBOutlet weak var addPersonFamilyBuilderButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var fatherPicker: UIPickerView!
    @IBOutlet weak var motherPicker: UIPickerView!
    @IBOutlet weak var albumPicker: UIPickerView!
    
    @IBOutlet weak var fatherChangeMode: UIButton!
    @IBOutlet weak var motherChangeMode: UIButton!

    @IBOutlet weak var fatherPersonBox: UITextField!
    @IBOutlet weak var motherPersonBox: UITextField!
    
    
    var fatherMode = false
    var motherMode = false
    
    var pickerDataSource = [Person]()
    var albumPickerSource = [String]()
    var albumIdentifiers = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fatherPicker.dataSource = self
        fatherPicker.delegate = self
        motherPicker.dataSource = self
        motherPicker.delegate = self
        albumPicker.dataSource = self
        albumPicker.delegate = self
        
        var tempDataSource = personArray
        
        let nullPerson = Person(name: "")
        tempDataSource.append(nullPerson)
        pickerDataSource = tempDataSource.reverse()
        
        albumPickerSource.append("")
        albumIdentifiers.append("")
        
        fatherPicker.hidden = true
        motherPicker.hidden = true
        
        getAlbums()
        
        
        
        
    }
    
    func getAlbums() {
        
        let albumOptions = PHFetchOptions()
        albumOptions.sortDescriptors = [NSSortDescriptor(key: "localizedTitle", ascending: true)]

        
        let albums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: albumOptions)
        
        for i in 0...albums.count-1 {
            let album: PHAssetCollection = albums[i] as! PHAssetCollection
            let localIdentifier: String = album.localIdentifier
            albumPickerSource.append(album.localizedTitle!)
            albumIdentifiers.append(localIdentifier)
        }
        
        
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == albumPicker {
            return albumPickerSource.count
        } else {
            return pickerDataSource.count
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == albumPicker {
            return albumPickerSource[row]
        } else {
            return pickerDataSource[row].name
        }
        
        
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
            let albumIndex = albumPicker.selectedRowInComponent(0)
            var addedFatherPicker = false
            var addedFatherNew = false
            
            if fatherMode {
                if pickerDataSource[fatherIndex].name != "" {
                    newPerson.setDad(pickerDataSource[fatherIndex])
                    addedFatherPicker = true
                }
            } else {
                if fatherPersonBox.text! != "" {
                    let newFather = Person(name: fatherPersonBox.text!)
                    newPerson.setDad(newFather)
                    personArray.append(newFather)
                    print("added father")
                    addedFatherNew = true
                }
            }
            
            if motherMode {
                if pickerDataSource[motherIndex].name != "" {
                    newPerson.setMum(pickerDataSource[motherIndex])
                    if addedFatherPicker {
                        pickerDataSource[motherIndex].setSpouse(pickerDataSource[fatherIndex])
                    } else if addedFatherNew {
                        pickerDataSource[motherIndex].setSpouse(personArray[personArray.count-1])
                    }
                }
            } else {
                if motherPersonBox.text! != "" {
                    let newMother = Person(name: motherPersonBox.text!)
                    newPerson.setMum(newMother)
                    
                    if addedFatherPicker {
                        newMother.setSpouse(pickerDataSource[fatherIndex])
                    } else if addedFatherNew {
                        newMother.setSpouse(personArray[personArray.count-1])
                    }
                    personArray.append(newMother)
                    print("added mother")
                }
            }
            
//            if motherMode && fatherMode {
//                if pickerDataSource[fatherIndex].name != "" && pickerDataSource[motherIndex].name != "" {
//                    pickerDataSource[motherIndex].setSpouse(pickerDataSource[fatherIndex])
//                }
//            } else if motherPersonBox.text! != "" && fatherPersonBox.text! != "" {
//                personArray[personArray.count-1].setSpouse(personArray[personArray.count-2])
//            }
            
            if albumIndex != 0 {
                newPerson.albumTitle = albumIdentifiers[albumIndex]
                let albumName = albumPickerSource[albumIndex]
                print("added album " + albumName)
                
            }
            
            
            
            
            personArray.append(newPerson)
            selectedPersonIndex = personArray.count-1

            print("added person " + newPerson.name)
            
        }
        
    }
    
}