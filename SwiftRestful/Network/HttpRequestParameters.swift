//
//  HttpRequestParams.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/23/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation
public class HttpRequestParameters{
    public var url:String
    public var method:HttpMethod
    public var headers:[String:String]
    public var contentData:Data!
    
    public init(url:String,method:HttpMethod,headers:[String:String],
         contentData:Data!) {
        self.url=url
        self.method=method
        self.headers=headers
        self.contentData=contentData
    }
    
    public init(url:String){
        self.url=url
        self.method=HttpMethod.GET
        self.headers=[:]
    }
}
