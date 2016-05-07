//
//  DataSource.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/3/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import RealmSwift

class DataSource {
    let baseUrl = "http://api.rideuta.com/SIRI/SIRI.svc/VehicleMonitor/ByVehicle?vonwardcalls=true&usertoken=UQFDGBPBEDT"
    let realm = try! Realm()
    let parser = XMLParser()
    
    func getVehicleDatapoint(vehicleID:String, callback:(VehicleDatapoint) -> Void) -> Void{
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());

        let url = buildUrl(vehicleID)
        let dataTask = session.dataTaskWithURL(url){data, response, error in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    dispatch_async(dispatch_get_main_queue()){ //Execute the callback on the main thread
                        if let vehicleDatapoint = self.parser.parseVehicleDatapoint(data!){
                            self.addToRealm(vehicleDatapoint)
                            callback(vehicleDatapoint);
                        }
                        else{
                            //Got back a response with no information on this vehicle
                        }
                    }
                }
            }
        }
        dataTask.resume()
    }
    
    func buildUrl(vehicleID: String) -> NSURL{
        let fullString = baseUrl + "&vehicle=\(vehicleID)";
        let url = NSURL(string: fullString);
        return url!;
    }
    
    func addToRealm(realmItem : Object) -> Void{
        try! realm.write{
            realm.add(realmItem)
        }
    }
}