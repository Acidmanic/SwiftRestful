//
//  SwiftNetworkTests.swift
//  SwiftNetworkTests
//
//  Created by Mani Moayedi on 10/30/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//
import Foundation
import XCTest
@testable import SwiftRestful

class HttpClientTests: XCTestCase {
    
    func testGetShouldGetGooglePageOK(){
        let client = HttpClient()
        
        let expectation = XCTestExpectation(description: "Downloading www.google.com")
        
        client.download(url: "http://www.google.com",
                        method: HttpMethod.GET) { (result:HttpResult<Data>) in
                            XCTAssert(result.ResponseCode==200)
                            expectation.fulfill()
                        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testShoudGetAJsonWithIdEqualsToOne(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "Test URL Params GET")
        
        client.download(url: "http://jsonplaceholder.typicode.com/todos",
                        urlParams: ["id":"1"], accept: HttpHeaderCollection.JsonContentType)
            { (result:HttpResult<Data>) in
                XCTAssertEqual(result.ResponseCode, 200)
                XCTAssertNotNil(result.Value)
                print(result.Value)
                expectations.fulfill()
            }
        
        wait(for: [expectations], timeout: 5)
    }
    
}
