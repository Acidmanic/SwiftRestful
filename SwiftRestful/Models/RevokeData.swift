//
//  RevokeData.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/10/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation


class RevokeData:NamingRitchJsonableBase,Jsonable{
    
    
    var access_token:String!
    
    var client_id:String!
    
    func load(jsonData: JsonMediumType!) {
        
        self.access_token=getString(jsonData, "access_token")
        
        self.client_id=getString(jsonData, "client_id")
    }
    
    required override init() {
        
    }
    
    init(accessToken:String,clientId:String) {
        
        self.access_token=accessToken
        
        self.client_id=clientId
    }
    
}
