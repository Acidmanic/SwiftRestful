//
//  HttpResponse.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/6/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

public class HttpResponse<T>{
    public var RequestResult:HttpReponseStatus=HttpReponseStatus.NoRequestMade
    public var Value:T!
    public var ArrayValue:[T]!
    public var resultIsArray:Bool=false
    public var ResponseError:Error!
    public var ResponseCode:Int=0
    public var ResponseHeaders:[String:String]=[:]
    public var ResponseCharset:String="utf-8"
    public var ResponseCharsetEncoding:String.Encoding = .utf8
    
}
