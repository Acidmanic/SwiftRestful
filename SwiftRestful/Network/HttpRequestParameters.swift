//
//  HttpRequestParams.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/23/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation
class HttpRequestParameters{
    var url:String
    var method:HttpMethod
    var headers:[String:String]
    var contentData:Data!
    
    init(url:String,method:HttpMethod,headers:[String:String],
         contentData:Data!) {
        self.url=url
        self.method=method
        self.headers=headers
        self.contentData=contentData
    }
    
    init(url:String){
        self.url=url
        self.method=HttpMethod.GET
        self.headers=[:]
    }
}
