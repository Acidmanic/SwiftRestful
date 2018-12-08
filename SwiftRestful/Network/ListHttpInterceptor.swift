//
//  ListHttpInterceptor.swift
//  SwiftRestfulTests iOS
//
//  Created by Mani Moayedi on 12/8/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

class ListHttpInterceptor{
    
    
    public func intercept(interceptors: [HttpRequestInterceptor] ,params:HttpRequestParameters)
        ->HttpRequestParameters{
        
            var innerParams = params
            
            for interceptor in interceptors{
                
                innerParams = interceptor.onRequest(requestParams: innerParams)
            }
            
            return innerParams
    }
}
