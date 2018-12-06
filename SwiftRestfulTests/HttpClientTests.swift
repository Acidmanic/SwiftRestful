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
    
  
    
    
    func testShouldPostValues(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "Should POST values in json data.")
        
        let data = "{\"userId\":\"12\",\"title\":\"JsonPost\"}".data(using: String.Encoding.utf8)
        
        client.download(url: "http://jsonplaceholder.typicode.com/todos", method:HttpMethod.POST,
                        headers: [HttpHeaderCollection.ContentType:HttpHeaderCollection.JsonContentType],
                        contentData:data)
        { (result:HttpResponse<Data>) in
            XCTAssertEqual(result.ResponseCode, 201)
            XCTAssertNotNil(result.Value)
            let sResult = String(data:result.Value,encoding:.utf8)
            XCTAssertNotNil(sResult)
            XCTAssertTrue((sResult?.contains("JsonPost"))!)
            XCTAssertTrue((sResult?.contains("userId"))!)
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testShouldCallADELETEEndpointCorrectly(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "Should call a DELETE request correctly")
        
        client.download(url: "http://jsonplaceholder.typicode.com/todos/12", method:HttpMethod.DELETE,
                        headers: [:],
                        contentData:nil)
        { (result:HttpResponse<Data>) in
            XCTAssertEqual(result.ResponseCode, 200)
            XCTAssertNotNil(result.Value)
            let sResult = String(data:result.Value,encoding:.utf8)
            XCTAssertNotNil(sResult)
            XCTAssertTrue(sResult=="{}")
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testShouldCallAPUTEndpointCorrectly(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "Should call a PUT request correctly")
        
        client.download(url: "http://jsonplaceholder.typicode.com/todos/12", method:HttpMethod.PUT,
                        headers: [:],
                        contentData:nil)
        { (result:HttpResponse<Data>) in
            XCTAssertEqual(result.ResponseCode, 200)
            XCTAssertNotNil(result.Value)
            let sResult = String(data:result.Value,encoding:.utf8)
            XCTAssertNotNil(sResult)
            if sResult?.range(of: "\\{\\s*\\\"id\\\"\\s*:\\s*12\\s*\\}",
                              options: .regularExpression) != nil {
                XCTAssertTrue(true)
            } else {
                XCTAssertTrue(false)
            }
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
}
