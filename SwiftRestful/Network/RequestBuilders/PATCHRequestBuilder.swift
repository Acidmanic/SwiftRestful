//
//  PATCHRequestBuilder.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

class PATCHRequestBuilder:RequestBuilderBase{
    
    override init(client: HttpClient) {
        super.init(client: client)
        self.method = HttpMethod.PATCH
    }
}
