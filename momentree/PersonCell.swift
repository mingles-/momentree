//
//  PersonCell.swift
//  momentree
//
//  Created by Michael Inglis on 15/11/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import UIKit

class PersonCell: UITableViewCell {
    
    @IBOutlet var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func create(name: String) {
        self.name.text = name
    }
    
}
