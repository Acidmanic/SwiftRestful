//
//  HttpbinTodo.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
class HttpbinTodo:HttpBinAnything{
    
    var form:Todo!
    var args:Todo!
    
    required init() {
        super.init()
    }
    
    override func load(jsonData: JsonMediumType!) {
        super.load(jsonData: jsonData)
        
        self.form = getTodo(jsondData: jsonData, key: "form")
        
        self.args = getTodo(jsondData: jsonData, key: "args")
        
    }
    
    private func getTodo(jsondData:JsonMediumType,key:String)->Todo!{
        if let formData = jsondData[key] {
            let ret = Todo()
            if let jdata = formData as? JsonMediumType {
                ret.load(jsonData: jdata)
                return ret
            }
        }
        return nil
    }
}
