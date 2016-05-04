//
//  DataSource.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/3/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
class DataSource : NSObject{
    let baseUrl = "http://api.rideuta.com/SIRI/SIRI.svc/VehicleMonitor/ByVehicle?vonwardcalls=true&usertoken=UQFDGBPBEDT"
    
    func fetchJSONFromUTA(vehicleID:String, callback:(NSData) -> Void) -> Void{
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration());

        let url = buildUrl(vehicleID)
        let dataTask = session.dataTaskWithURL(url){data, response, error in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let httpResponse = response as? NSHTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    dispatch_async(dispatch_get_main_queue()){ //Make sure we go back to the main thread while updating UI.
                        callback(data!)
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
}