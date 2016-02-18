//
//  FamilyViewController.swift
//  momentree
//
//  Created by Michael Inglis on 21/09/2015.
//  Copyright © 2015 Michael Inglis. All rights reserved.
//

import UIKit
import SwiftyJSON

var personArray = [Person]()
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




var ancestorSliderValues = [0,1,2,3,4]
var descendantSliderValues = [0,1,2,3,4]

var ancestorHeight = ancestorSliderValues.last!
var descendantHeight = descendantSliderValues.last!

var selectedPersonIndex = 0

var theTree = FamilyTree(owner: personArray[selectedPersonIndex], ancestorHeight: ancestorHeight, descendantHeight: descendantHeight, hasSpouse: true)





class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var addPersonButton: UIBarButtonItem!
    @IBOutlet weak var editPersonButton: UIBarButtonItem!
    
    @IBOutlet weak var ancestorSlider: UISlider!
    @IBOutlet weak var ancestorSliderView: UILabel!
    @IBOutlet weak var descendantSlider: UISlider!
    @IBOutlet weak var descendantSliderView: UILabel!
    
    
    @IBOutlet weak var spouseLabel: UILabel!
    @IBOutlet weak var spouseSwitch: UISwitch!
    

    var selectedPerson = Person(name: "")
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if personArray.count == 0 {
            personArray = [fiona, mingles, stuart, lesley, adam, emma, alex, francis, cathy, joan, rab, louis]
            // set inital person
            
            
            // set up relationships
            mingles.setParents(stuart, mum: lesley)
            fiona.setParents(stuart, mum: lesley)
            adam.setParents(alex, mum: emma)
            lesley.setParents(rab, mum: joan)
            emma.setParents(rab, mum: joan)
            stuart.setParents(francis, mum: cathy)
            francis.setDad(louis)
        }
        
        selectedPersonIndex = personArray.count-1
        selectedPerson = personArray[selectedPersonIndex]
        
        
        ancestorSlider.minimumValue = 0
        ancestorSlider.maximumValue = Float(ancestorSliderValues.last!)
        ancestorSlider.continuous = false
        ancestorSlider.value = Float(ancestorSliderValues.last!)
        ancestorSliderView.text = String(ancestorHeight)
            
        descendantSlider.minimumValue = 0
        descendantSlider.maximumValue = Float(descendantSliderValues.last!)
        descendantSlider.continuous = false
        descendantSlider.value = Float(descendantSliderValues.last!)
        descendantSliderView.text = String(descendantHeight)
        
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadInputViews()
        
        let url = NSMutableURLRequest(URL: NSBundle.mainBundle().URLForResource("AncestorDescendentView", withExtension:"html")!)
        
        webView.loadRequest(url)
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        
        theTree = FamilyTree(owner: selectedPerson, ancestorHeight: ancestorHeight, descendantHeight: descendantHeight, hasSpouse: true)
        
        // alter slider values based on new tree
        ancestorSliderValues = theTree.ancestorSlider
        descendantSliderValues = theTree.descendantSlider

        ancestorSlider.maximumValue = Float(ancestorSliderValues.last!)
        ancestorHeight = ancestorSliderValues[Int(ancestorSlider.value)]
        ancestorSliderView.text = String(ancestorHeight)
        
        
        descendantSlider.maximumValue = Float(descendantSliderValues.last!)
        descendantHeight = descendantSliderValues[Int(descendantSlider.value)]
        descendantSliderView.text = String(descendantHeight)
        
        
        // edit color of sliders based on values
        if ancestorSliderValues.count == 1 {
            ancestorSlider.maximumTrackTintColor = UIColor .whiteColor()
        } else {
            ancestorSlider.maximumTrackTintColor = UIColor .grayColor()
        }
        if descendantSliderValues.count == 1 {
            descendantSlider.maximumTrackTintColor = UIColor .whiteColor()
        } else {
            descendantSlider.maximumTrackTintColor = UIColor .grayColor()
        }
        
        if selectedPerson.spouse == nil {
            
            spouseLabel.hidden = true
            spouseSwitch.hidden = true
            
        } else {
            
            spouseLabel.hidden = false
            spouseSwitch.hidden = false
            
        }
       
        let jsonInput = JSON(theTree.fullTree()).rawString()

        
        var textToInput = "" + jsonInput! + ""
        textToInput = textToInput.stringByReplacingOccurrencesOfString("\n", withString: "")
        textToInput = textToInput.stringByReplacingOccurrencesOfString(" ", withString: "")
        let script = String(format:"document.getElementById('json-pass-in').title='%@'", textToInput)
        let script2 = String("drawGraph(true);")
        
        webView.stringByEvaluatingJavaScriptFromString(script)
        webView.stringByEvaluatingJavaScriptFromString(script2)
        
    }
    
    @IBAction func ancestorGenerationChanged(sender: AnyObject) {
        
        // snap to value
        ancestorSlider.value = round(ancestorSlider.value)
        
        // set height for next FamilyTree
        ancestorHeight = ancestorSliderValues[Int(ancestorSlider.value)]
        
        ancestorSliderView.text = String(ancestorHeight)
        webView.reload()
    }

    @IBAction func descendantGenerationChanged(sender: AnyObject) {
        
        // snap to value
        descendantSlider.value = round(descendantSlider.value)
        
        // set height for next FamilyTree
        descendantHeight = descendantSliderValues[Int(descendantSlider.value)]
        
        descendantSliderView.text = String(descendantHeight)
        
        webView.reload()
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCellWithIdentifier("personCell") as! PersonCell
        cell.create((personArray[indexPath.row]).name)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPerson = personArray[indexPath.row]
        selectedPersonIndex = indexPath.row
        webView.reload()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}



