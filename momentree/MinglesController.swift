//
//  ViewController.swift
//  momentree
//
//  Created by Michael Inglis on 21/09/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import UIKit
import SwiftyJSON

class MinglesController: UIViewController {

    var fiona = Person(name: "fiona")
    var mingles = Person(name:"mingles")
    var stuart = Person(name:"stuart")
    var lesley = Person(name:"lesley")
    
    var adam = Person(name: "adam")
    var emma = Person(name:"emma")
    var alex = Person(name: "alex")
    
    
    var francis = Person(name: "francis")
    var cathy = Person(name: "cathy")
    
    var joan = Person(name: "joan")
    var rab = Person(name: "rab")
    
    var louis = Person(name: "louis")
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        print("loaded")
        mingles.setParents(stuart, mum: lesley)
        fiona.setParents(stuart, mum: lesley)
        adam.setParents(alex, mum: emma)
        lesley.setParents(rab, mum: joan)
        emma.setParents(rab, mum: joan)
        stuart.setParents(francis, mum: cathy)
        francis.setDad(louis)
        
        
        print(joan.getDict(10))
        
        test.lineBreakMode = .ByWordWrapping // or NSLineBreakMode.ByWordWrapping
        test.numberOfLines = 0
        
        test.text = JSON(joan.getDict(10)).description
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var test: UILabel!
    
    @IBAction func loadurlAction(sender: AnyObject) {
        print("pressed")
        
        
        let url = NSMutableURLRequest(URL: NSBundle.mainBundle().URLForResource("index", withExtension:"html")!)
        
        webView.loadRequest(url)

        
    }


}



