//
//  ReqresUser.swift
//  SwiftRestfulTests iOS
//
//  Created by Mani Moayedi on 12/8/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
import SwiftRestful

class ReqresUser:NamingRitchJsonableBase, Jsonable{
    
    var name:String!
    var job:String!
    var updatedAt:String!
    
    func load(jsonData: JsonMediumType!) {
        
        self.name = getString(jsonData, "name")
        
        self.job = getString(jsonData, "job")
        
        self.updatedAt = getString(jsonData, "updatedAt")
    }
    
    
    
    
    required override init(){
        
    }
    
    init(name:String,job:String) {
        self.name = name
        self.job = job
    }
    
    
}
