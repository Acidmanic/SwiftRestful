//
//  RequestBuilderBase.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation


public class RequestBuilderBase{
    
    
    /*  internal state: */
    
    private var url:String!
    
    internal var method:HttpMethod!
    
    private var headers:[String:String]
    
    private var contentData:Data!
    
    private var client:HttpClient
    
    private var encoding:String.Encoding
    
    private var urlExtera:String!
    
    /*  construction    */
    
    public init(client:HttpClient){
        self.url = "http://github.com/Acidmanic"
        
        self.method = HttpMethod.GET
        
        self.headers = [:]
        
        self.contentData = nil
        
        self.client = client
        
        self.encoding = .utf8
        
        self.urlExtera = nil
        
        self.accept(HttpHeaderCollection.TextContentType)
        
        self.addHeader(HttpHeaderCollection.AcceptCharset,HttpHeaderCollection.CharsetUtf8)
    }
    
    /*  fluent properties   */
    
    public func url(_ url:String)->RequestBuilderBase{
        self.url = url
        return self
    }
    
    public func headers(_ headers:[String:String])->RequestBuilderBase{
        self.headers = headers
        return self
    }
    
    @discardableResult
    public func addHeader(_ key:String,_ value:String)->RequestBuilderBase{
        self.headers[key] = value
        return self
    }
    
    public func contentType(_ contentType:String)->RequestBuilderBase{
        self.headers[HttpHeaderCollection.ContentType]=contentType
        return self
    }
    
    @discardableResult
    public func accept(_ accept:String)->RequestBuilderBase{
        self.headers[HttpHeaderCollection.Accept]=accept
        return self
    }
    
    public func encode(_ encoding:String.Encoding)->RequestBuilderBase{
        self.encoding = encoding
        return self
    }
    
    /*  sending data aqusation  */
    
    public func rawData(_ data:Data!)->RequestBuilderBase{
        self.contentData = data
        return self
    }
    
    public func rawData(_ data:String!)->RequestBuilderBase{
        self.contentData = data?.data(using: self.encoding)
        return self
    }
    
    public func urlData(_ data:[String:String])->RequestBuilderBase{
        self.urlExtera = ParameterConversion().encodeParams(params: data)
        return self
    }
    
    public func formData(_ data:[String:String])->RequestBuilderBase{
        self.contentData = ParameterConversion().encodeParams(params: data)
            .data(using: self.encoding)
        return self.contentType(HttpHeaderCollection.FormUrlContentType)
    }
    
    public func jsonData(_ data:Jsonable)->RequestBuilderBase{
        self.contentData = ParameterConversion().convert(data: data)
        return self.contentType(HttpHeaderCollection.JsonContentType)
    }
    
    /* result delivery? */
    
    public func request(callback:@escaping(_ result:HttpResult<Data>)->Void){
        
        let goingUrl = self.url + (self.urlExtera == nil ? "" : ("?"+self.urlExtera) )
    
        self.client.download(url: goingUrl, method: self.method,headers: self.headers,
                             callback:  callback)
    }
    
    public func request(callback:@escaping(_ result:HttpResult<String>)->Void){
        
        let goingUrl = self.url + (self.urlExtera == nil ? "" : ("?"+self.urlExtera) )
        
        self.client.download(url: goingUrl, method: self.method,headers: self.headers,
                             callback: CallbackConversion().stringCallback(callback: callback))
        
    }
    
    public func request<T:Jsonable>(callback:@escaping(_ result:HttpResult<T>)->Void){
        
        let goingUrl = self.url + (self.urlExtera == nil ? "" : ("?"+self.urlExtera) )
        
        self.client.download(url: goingUrl, method: self.method,headers: self.headers,
                             callback: CallbackConversion().jsonCallback(callback: callback))
        
    }
    
}
