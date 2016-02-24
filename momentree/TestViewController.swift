//
//  PersonEditorController.swift
//  momentree
//
//  Created by Michael Inglis on 06/12/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import Foundation
import UIKit

class TestViewController: UIViewController {
    
    @IBOutlet weak var momentListLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        momentListLabel.text = String(momentList)
        
        
    }
    
}