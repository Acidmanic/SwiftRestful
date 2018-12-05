//
//  HttpApiClientTests.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/4/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftRestful

class HttpApiClientTests: XCTestCase {
    
    
    func testShouldGetATodoObjectWithId12() {
        
        let client = HttpApiClient()
        
        let expectation = XCTestExpectation(description: "test GET, receive Object")
        
        client.getJson(url: "http://jsonplaceholder.typicode.com/todos/12",
                       params: [:]) { (result:HttpResult<Todo>) in
                XCTAssert(result.ResponseCode==200)
                XCTAssertNotNil(result.Value)
                XCTAssertNotNil(result.Value.id)
                XCTAssertEqual(12, result.Value.id)
                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    
    func testPOSTSendObjectReceiveObject() {
        
        let client = HttpApiClient()
        
        let expectation = XCTestExpectation(description: "test POST, Send Object, receive Object")
        
        let todo = Todo(title:"Testitem",body:"TestItemBody",userId:123)
        
        client.post(url: "http://jsonplaceholder.typicode.com/todos",
                    json: todo) { (result:HttpResult<Todo>) in
                        XCTAssert(result.ResponseCode==201)
                        XCTAssertNotNil(result.Value)
                        XCTAssertNotNil(result.Value.id)
                        XCTAssertEqual("Testitem", result.Value.title)
                        XCTAssertEqual("TestItemBody", result.Value.body)
                        XCTAssertEqual(123, result.Value.userId)
                        expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    
    func testPOSTUrlEncodeReceiveJson() {
        
        let client = HttpApiClient()
        
        let expectation = XCTestExpectation(description: "test POST, Send UrlEncode, receive Object")
        
        client.postReceiveJson(url: "http://jsonplaceholder.typicode.com/todos",
                    urlParams: ["title":"Testitem","body":"TestItemBody","userId":"123"]) { (result:HttpResult<Todo>) in
                        XCTAssert(result.ResponseCode==201)
                        XCTAssertNotNil(result.Value)
                        XCTAssertNotNil(result.Value.id)
                        XCTAssertEqual("Testitem", result.Value.title)
                        XCTAssertEqual("TestItemBody", result.Value.body)
                        expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testPOSTInUrlParamsReceiveJson() {
        
        let client = HttpApiClient()
        
        let expectation = XCTestExpectation(description: "test POST, Send In Url, receive Object")
        
        client.postInUrlReceiveJson(url: "http://jsonplaceholder.typicode.com/todos",
                               urlParams: ["title":"Testitem","body":"TestItemBody","userId":"123"]) { (result:HttpResult<Todo>) in
                                XCTAssert(result.ResponseCode==201)
                                XCTAssertNotNil(result.Value)
                                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    
    
    //88888
    
    
    func testPUTSendObjectReceiveObject() {
        
        let client = HttpApiClient()
        
        let expectation = XCTestExpectation(description: "test PUT, Send Object, receive Object")
        
        let todo = Todo(title:"Testitem",body:"TestItemBody",userId:123)
        
        client.put(url: "http://jsonplaceholder.typicode.com/todos",
                    json: todo) { (result:HttpResult<Todo>) in
                        XCTAssert(result.ResponseCode==201)
                        XCTAssertNotNil(result.Value)
                        XCTAssertNotNil(result.Value.id)
                        XCTAssertEqual("Testitem", result.Value.title)
                        XCTAssertEqual("TestItemBody", result.Value.body)
                        XCTAssertEqual(123, result.Value.userId)
                        expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    
    func testPUTUrlEncodeReceiveJson() {
        
        let client = HttpApiClient()
        
        let expectation = XCTestExpectation(description: "test PUT, Send UrlEncode, receive Object")
        
        client.putReceiveJson(url: "http://jsonplaceholder.typicode.com/todos",
                               urlParams: ["title":"Testitem","body":"TestItemBody","userId":"123"]) { (result:HttpResult<Todo>) in
                                XCTAssert(result.ResponseCode==201)
                                XCTAssertNotNil(result.Value)
                                XCTAssertNotNil(result.Value.id)
                                XCTAssertEqual("Testitem", result.Value.title)
                                XCTAssertEqual("TestItemBody", result.Value.body)
                                expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
    
    func testPUTInUrlParamsReceiveJson() {
        
        let client = HttpApiClient()
        
        let expectation = XCTestExpectation(description: "test PUT, Send In Url, receive Object")
        
        client.putInUrlReceiveJson(url: "http://jsonplaceholder.typicode.com/todos",
                                    urlParams: ["title":"Testitem","body":"TestItemBody","userId":"123"]) { (result:HttpResult<Todo>) in
                                        XCTAssert(result.ResponseCode==201)
                                        XCTAssertNotNil(result.Value)
                                        expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
        
    }
    
}
