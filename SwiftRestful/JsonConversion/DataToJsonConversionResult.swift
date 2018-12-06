//
//  DataToJsonConversionResult.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/6/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

public class DataToJsonConversionResult<T:Jsonable>{
    public var succeed:Bool=false
    public var isArray:Bool=false
    public var value:T!=nil
    public var array:[T]!=[]
    
    public init() {        }
}
