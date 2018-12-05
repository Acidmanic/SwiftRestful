//
//  HttpBinAnything.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

class HttpBinAnything:NamingRitchJsonableBase,Jsonable{
    
    var headers:[String:String]=[:]
    var method:String="WTF"
    var data:String!
    
    required override init() {
        
    }
    
    func load(jsonData: JsonMediumType!) {
        
        if let headers = jsonData["headers"] as? [String:Any]{
            for (key,value) in headers{
                if let svalue = value as? String{
                    self.headers[key] = svalue
                }
            }
        }
        
        self.method = getString(jsonData, "method")
        
        self.data = getString(jsonData, "data")
    }
    
}



