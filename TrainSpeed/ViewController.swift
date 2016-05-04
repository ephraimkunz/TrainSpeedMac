//
//  ViewController.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/3/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    var trainId = "";
    let dataSource = DataSource();

    @IBOutlet weak var currentTrainTextField: NSTextField!
    @IBOutlet weak var networkSpinner: NSProgressIndicator!
    @IBOutlet var trainInfoTextView: NSTextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        networkSpinner.displayedWhenStopped = false
    }

    @IBAction func currentTrainChanged(sender: AnyObject) {
        if let textField = sender as? NSTextField{
            self.trainId = textField.stringValue
        }
        
        if(trainId != ""){
            networkSpinner.startAnimation(self)
            dataSource.fetchJSONFromUTA(trainId){
                (data: NSData) in
                self.trainInfoTextView.string = String(data: data, encoding: NSUTF8StringEncoding)
                self.networkSpinner.stopAnimation(self)
            }
        }
    }

}

