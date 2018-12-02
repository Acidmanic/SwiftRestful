//
//  LoginResult.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/8/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation


class LoginResult:Jsonable{
    var accessToken:String!
    var tokenType:String!
    var expiresIn:Int32!
    var refreshToken:String!
    required init(){}
    func load(jsonData: JsonMediumType!) {
        if let data = jsonData{
            if let at = data["access_token"] as? String{
                self.accessToken = at.trimmingCharacters(in: NSCharacterSet.whitespaces)
            }
            if let tt = data["token_type"] as? String{
                self.tokenType=tt.trimmingCharacters(in: NSCharacterSet.whitespaces)
            }
            if let ei = data["expires_in"] as? Int32{
                self.expiresIn=ei
            }
            if let rt = data["refresh_token"] as? String{
                self.refreshToken=rt.trimmingCharacters(in: NSCharacterSet.whitespaces)
            }
        }
    }
}
