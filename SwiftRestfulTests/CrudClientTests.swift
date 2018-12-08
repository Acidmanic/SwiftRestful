//
//  CrudClientTests.swift
//  SwiftRestfulTests iOS
//
//  Created by Mani Moayedi on 12/8/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation
import XCTest
@testable import SwiftRestful

class CrudClientTests:XCTestCase{
    
    
    
    
    func testShouldGetATodoValueForAnyId(){
        
        let client = CrudClient(endpoint: "http://jsonplaceholder.typicode.com/todos")
        
        let expectations = XCTestExpectation(description: "CRUD - READ")
        
        client.read(params: ["id":"12"]) { (result:Todo!) in
            
            XCTAssertNotNil(result)
            
            XCTAssertEqual(result.id, 12)
            
            XCTAssertNotNil(result.title)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 4)
        
    }
    
    func testReadShouldListAllTodoObjects(){
        
        let client = CrudClient(endpoint: "http://jsonplaceholder.typicode.com/todos")
        
        let expectations = XCTestExpectation(description: "CRUD - READ - ALL")
        
        client.read() { (result:[Todo]) in
            
            XCTAssertNotNil(result)
            
            XCTAssertNotEqual(result.count, 0)
            
            XCTAssertNotNil(result[0].title)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 4)
        
    }
    
    
    func testShouldCreateAValidObjectInServer(){
        
        let client = CrudClient(endpoint: "http://jsonplaceholder.typicode.com/todos")
        
        let expectations = XCTestExpectation(description: "CRUD - Create")
        
        let createdTodo = Todo(title: "NetworkTest", body: "PerformNetworkTest", userId: 123)
        
        client.create(object: createdTodo){(todo:Todo) in
            
            XCTAssertNotNil(todo)
            
            XCTAssertEqual(createdTodo.body, todo.body)
            
            XCTAssertEqual(createdTodo.title, todo.title)
            
            XCTAssertEqual(createdTodo.userId, todo.userId)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testShouldUpdateObjectOnServer(){
        
        let client = CrudClient(endpoint: "http://reqres.in/api/users")
        
        let expectations = XCTestExpectation(description: "CRUD - UPDATE")
        
        let updateObject = ReqresUser(name:"Mani",job:"developer")
        
        client.update(object: updateObject){(succcess:Bool) in
            
            XCTAssertTrue(succcess)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    func testShouldUpdateObjectOnServerReceiveUpdatedObject(){
        
        let client = CrudClient(endpoint: "http://reqres.in/api/users")
        
        let expectations = XCTestExpectation(description: "CRUD - UPDATE")
        
        let updateObject = ReqresUser(name:"Mani",job:"developer")
        
        client.update(object: updateObject){(response:ReqresUser?) in
            
            XCTAssertNotNil(response)
            
            XCTAssertEqual(response?.name, updateObject.name)
            
            XCTAssertEqual(response?.job, updateObject.job)
            
            XCTAssertNotNil(response?.updatedAt)
            
            print("Updated: " + (response?.updatedAt!)!)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
    }
    
    
    func testShouldSuccessDeletingAToDoObject(){
        
        let client = CrudClient(endpoint: "http://reqres.in/api/users")
        
        let expectations = XCTestExpectation(description: "CRUD - DELETE")
        
        client.delete(params: ["id":"12"]){(succeed:Bool) in
            
            XCTAssertTrue(succeed)
            
            expectations.fulfill()
        }
        
        wait(for: [expectations], timeout: 5)
        
    }
    
    
}
