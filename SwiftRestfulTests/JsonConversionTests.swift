//
//  JsonConversionTests.swift
//  ICP.UI.IOSTests
//
//  Created by Mani Moayedi on 12/8/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftRestful

class JsonConversionTests: XCTestCase {
    
    class SimpleModel:Jsonable{
        var name:String!="Simple 1"
        required init() {        }
        func load(jsonData: JsonMediumType!) {
            self.name = jsonData["name"] as! String
        }
    }
    
    class NestedModel:Jsonable{
        var format:String!="Version2"
        var simple:SimpleModel!=SimpleModel()
        required init() {        }
        func load(jsonData: JsonMediumType!) {
            guard let data = jsonData else {
                return
            }
            self.format = data["format"] as? String
            self.simple = SimpleModel()
            if let simpleMedium = data["simple"] as? JsonMediumType{
                self.simple.load(jsonData: simpleMedium)
            }
            
        }
    }
    
    func testJsonConversion(){
        let mainObject = NestedModel()
        mainObject.format="newFormatAstIn"
        mainObject.simple.name="SadeNabash"
        let medium = mainObject.getJsonData()
        let clone = NestedModel()
        clone.load(jsonData: medium)
        XCTAssertEqual(mainObject.format, clone.format)
        XCTAssertEqual(mainObject.simple.name, clone.simple.name)
        let jsonData = try?
            JSONSerialization.data(withJSONObject: medium, options:[])
        let jsonString = String(data:jsonData!,encoding:String.Encoding.utf8)
        print(jsonString!)
    }

    class JsonableWithTimespan:Jsonable{
        
        var title:String!
        var time:Timespan!
        
        func load(jsonData: JsonMediumType!) {
            self.title=jsonData["title"] as? String;
            self.time=Timespan(timeString:jsonData["time"] as? String)
        }
        
        required init() {        }
    }
    
    func testJsonableWithTimespan(){
        print("\n\n\n")
        print("testJsonableWithTimespan")
        let mainInstance = JsonableWithTimespan()
        mainInstance.title="Mani"
        mainInstance.time=Timespan(hours:1,minutes:23,seconds:45)
        let jsonMed = mainInstance.getJsonData()
        let result = JsonableWithTimespan()
        result.load(jsonData:jsonMed)
        XCTAssertEqual(mainInstance.title,result.title)
        XCTAssertEqual(mainInstance.time.hours,result.time.hours)
        XCTAssertEqual(mainInstance.time.minutes,result.time.minutes)
        XCTAssertEqual(mainInstance.time.seconds,result.time.seconds)
        print("Title: " + result.title)
        print("Time: " + result.time.toString())
        print("\n\n\n")
    }
}
















