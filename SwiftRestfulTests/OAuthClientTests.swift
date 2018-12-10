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
                                 clientId: "TestClient" ,
              clientSecret:"secret")
        
        client.login(url: "https://apifest-live.herokuapp.com/oauth20/tokens", username: "mani", password: "mani") { (result:HttpResponse<LoginResult>) in
            
            XCTAssert(HttpClient.isReponseOK(code: result.ResponseCode))
            
            XCTAssertNotNil(result.Value)
            
            XCTAssertNotNil(result.Value.accessToken)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testRefreshShouldGetNewToken(){
        
        let expectations = XCTestExpectation(description: "OAUTH - TEST")
        
        let client = OAuthClient(baseUrl: "",
                                 clientId: "TestClient" ,
                                 clientSecret:"secret")
        
        client.refresh(url: "https://apifest-live.herokuapp.com/oauth20/tokens", refreshToken: "mani") { (result:HttpResponse<LoginResult>) in
            
            XCTAssert(HttpClient.isReponseOK(code: result.ResponseCode))
            
            XCTAssertNotNil(result.Value)
            
            XCTAssertNotNil(result.Value.accessToken)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
}
