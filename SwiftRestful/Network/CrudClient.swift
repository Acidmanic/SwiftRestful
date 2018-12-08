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
    
    
    
    public init(endpoint:String) {
        self.endpoint = endpoint
    }
    
    
    public func create<T:Jsonable>(object:T, callback: @escaping(_ response:T)->Void){
    
        let client = HttpApiClient()
        
        client.post.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .contentType(HttpHeaderCollection.JsonContentType)
            .jsonData(object).request { (response:HttpResponse<T>) in
                
                callback(response.Value)
                
        }
    
    }
    
    public func read<T:Jsonable>(callback: @escaping(_ response:[T])->Void){
        
        let client = HttpApiClient()
        
        client.get.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
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
        let client = HttpApiClient()
        
        client.get.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
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
        
        let client = HttpApiClient()
        
        client.put.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .contentType(HttpHeaderCollection.JsonContentType)
            .jsonData(object).request { (response:HttpResponse<JsonableVoid>) in
                
                callback(HttpClient.isReponseOK(code: response.ResponseCode))
                
        }
        
    }
    
    public func update<T:Jsonable>(object:T, callback: @escaping(_ response:T?)->Void){
        
        let client = HttpApiClient()
        
        client.put.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
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
        let client = HttpApiClient()
        
        client.delete.url(self.endpoint).accept(HttpHeaderCollection.JsonContentType)
            .urlData(params).request{ (response:HttpResponse<JsonableVoid>) in
                
                callback(HttpClient.isReponseOK(code: response.ResponseCode))
        }
        
    }
    
    
}
