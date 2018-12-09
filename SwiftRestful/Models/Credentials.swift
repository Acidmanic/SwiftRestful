//
//  Credentials.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/9/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

public class Credentials{
    
    var username:String=""
    
    var password:String=""
    
    init(username:String,password:String) {
        self.username = username
        self.password = password
    }
    
    init() {
    }
    
}
