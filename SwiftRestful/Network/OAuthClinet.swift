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
    public static let ClientSecret="client_secret"
    public static let GrantType="grant_type"
    public static let GrantTypePassword="password"
    public static let GrantTypeRefreshToken="refresh_token"
    public static let Username="username"
    public static let Password="password"
    public static let RefreshToken="refresh_token"
    public static let AccessToken="access_token"
}

public class OAuthClient{
    
    
    public enum TokenTypes:String{
        case Bearer
    }
    
    
    private var baseUrl:String
    private var clientId:String
    private var clientSecret:String!
    private let defaultLoginUrl="/oauth/token"
    
    public var skipInterception:Bool=true
    
    init(baseUrl:String,clientId:String){
        self.baseUrl=baseUrl
        self.clientId=clientId
    }
    
    init(baseUrl:String,clientId:String,clientSecret:String){
        self.baseUrl=baseUrl
        self.clientId=clientId
        self.clientSecret=clientSecret
    }
    
    public func login(url:String, username:String,password:String,callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        var params=[OAuthParameterNames.ClientId:self.clientId,
                    OAuthParameterNames.GrantType:OAuthParameterNames.GrantTypePassword,
                    OAuthParameterNames.Username:username,
                    OAuthParameterNames.Password:password]
        if self.clientSecret != nil {
            params[OAuthParameterNames.ClientSecret] = self.clientSecret
        }
        let client = HttpApiClient()
        
        client.skipInterception=skipInterception
        
        client.post.url(url).xwwwFormData(params).request(callback: callback)
    }
    
    public func login(username:String,password:String,callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        //TODO: use a proper resolve function to concatinate url fragments
        login(url:baseUrl+defaultLoginUrl,
              username:username,password:password,callback:callback)
    }
    
    
    public func refresh(url:String,refreshToken:String,
                 callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        var params=[OAuthParameterNames.ClientId:self.clientId,
                    OAuthParameterNames.GrantType:
                        OAuthParameterNames.GrantTypeRefreshToken,
                    OAuthParameterNames.RefreshToken:refreshToken]
        
        if self.clientSecret != nil {
            params[OAuthParameterNames.ClientSecret] = self.clientSecret
        }
        
        let client = HttpApiClient()
        
        client.skipInterception=skipInterception
        
        client.post.url(url).xwwwFormData(params).request(callback: callback)
    }
    
    public func refresh(refreshToken:String,
                 callback:@escaping(_ result:HttpResponse<LoginResult>)->Void){
        refresh(url:baseUrl+defaultLoginUrl,
                refreshToken:refreshToken,callback:callback)
    }
    
    public func revokeXwwwform(url:String,accessToken:String,
                        callback:@escaping(_ result:Bool)->Void){
        
        let params=[OAuthParameterNames.ClientId:self.clientId,
                    OAuthParameterNames.AccessToken:accessToken]
        
        let client = HttpApiClient()
        
        client.skipInterception=skipInterception
        
        client.post.url(url).xwwwFormData(params).request(){(response:HttpResponse<LoginResult>) in
            
                callback(HttpClient.isReponseOK(code: response.ResponseCode))
            
        }
    }
    
    public func revoke(url:String,accessToken:String,
                       callback:@escaping(_ result:Bool)->Void){
        
        let data = RevokeData(accessToken: accessToken, clientId: self.clientId)
        
        let client = HttpApiClient()
        
        client.skipInterception=skipInterception
        
        client.post.url(url).jsonData(data).request(){(response:HttpResponse<LoginResult>) in
            
            callback(HttpClient.isReponseOK(code: response.ResponseCode))
            
        }
    }
    
}
