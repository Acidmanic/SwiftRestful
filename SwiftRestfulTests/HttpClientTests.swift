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
        
        client.download(url: "http://jsonplaceholder.typicode.com/todos",
                        method: HttpMethod.GET) { (result:HttpResult<Data>) in
                            XCTAssert(result.ResponseCode==200)
                            expectation.fulfill()
                        }
        wait(for: [expectation], timeout: 5)
    }
    
    func testShoudPostKeyValuedDataToServer(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "POST method should create a resource")
        
        client.downloadPOST(url: "http://jsonplaceholder.typicode.com/todos",
                        urlParams: ["userId":"1"], accept: HttpHeaderCollection.JsonContentType)
            { (result:HttpResult<Data>) in
                XCTAssertEqual(result.ResponseCode, 201)
                XCTAssertNotNil(result.Value)
                expectations.fulfill()
            }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testShouldPostFormDataFormatToServer(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "POST method should create a resource")
        
        client.downloadPOST(url: "http://jsonplaceholder.typicode.com/todos",
                            urlPostString: "userId=12", accept: HttpHeaderCollection.JsonContentType)
        { (result:HttpResult<Data>) in
            XCTAssertEqual(result.ResponseCode, 201)
            XCTAssertNotNil(result.Value)
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testShouldBeAbleToSendHeadersToServer(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "Should be able to send headers to server")
        
        client.download(url: "http://headers.jsontest.com", method:HttpMethod.GET,
                            headers: ["test-header":"test-header-value"])
        { (result:HttpResult<Data>) in
            XCTAssertEqual(result.ResponseCode, 200)
            XCTAssertNotNil(result.Value)
            let sResult = String(data:result.Value,encoding:.utf8)
            XCTAssertNotNil(sResult)
            XCTAssertTrue((sResult?.contains("test-header"))!)
            XCTAssertTrue((sResult?.contains("test-header-value"))!)
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testShouldPostValues(){
        let client = HttpClient()
        
        let expectations = XCTestExpectation(description: "Should POST values in json data.")
        
        let data = "{\"userId\":\"12\",\"title\":\"JsonPost\"}".data(using: String.Encoding.utf8)
        
        client.download(url: "http://jsonplaceholder.typicode.com/todos", method:HttpMethod.POST,
                        headers: [HttpHeaderCollection.ContentType:HttpHeaderCollection.JsonContentType],
                        contentData:data)
        { (result:HttpResult<Data>) in
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
        { (result:HttpResult<Data>) in
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
        { (result:HttpResult<Data>) in
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
