//
//  OAuthLoginInterceptopr.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/9/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation


private enum OAuthStates{
    case NotLoggedIng
    case Transitioning
    case LoggedIn
}

public class OAuthLoginInterceptor:HttpRequestInterceptor{
    
    private var credentialProvider:CredentialProvidr!
    
    private var state:OAuthStates=OAuthStates.NotLoggedIng
    
    private var token:String!
    
    private var endpointUrl:String
    
    private var clientId:String
    
    init(endpointUrl:String,clientId:String) {
        
        self.endpointUrl = endpointUrl
        
        self.clientId = clientId
    }
    
    public func onRequest(requestParams: HttpRequestParameters) -> HttpRequestParameters {
        
        if self.state == OAuthStates.LoggedIn {
            
            requestParams.headers[HttpHeaderCollection.Authorization] =
                HttpHeaderCollection.AuthorizationBearerPrefix + self.token
            
        }else{
            
            self.performLogin()
        }
        
        return requestParams
    }
    
    
    private func performLogin(){
        
        if self.state == OAuthStates.NotLoggedIng {
            
            if let credentials = self.getCredentials() {
            
                self.state = OAuthStates.Transitioning
            
                let client = OAuthClient(baseUrl: "", clientId: self.clientId)
            
                client.login(url:self.endpointUrl
                    , username: credentials.username, password: credentials.password)
                { (response: HttpResponse<LoginResult>) in
                    
                    if HttpClient.isReponseOK(code: response.ResponseCode) &&
                        response.Value != nil{
                        
                        self.token = response.Value.accessToken
                        
                        self.state = OAuthStates.LoggedIn
                    }else{
                        self.state = OAuthStates.NotLoggedIng
                    }
                }
            }
        }
    }
    
    private func getCredentials()->Credentials! {
        if self.credentialProvider != nil {
        
            return self.credentialProvider.onCredentialsAsked()
        }
        
        return nil
    }
    
    
    
}
