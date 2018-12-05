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
    
    func testGetTodoObjectUrlResource(){
        
        let expectations = XCTestExpectation(description: "GET")
        
        let client = HttpBlient()
        
        client.get.url("http://jsonplaceholder.typicode.com/todos/12")
            .request(){(result:HttpResult<Todo>) in
            
            XCTAssertEqual(200, result.ResponseCode)
            
            XCTAssertNotNil(result.Value)
            
            XCTAssertEqual(12, result.Value.id)
                
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testGetTodoObjectUrlParams(){
        
        let expectations = XCTestExpectation(description: "GET")
        
        let client = HttpBlient()
        
        client.get.url("http://jsonplaceholder.typicode.com/todos")
            .urlData(["id":"12"])
            .request(){(result:HttpResult<Todo>) in
                
                XCTAssertEqual(200, result.ResponseCode)
                
                XCTAssertNotNil(result.ArrayValue)
                
                XCTAssertEqual(12, result.ArrayValue[0].id)
                
                expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testGetTodoList(){
        
        let expectations = XCTestExpectation(description: "GET")
        
        let client = HttpBlient()
        
        client.get.url("http://jsonplaceholder.typicode.com/todos")
            .request(){(result:HttpResult<Todo>) in
                
                XCTAssertEqual(200, result.ResponseCode)
                
                XCTAssertTrue(result.resultIsArray)
                
                XCTAssertNotEqual(0, result.ArrayValue.count)
                
                expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testPostATodoObject(){
        
        let expectations = XCTestExpectation(description: "POST")
        
        let client = HttpBlient()
        
        client.post.url("http://jsonplaceholder.typicode.com/todos")
            .jsonData(Todo(title: "NewTodo", body: "TestObject", userId: 123))
            .request(){(result:HttpResult<Todo>) in
                
                XCTAssertEqual(201, result.ResponseCode)
                
                XCTAssertNotNil(result.Value)
                
                XCTAssertEqual(123, result.Value.userId)
                
                XCTAssertEqual("TestObject", result.Value.body)
                
                XCTAssertEqual("NewTodo", result.Value.title)
                
                expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testPostByUrl(){
        
        let expectations = XCTestExpectation(description: "POST")
        
        let client = HttpBlient()
        
        client.post.url("http://httpbin.org/anything")
            .urlData(["title":"NewTodo","body":"TestObject","userId":"123"])
            .request(){(result:HttpResult<HttpbinTodo>) in
                
                XCTAssertEqual(200, result.ResponseCode)
                
                XCTAssertNotNil(result.Value)
                
                XCTAssertEqual("TestObject", result.Value.args.body)
                
                XCTAssertEqual("NewTodo", result.Value.args.title)
                
                XCTAssertEqual("POST",result.Value.method)
                
                expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testPostRawData(){
        
        let expectations = XCTestExpectation(description: "POST")
        
        let client = HttpBlient()
        
        client.post.url("http://httpbin.org/anything")
            .rawData("ThisIsARawStringToServer").request()
                {(result:HttpResult<HttpBinAnything>) in
                
                XCTAssertEqual(200, result.ResponseCode)
                
                XCTAssertNotNil(result.Value)
            
                XCTAssertEqual("ThisIsARawStringToServer", result.Value.data)
                
                XCTAssertEqual("POST",result.Value.method)
                
                expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testPostFormData(){
        
        let expectations = XCTestExpectation(description: "POST")
        
        let client = HttpBlient()
        
        client.post.url("http://jsonplaceholder.typicode.com/todos")
            .xwwwFormData(["title":"NewTodo","body":"dodo","userId":"123"])
                .request(){(result:HttpResult<Todo>) in
                    
                    XCTAssertEqual(201, result.ResponseCode)
                    
                    XCTAssertNotNil(result.Value)
                    
                    XCTAssertEqual("NewTodo", result.Value.title)
                    
                    XCTAssertEqual("dodo", result.Value.body)
                    
                    XCTAssertEqual(123, result.Value.userId)
                    
                    expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testPutSendTodoGetString(){
        let expectations = XCTestExpectation(description: "PUT")
        
        let client = HttpBlient()
        
        client.put.url("http://httpbin.org/anything")
            .jsonData(Todo(title: "NewTodo", body: "TestObject", userId: 123))
            .request(){(result:HttpResult<String>) in
                
                XCTAssertEqual(200, result.ResponseCode)
                
                XCTAssertNotNil(result.Value)
                
                print(result.Value)
                
                expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testPutSendTodoGetObject(){
        let expectations = XCTestExpectation(description: "PUT")
        
        let client = HttpBlient()
        
        client.put.url("http://httpbin.org/anything")
            .jsonData(Todo(title: "NewTodo", body: "TestObject", userId: 123))
            .request(){(result:HttpResult<HttpbinTodo>) in
                
                XCTAssertEqual(200, result.ResponseCode)
                
                XCTAssertNotNil(result.Value)
                
                XCTAssertNotNil(result.Value.data)
                
                XCTAssertTrue(result.Value.data.contains("NewTodo"))
                
                XCTAssertTrue(result.Value.data.contains("TestObject"))
                
                XCTAssertTrue(result.Value.data.contains("123"))
                
                expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
}
