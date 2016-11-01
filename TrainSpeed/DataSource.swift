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
    
    func getVehicleDatapoint(_ vehicleID:String, callback:@escaping (VehicleDatapoint, Error?) -> Void) -> Void{
        let session = URLSession(configuration: URLSessionConfiguration.default);

        let url = buildUrl(vehicleID)
        let dataTask = session.dataTask(with: url, completionHandler: {data, response, error in
            if let error = error{
                print(error.localizedDescription)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    DispatchQueue.main.async{ //Execute the callback on the main thread
                        if let vehicleDatapoint = self.parser.parseVehicleDatapoint(data!){
                            if(vehicleDatapoint.isValidDatapoint()){
                                self.addToRealm(vehicleDatapoint) //Should this be on the main thread? If performance problems, execute this in the background as well.
                                callback(vehicleDatapoint, nil)
                            }
                            else{
                                callback(vehicleDatapoint, Error(reason: "Invalid vehicle"))
                            }
                        }
                        else{
                            //Got back a response with no information on this vehicle
                        }
                    }
                }
            }
        })
        dataTask.resume()
    }
    
    func buildUrl(_ vehicleID: String) -> URL{
        let fullString = baseUrl + "&vehicle=\(vehicleID)";
        let url = URL(string: fullString);
        return url!;
    }
    
    func addToRealm(_ realmItem : Object) -> Void{
        try! realm.write{
            realm.add(realmItem)
        }
    }
    
    func removeFromRealm(_ vehicleId: String){
        let predicate = NSPredicate(format: "vehicleRef = %@", vehicleId)
        let allWithId = realm.objects(VehicleDatapoint.self).filter(predicate)
        
        try! realm.write{
            realm.delete(allWithId)
        }
    }
    
    func readForId(_ vehicleId: String) -> Results<VehicleDatapoint>{
        let predicate = NSPredicate(format: "vehicleRef = %@", vehicleId)
        let results = realm.objects(VehicleDatapoint.self).filter(predicate).sorted(byProperty: "timestampRaw")
        return results
    }
}
