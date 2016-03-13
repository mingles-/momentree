//
//  PersonEditorController.swift
//  momentree
//
//  Created by Michael Inglis on 06/12/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PersonEditorController: UIViewController, UIPickerViewDataSource,UIPickerViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var fatherPicker: UIPickerView!
    @IBOutlet weak var motherPicker: UIPickerView!
    @IBOutlet weak var albumPicker: UIPickerView!
    
    
    var pickerDataSource = [Person]()
    
    @IBOutlet weak var saveButton: UIButton!
    
    
    @IBOutlet weak var fatherChangeMode: UIButton!
    @IBOutlet weak var motherChangeMode: UIButton!
    
    @IBOutlet weak var fatherPersonBox: UITextField!
    @IBOutlet weak var motherPersonBox: UITextField!
    
    var fatherMode = true
    var motherMode = true
    
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
        
        
        let thePerson = personArray[selectedPersonIndex]
        let nullPerson = Person(name: "")
        
        var tempPersonArray = personArray
        tempPersonArray.append(nullPerson)
        var dadIndex = 0
        var mumIndex = 0
        var albumIndex = 0
        
        nameLabel.text = thePerson.name

        print("editing " + thePerson.name)
        
        var tempDataSource = personArray
        tempDataSource.append(nullPerson)
        pickerDataSource = tempDataSource.reverse()
        
        fatherPersonBox.hidden = true
        motherPersonBox.hidden = true
        
        fatherPicker.hidden = false
        motherPicker.hidden = false
        
        albumPickerSource.append("")
        albumIdentifiers.append("")
        getAlbums()
        
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
        
        if thePerson.albumTitle != nil {
            for p in albumIdentifiers {
                if (p == thePerson.albumTitle){
                    break
                }
                albumIndex += 1
            }
        }
        
        motherPicker.selectRow(mumIndex, inComponent: 0, animated: true)
        fatherPicker.selectRow(dadIndex, inComponent: 0, animated: true)
        albumPicker.selectRow(albumIndex, inComponent: 0, animated: true)
        
    }
    
    func getAlbums() {
        
        let albums: PHFetchResult = PHAssetCollection.fetchAssetCollectionsWithType(.Album, subtype: .Any, options: nil)
        
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

    @IBAction func addPersonButton(sender: AnyObject) {
        
            let newPerson = personArray[selectedPersonIndex]
        
            let fatherIndex = fatherPicker.selectedRowInComponent(0)
            let motherIndex = motherPicker.selectedRowInComponent(0)
            let selectedNewDad = pickerDataSource[fatherIndex]
            let selectedNewMum = pickerDataSource[motherIndex]
        
            if fatherMode {
                
                if fatherIndex != 0 {
                    print("setting " + newPerson.name + " dad")
                    newPerson.setDad(selectedNewDad)
//                    if motherIndex != 0 {
//                        selectedNewDad.setSpouse(selectedNewMum)
//                    }
                } else {
                    print("removing " + newPerson.name + " dad")
                    newPerson.removeDad()
                }
                
            } else if fatherPersonBox.text != "" {
                let newDad = Person(name: fatherPersonBox.text!)
                newPerson.setDad(newDad)
                personArray.append(newDad)
                
            }
        
        
            if motherMode {
                if motherIndex != 0 {
                    print("setting " + newPerson.name + " mum")
                    newPerson.setMum(selectedNewMum)
                } else {
                    print("removing " + newPerson.name + " mum")
                    newPerson.removeMum()
                }
                
                
            } else if motherPersonBox.text != "" {
                let newMum = Person(name: motherPersonBox.text!)
                personArray.append(newMum)
                newPerson.setMum(newMum)
                }
        
            // assuming both aren't 0, set parents as spouse
            if newPerson.mum != nil && newPerson.dad != nil {
                newPerson.mum!.setSpouse(newPerson.dad!)
            }
            
        
        
            let albumIndex = albumPicker.selectedRowInComponent(0)
        
            if albumIndex != 0 {
                newPerson.albumTitle = albumIdentifiers[albumIndex]
                let albumName = albumPickerSource[albumIndex]
                print("added album " + albumName)
                
            }
    
        
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