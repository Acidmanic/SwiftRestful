//
//  Todo.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/4/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

class Todo:NamingRitchJsonableBase, Jsonable{
    
    var title:String!
    var body:String!
    var userId:Int!
    var id:Int!
    
    required override init() {
        
    }
    
    required init(title:String! , body:String , userId:Int) {
        super.init()
        self.title=title
        self.body=body
        self.userId=userId
        self.id=0
    }
    
    func load(jsonData: JsonMediumType!) {
        self.title = getString(jsonData, "title")
        self.body = getString(jsonData, "body")
        self.userId = getInt(jsonData, "userId")
        self.id = getInt(jsonData, "id")
    }
    
    
    
}
