//
//  OAuthClinet.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/6/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation

public class OAuthParameterNames{
    public static let ClientId="client_id"
    public static let GrantType="grant_type"
    public static let GrantTypePassword="password"
    public static let GrantTypeRefreshToken="refresh_token"
    public static let Username="username"
    public static let Password="password"
    public static let RefreshToken="refresh_token"
}

class OAuthClient{
    
    
    enum TokenTypes:String{
        case Bearer
    }
    
    
    private var baseUrl:String
    private var clientId:String
    
    private let defaultLoginUrl="/oauth/token"
    
    public var skipInterception:Bool=true
    
    init(baseUrl:String,clientId:String){
        self.baseUrl=baseUrl
        self.clientId=clientId
    }
    
    func login(url:String, username:String,password:String,callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        let params=[OAuthParameterNames.ClientId:self.clientId,
                    OAuthParameterNames.GrantType:OAuthParameterNames.GrantTypePassword,
                    OAuthParameterNames.Username:username,
                    OAuthParameterNames.Password:password]
        let client = HttpApiClient()
        
        client.skipInterception=skipInterception
        
        client.post.url(url).xwwwFormData(params).request(callback: callback)
    }
    
    func login(username:String,password:String,callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        login(url:baseUrl+defaultLoginUrl,
              username:username,password:password,callback:callback)
    }
    
    
    func refresh(url:String,refreshToken:String,
                 callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        let params=[OAuthParameterNames.ClientId:self.clientId,
                    OAuthParameterNames.GrantType:
                        OAuthParameterNames.GrantTypeRefreshToken,
                    OAuthParameterNames.RefreshToken:refreshToken]
        let client = HttpApiClient()
        
        client.skipInterception=skipInterception
        
        client.post.url(url).xwwwFormData(params).request(callback: callback)
    }
    
    func refresh(refreshToken:String,
                 callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        refresh(url:baseUrl+defaultLoginUrl,
                refreshToken:refreshToken,callback:callback)
    }
    
}
