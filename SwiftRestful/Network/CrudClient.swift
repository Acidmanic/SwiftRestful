//
//  RestfulClient.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/8/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

public class CrudClient{
    
    private var endpoint:String
    
    private let httpApiClient:HttpApiClient
    
    private static var globalInterceptors:[HttpRequestInterceptor]=[]
    
    
    private class InterceptionProxy:HttpRequestInterceptor{
        func onRequest(requestParams: HttpRequestParameters) -> HttpRequestParameters {
            return ListHttpInterceptor().intercept(interceptors: CrudClient.globalInterceptors
                ,params: requestParams)
        }
    }
    
    public init(endpoint:String) {
        
        httpApiClient = HttpApiClient()
        
        httpApiClient.pushInstanceInterceptor(interceptor: InterceptionProxy())
        
        self.endpoint = endpoint
    }
    
    
    public func create<T:Jsonable>(object:T, callback: @escaping(_ response:T)->Void){
        
        self.httpApiClient.post.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .contentType(HttpHeaderCollection.JsonContentType)
            .jsonData(object).request { (response:HttpResponse<T>) in
                
                callback(response.Value)
                
        }
    
    }
    
    public func read<T:Jsonable>(callback: @escaping(_ response:[T])->Void){
        
        self.httpApiClient.get.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .contentType(HttpHeaderCollection.JsonContentType)
            .request{ (response:HttpResponse<T>) in
                
                var ret:[T]=[]
                
                if response.RequestResult == HttpResponseStatus.Succeed {
                    if response.resultIsArray {
                        ret = response.ArrayValue
                    }
                }
                
                callback(ret)
                
        }
        
    }
    
    
    public func read<T:Jsonable>(params:[String:String],
                                 callback: @escaping(_ response:T?)->Void){
        
        self.httpApiClient.get.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .urlData(params).request{ (response:HttpResponse<T>) in
                
                var object:T? = nil
                
                if HttpClient.isReponseOK(code: response.ResponseCode){
                    
                    if response.resultIsArray {
                        
                        object = response.ArrayValue[0]
                        
                    }else{
                        
                        object = response.Value
                    }
                    
                    callback(object)
                }
                
                
        }
        
    }
    
    
    public func update<T:Jsonable>(object:T, callback: @escaping(_ success:Bool)->Void){
        
        self.httpApiClient.put.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .contentType(HttpHeaderCollection.JsonContentType)
            .jsonData(object).request { (response:HttpResponse<JsonableVoid>) in
                
                callback(HttpClient.isReponseOK(code: response.ResponseCode))
                
        }
        
    }
    
    public func update<T:Jsonable>(object:T, callback: @escaping(_ response:T?)->Void){
        
        self.httpApiClient.put.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .contentType(HttpHeaderCollection.JsonContentType)
            .jsonData(object).request { (response:HttpResponse<T>) in
                
                var object:T? = nil
                
                if HttpClient.isReponseOK(code: response.ResponseCode){
                    object = response.Value
                }
                
                callback(object)
                
        }
        
    }
    
    public func delete(params:[String:String],
                                 callback: @escaping(_ response:Bool)->Void){
        
        self.httpApiClient.delete.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .urlData(params).request{ (response:HttpResponse<JsonableVoid>) in
                
                callback(HttpClient.isReponseOK(code: response.ResponseCode))
        }
        
    }
    
    public func pushInstanceInterceptor(interceptor:HttpRequestInterceptor){
        self.httpApiClient.pushInstanceInterceptor(interceptor: interceptor)
    }
    
    public static func pushGlobalInterceptor(interceptor:HttpRequestInterceptor){
        CrudClient.globalInterceptors.append(interceptor)
    }
}
