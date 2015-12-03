//
//  ViewController.swift
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





class MinglesController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var webView: UIWebView!
    @IBOutlet var table: UITableView!
    @IBOutlet weak var addPersonButton: UIBarButtonItem!
    
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
        
        selectedPerson = personArray[personArray.count-1]
                
        self.table.delegate = self
        self.table.dataSource = self
        self.table.reloadInputViews()
        
        let url = NSMutableURLRequest(URL: NSBundle.mainBundle().URLForResource("index", withExtension:"html")!)
        
        webView.loadRequest(url)
     
        
        
        
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        print("started didFinish")
        let jsonInput = JSON([selectedPerson.getDict(10)]).rawString()
        
        var textToInput = "" + jsonInput! + ""
        
        textToInput = textToInput.stringByReplacingOccurrencesOfString("\n", withString: "")
        textToInput = textToInput.stringByReplacingOccurrencesOfString(" ", withString: "")
        print(textToInput)
        let script = String(format:"document.getElementById('json-pass-in').title='%@'", textToInput)
        let script2 = String("drawGraph(true);")
        
        webView.stringByEvaluatingJavaScriptFromString(script)
        
        webView.stringByEvaluatingJavaScriptFromString(script2)
        
    }
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(personArray.count)
        return personArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.table.dequeueReusableCellWithIdentifier("personCell") as! PersonCell
        cell.create((personArray[indexPath.row]).name)
        print((personArray[indexPath.row]).name)
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPerson = personArray[indexPath.row]
        webView.reload()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    

}



