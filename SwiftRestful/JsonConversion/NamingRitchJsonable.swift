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
    
    internal var acceptingNamingConventions = [NamingConventions.CamelCase,NamingConventions.PascallCase]
    
    internal func getJsonValue(_ jsonData:JsonMediumType,_ key:String)->Any!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)
    }
    
    internal func getInt64(_ jsonData:JsonMediumType,_ key:String)->Int64!{
        if let data = jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions) {
            if let idata = data as? Int64 {
                return idata
            }
            if let sdata = data as? String, let idata = Int64(sdata){
                return idata
            }
        }
        return nil
    }
    
    internal func getInt(_ jsonData:JsonMediumType,_ key:String)->Int!{
        if let data = jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions) {
            if let idata = data as? Int {
                return idata
            }
            if let sdata = data as? String{
                if let idata = Int(sdata) {
                    return idata
                }
            }
        }
        return nil
    }
    
    internal func getString(_ jsonData:JsonMediumType,_ key:String)->String!{
    return jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions)as?String
    }
    internal func getDouble(_ jsonData:JsonMediumType,_ key:String)->Double!{
        
        if let data = jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions){
            if let dData = data as? Double {
                return dData
            }
            if let sdata = data as? String , let dData = Double(sdata) {
                return dData
            }
        }
        return nil
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
    
    internal func getJsonable<T:Jsonable>(_ jsonData:JsonMediumType,_ key:String)->T!{
        if let data = jsonData.getValueByAnyOfCases(key: key, namingCases: self.acceptingNamingConventions){
            let ret = T()
            ret.load(jsonData: data as! JsonMediumType)
            return ret
        }
        return nil
    }
}
