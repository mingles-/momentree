//
//  FamilyBuilderController.swift
//  momentree
//
//  Created by Michael Inglis on 03/12/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import UIKit

class FamilyBuilderController: UIViewController {
    
    
    @IBOutlet weak var addPersonFamilyBuilderButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func addPersonButton(sender: AnyObject) {
        print(nameTextField.text!)
        let obj = Person(name: nameTextField.text!)
        
    }
  
}