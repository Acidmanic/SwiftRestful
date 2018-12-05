//
//  HttpClinetBeTest.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftRestful

class HttpClientBeTest:XCTestCase{
    
    
    func testBareGetShouldDownloadGoogleHomePage(){
        
        let expectations = XCTestExpectation(description: "BARE GET")
        
        let client = HttpBlient()
        
        client.get.url("http://www.google.com").request(){(result:HttpResult<String>) in
            
            XCTAssertEqual(200, result.ResponseCode)
            
            XCTAssertNotNil(result.Value)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
}
