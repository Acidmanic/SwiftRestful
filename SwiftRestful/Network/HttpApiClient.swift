//
//  HttpBlient.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation


public class HttpApiClient{
    
    private static var globalInterceptors:[HttpRequestInterceptor]=[]
    
    public let get:RequestBuilderBase
    
    public let post:RequestBuilderBase
    
    public let put:RequestBuilderBase
    
    public let delete:RequestBuilderBase
    
    public let patch:RequestBuilderBase
    
    private let client:HttpClient
    
    var skipInterception:Bool{
        get{
            return self.client.skipInterceptions
        }
        set{
            self.client.skipInterceptions = newValue
        }
    }
    
    public required init(){
        
        self.client = HttpClient()
        
        self.client.pushInstanceInterceptor(interceptor: InterceptionProxy())
        
        self.get = GETRequestBuilder(client: self.client)
        
        self.post = POSTRequestBuilder(client: self.client)
        
        self.put = PUTRequestBuilder(client: self.client)
        
        self.delete = DELETERequestBuilder(client: self.client)
        
        self.patch = PATCHRequestBuilder(client: self.client)
        
    }
    
    public static func pushGlobalInterceptor(interceptor:HttpRequestInterceptor){
        
        HttpApiClient.globalInterceptors.append(interceptor)
    }
    
    public func pushInstanceInterceptor(interceptor:HttpRequestInterceptor){
        
        self.client.pushInstanceInterceptor(interceptor: interceptor)
    }
    
    
    
    private class InterceptionProxy:HttpRequestInterceptor{
        
        func onRequest(requestParams: HttpRequestParameters) -> HttpRequestParameters {
            
            return ListHttpInterceptor()
                .intercept(interceptors: HttpApiClient.globalInterceptors
                    ,params: requestParams)
            
        }
    }
    
    
}
