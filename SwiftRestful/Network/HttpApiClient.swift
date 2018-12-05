//
//  HttpBlient.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation


public class HttpApiClient{
    
    
    public let get:RequestBuilderBase
    
    public let post:RequestBuilderBase
    
    public let put:RequestBuilderBase
    
    public let delete:RequestBuilderBase
    
    public let patch:RequestBuilderBase
    
    private let client:HttpClient
    
    public required init(){
        
        self.client = HttpClient()
        
        self.get = GETRequestBuilder(client: self.client)
        
        self.post = POSTRequestBuilder(client: self.client)
        
        self.put = PUTRequestBuilder(client: self.client)
        
        self.delete = DELETERequestBuilder(client: self.client)
        
        self.patch = PATCHRequestBuilder(client: self.client)
        
    }
    
    
}
