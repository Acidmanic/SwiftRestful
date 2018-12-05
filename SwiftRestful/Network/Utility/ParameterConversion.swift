//
//  ParameterConversion.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

class ParameterConversion{
    
    internal func encodeParams(params:[String:String])->String{
        var ret = ""
        var sep = ""
        for (key,value) in params {
            ret = ret + sep + key + "=" + value
            sep="&"
        }
        return ret.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
    
    internal func convert(data:Jsonable)->Data!{
        
        let medium = data.getJsonData()
        
        return try? JSONSerialization.data(withJSONObject: medium, options: [])
        
    }
}
