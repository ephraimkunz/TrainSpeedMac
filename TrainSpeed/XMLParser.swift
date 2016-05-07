//
//  XMLParser.swift
//  TrainSpeed
//
//  Created by Ephraim Kunz on 5/7/16.
//  Copyright © 2016 Ephraim Kunz. All rights reserved.
//

import Foundation

class XMLParser : NSObject, NSXMLParserDelegate {
    var insideItem = false
    var currentParseElement = String()
    var datapoint : VehicleDatapoint?
    var location : Location?
    
    func parseVehicleDatapoint(data : NSData) -> VehicleDatapoint?{
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
        
        datapoint = VehicleDatapoint()
        location = Location()
        
        return datapoint
    }
    
    // MARK: Delegate methods
    @objc func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        currentParseElement = elementName
    }
    
    @objc func parser(parser: NSXMLParser, foundCharacters string: String){
        switch currentParseElement {
        case "ResponseTimestamp":
            datapoint?.timestamp = parseDateFromString(string)
            
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
    
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
    }
    
    func parseDateFromString(string:String) -> NSDate{
        return NSDate()
    }
}