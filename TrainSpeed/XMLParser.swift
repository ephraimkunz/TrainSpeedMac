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
    
    func parseVehicleDatapoint(data : NSData) -> VehicleDatapoint?{
        let parser = NSXMLParser(data: data)
        parser.delegate = self
        parser.parse()
        return datapoint
    }
    
    // MARK: Delegate methods
    @objc func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]){
        
    }
    
    @objc func parser(parser: NSXMLParser, foundCharacters string: String){
        
    }
    
    @objc func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?){
        
    }
}