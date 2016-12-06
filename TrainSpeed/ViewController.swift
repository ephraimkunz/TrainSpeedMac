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
    var timer = Timer()

    @IBOutlet weak var stopUpdatingButton: NSButtonCell!
    @IBOutlet weak var currentTrainTextField: NSTextField!
    @IBOutlet weak var networkSpinner: NSProgressIndicator!
    @IBOutlet var trainInfoTextView: NSTextView!
    @IBOutlet weak var historyModalButton: NSButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        historyModalButton.isEnabled = false

        // Do any additional setup after loading the view.
        networkSpinner.isDisplayedWhenStopped = false
        print("Realm configuration path: \(Realm.Configuration.defaultConfiguration.fileURL!)")
        stopUpdatingButton.isEnabled = false
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        self.view.window!.title = "TrainSpeed - Ephraim Kunz"
    }
    
    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        if(segue.identifier == "toHistoryViewController"){
            let hist = segue.destinationController as! HistoryViewController
            hist.vehicleId = trainId
        }
    }

    @IBAction func currentTrainChanged(_ sender: AnyObject) {
        if let textField = sender as? NSTextField{
            self.trainId = textField.stringValue
        }
        
        if(trainId != ""){
            historyModalButton.isEnabled = true
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
                    
                    //Set up the auto refresh timer
                    self.timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(ViewController.currentTrainChanged(_:)), userInfo: nil, repeats: false)
                    self.stopUpdatingButton.isEnabled = true
                    
                }
            }
        }
        else{
            historyModalButton.isEnabled = false
        }
    }

    @IBAction func stopUpdatingTapped(_ sender: AnyObject) {
        self.timer.invalidate()
        self.stopUpdatingButton.isEnabled = false
    }
}

