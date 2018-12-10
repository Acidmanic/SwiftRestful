//
//  AutoLoginCrudClient.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/10/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftRestful

class AutoLoginCrudClient:XCTestCase{
    
    
    static var stepsList:[String]=[]
    
    private class FixedCredentialProvider:CredentialProvidr{
        
        var credentialsAsked:Bool=false
        
        
        
        func onCredentialsAsked() -> Credentials {
            self.credentialsAsked=true
            
            AutoLoginCrudClient.stepsList.append("credentials")
            
            return Credentials(username: "1_10001", password: "Vh-10001-1")
        }
    }
    
    
    private class Interceptor:OAuthLoginInterceptor{
        
        override init(endpointUrl: String, clientId: String,credentialProvider:CredentialProvidr) {
            super.init(endpointUrl: endpointUrl, clientId: clientId,
                       credentialProvider: credentialProvider)
        }
        
        override func onRequest(requestParams: HttpRequestParameters) -> HttpRequestParameters {
            AutoLoginCrudClient.stepsList.append("interception")
            
            return super.onRequest(requestParams: requestParams)
        }
    }
    
    func testShouldLoginAutomaticallyBeforeReachingForResource(){
        
        let provider = FixedCredentialProvider()
    
        let expectations = XCTestExpectation(description: "AUTO - LOGIN")
        
        let client = CrudClient(endpoint: "http://api.dynaexpress.com/api/VehicleDriver")
        
        let interceptor = OAuthLoginInterceptor(endpointUrl: "http://api.dynaexpress.com/oauth/token",
                                                clientId: "IcpDriverMob",
                                                credentialProvider:provider)
        
        client.pushInstanceInterceptor(interceptor: interceptor)
        
        var received = false
        
        while !received {
        
            let responseWait = XCTestExpectation(description: "AUTO - LOGIN - RESPONSE")
            
            
            print("Loop Call")
            
            client.read(params:["username":"1_10001"]){(response:JsonableVoid?) in
                
                print("Response")
                
                received = response != nil
                if received {
                    expectations.fulfill()
                }
                responseWait.fulfill()
                
            }
            
            wait(for: [responseWait], timeout: 5)
        }
        
        
        wait(for: [expectations], timeout: 30)
    }
    
}
