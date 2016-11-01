//
//  VehicleDatapoint.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/7/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import RealmSwift

class VehicleDatapoint : Object{
    
    dynamic var timestamp = Date()
    dynamic var validUntil = Date()
    dynamic var lineRef = ""
    dynamic var directionRef = ""
    dynamic var vehicleRef = ""
    dynamic var publishedLineName = ""
    dynamic var location : Location?
    dynamic var bearing : Double = 0.0
    dynamic var speed : Double = 0.0
    dynamic var destinationName = ""
    dynamic var timestampRaw : Double = 0.0
    
    func isValidDatapoint() -> Bool{
        return vehicleRef != "" && location!.isValidLocation()
    }
}
