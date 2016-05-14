//
//  File.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/7/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation
import RealmSwift

class Location : Object{
    dynamic var latitude : Double = 0.0
    dynamic var longitude : Double = 0.0
    
    func isValidLocation() -> Bool{
        return latitude != 0.0 && longitude != 0.0
    }
}
