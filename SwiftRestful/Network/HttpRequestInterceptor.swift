//
//  RequestInterceptor.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/23/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation
public protocol HttpRequestInterceptor{
    
    
    func onRequest(requestParams:HttpRequestParameters)->HttpRequestParameters
}
