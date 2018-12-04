//
//  NamingRitchJsonable.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/4/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
import NamingConventions

public class NamingRitchJsonableBase{
    
    internal let acceptingNamingConventions = [NamingConventions.CamelCase,NamingConventions.PascallCase]
    
    internal func getJsonValue(_ jsonData:JsonMediumType,_ key:String)->Any!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)
    }
    
    internal func getInt64(_ jsonData:JsonMediumType,_ key:String)->Int64!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)as?Int64
    }
    
    internal func getInt(_ jsonData:JsonMediumType,_ key:String)->Int!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)as?Int
    }
    
    internal func getString(_ jsonData:JsonMediumType,_ key:String)->String!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)as?String
    }
    internal func getDouble(_ jsonData:JsonMediumType,_ key:String)->Double!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)as?Double
    }
    internal func getTimespan(_ jsonData:JsonMediumType,_ key:String)->Timespan!{
    if let sTimespan = getString(jsonData, key){
    return Timespan(timeString:sTimespan)
    }
    return nil
    }
//    internal func getDate(_ jsonData:JsonMediumType,_ key:String)->Date!{
//    if let sDate = getString(jsonData, key){
//    return Date.fromApiStringDate(dateString: sDate)
//    }
//    return nil
//    }
    internal func getBool(_ jsonData:JsonMediumType,_ key:String)->Bool!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)as?Bool
    }
}
