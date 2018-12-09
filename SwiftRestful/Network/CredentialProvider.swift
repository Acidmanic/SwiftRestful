//
//  CredentialProvider.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/9/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation


public protocol CredentialProvidr{
    
    func onCredentialsAsked()->Credentials
}
