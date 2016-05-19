//
//  ViewController.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/3/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Cocoa
import RealmSwift

class ViewController: NSViewController {
    var trainId = "";
    let dataSource = DataSource();
    var datapoint = VehicleDatapoint()

    @IBOutlet weak var currentTrainTextField: NSTextField!
    @IBOutlet weak var networkSpinner: NSProgressIndicator!
    @IBOutlet var trainInfoTextView: NSTextView!

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        networkSpinner.displayedWhenStopped = false
        print("Realm configuration path: \(Realm.Configuration.defaultConfiguration.fileURL!)")

    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window!.title = "TrainSpeed - Ephraim Kunz"
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toHistoryViewController"){
            let hist = segue.destinationController as! HistoryViewController
            hist.vehicleId = trainId
        }
    }

    @IBAction func currentTrainChanged(sender: AnyObject) {
        if let textField = sender as? NSTextField{
            self.trainId = textField.stringValue
        }
        
        if(trainId != ""){
            networkSpinner.startAnimation(self)
            dataSource.getVehicleDatapoint(trainId){
                (datapoint: VehicleDatapoint, error: Error?) in
                if let error = error{
                    self.trainInfoTextView.string = "We are unable to track a train for train id \(self.trainId). Error message: \(error.reason)"
                    self.networkSpinner.stopAnimation(self)
                }
                else{
                    //Do something with the datapoint
                    self.datapoint = datapoint;
                    self.networkSpinner.stopAnimation(self)
                    self.trainInfoTextView.string = "\(datapoint.publishedLineName) - \(datapoint.speed) mph"
                }
            }
        }
    }

}

