//
//  XMLParser.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/7/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation

class XMLParser : NSObject, XMLParserDelegate {
    var insideItem = false
    var currentParseElement = String()
    var datapoint : VehicleDatapoint?
    var location : Location?
    
    func parseVehicleDatapoint(_ data : Data) -> VehicleDatapoint?{
        let parser = Foundation.XMLParser(data: data)
        parser.delegate = self
        datapoint = VehicleDatapoint()
        location = Location()
        parser.parse()
        
        datapoint?.location = location
        
        return datapoint
    }
    
    // MARK: Delegate methods
    @objc func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        currentParseElement = elementName
    }
    
    @objc func parser(_ parser: XMLParser, foundCharacters string: String){
        switch currentParseElement {
        case "ResponseTimestamp":
            datapoint?.timestamp = parseDateFromString(string)
            let timestampRaw = datapoint?.timestamp.timeIntervalSince1970
            datapoint?.timestampRaw = timestampRaw!
            
        case "ValidUntil":
            datapoint?.validUntil = parseDateFromString(string)
            
        case "LineRef":
            datapoint?.lineRef = string
            
        case "DirectionRef":
            datapoint?.directionRef = string
            
        case "PublishedLineName":
            datapoint?.publishedLineName = string
            
        case "Longitude":
            if let double = Double(string){
                location?.longitude = double
            }
            
        case "Latitude":
            if let double = Double(string){
                location?.latitude = double
            }
            
        case "VehicleRef":
            datapoint?.vehicleRef = string
            
        case "Bearing":
            if let double = Double(string){
                datapoint?.bearing = double
            }
        
        case "Speed":
            if let double = Double(string){
                datapoint?.speed = double
            }
            
        case "DestinationName":
            datapoint?.destinationName = string
        default:
            break
        }
    }
    
    @objc func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
    }
    
    func parseDateFromString(_ string:String) -> Date{
        return Date()
    }
}
