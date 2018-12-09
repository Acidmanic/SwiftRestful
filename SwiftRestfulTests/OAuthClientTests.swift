//
//  OAuthClientTests.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/9/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftRestful

class OAuthClientTests:XCTestCase{
    
    func testLoginShouldGetToken(){
        
        let expectations = XCTestExpectation(description: "OAUTH - TEST")
        
        let client = OAuthClient(baseUrl: "",
                                 clientId: "da7110582d53b778d3a75578633d5db93e4fa0d4" ,
              clientSecret:"aada1c8185f45fd4b004007920f6afbba96f331dbb8d976f38a32e55b8aad0f4")
        
        client.login(url: "http://192.168.56.1:8080/oauth20/tokens", username: "mani", password: "mani") { (result:HttpResponse<LoginResult>) in
            
            XCTAssert(HttpClient.isReponseOK(code: result.ResponseCode))
            
            XCTAssertNotNil(result.Value)
            
            XCTAssertNotNil(result.Value.accessToken)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
}
