//
//  HttpClient.swift
//  Movies
//
//  Created by Mani Moayedi on 12/4/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation


public class HttpClient{
    
    private var instanceInterceptors:[HttpRequestInterceptor]=[]
    private static var globalInterceptors:[HttpRequestInterceptor]=[]
    
    
    public func download(url:String,method:HttpMethod,headers:[String:String],
                  contentData:Data!,callback:@escaping (_ result:HttpResponse<Data>)->Void){
        var params = HttpRequestParameters(url: url,
                                           method: method,
                                           headers: headers,
                                           contentData: contentData)
        params = self.interceptRequest(request: params)
        performDownload(requestParams: params, callback: callback)
    }
    
    private func translateRequest(requestParams:HttpRequestParameters)->URLRequest!{
        guard let url=URL(string:requestParams.url) else{
            return nil;
        }
        var request=URLRequest(url: url)
        for (key,value) in requestParams.headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        request.httpMethod=requestParams.method.rawValue
        if requestParams.contentData != nil {
            request.httpBody=requestParams.contentData!
        }
        request.timeoutInterval=10
        return request
    }
    
    internal func badRequest(callback:@escaping (_ result:HttpResponse<Data>)->Void){
        let result = HttpResponse<Data>()
        result.RequestResult=HttpReponseStatus.InvalidUrl
        callback(result)
    }
    
    private func performDownload(requestParams:HttpRequestParameters,
                                 callback:@escaping (_ result:HttpResponse<Data>)->Void){
        let request = translateRequest(requestParams: requestParams)
        if request == nil {
            badRequest(callback:callback)
            return
        }
        let task = URLSession.shared.dataTask(with: request!, completionHandler: { (data,response,error) in
            let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            let res = (response as? HTTPURLResponse)
            
            let result = HttpResponse<Data>()
            
            for (key,value) in (res?.allHeaderFields)! {
                if let sKey = key as? String {
                    if let sValue = value as? String{
                        result.ResponseHeaders[sKey]=sValue
                        if sKey == "Content-Charset" {
                            result.ResponseCharset = sValue
                        }else if sKey == "Content-Type" && sValue.contains("charset"){
                            let parts = sValue.split(separator: ";")
                            for part in parts {
                                let nameValue = part.replacingOccurrences(of: " ", with: "")
                                    .split(separator: "=")
                                if String(nameValue[0])=="charset" {
                                    result.ResponseCharset=String(nameValue[1])
                                }
                            }
                        }
                    }
                }
            }
 
            if self.isReponseOK(code: responseCode) == false {
        
                result.RequestResult=HttpReponseStatus.Error
                result.ResponseError=error
                result.ResponseCode=responseCode
      
                callback(result)
            }else{
                result.ResponseCode=responseCode
                self.unwarpData(data:data,ret:result)
                callback(result)
            }
        })
        task.resume()
    }
    private func isReponseOK(code:Int)->Bool{
        return (code/100) == 2
    }
    
    private func unwarpData(data:Data!,ret:HttpResponse<Data>){
        if let safeData = data {
            ret.Value=safeData
            ret.RequestResult=HttpReponseStatus.Succeed
        }else{
            ret.RequestResult=HttpReponseStatus.EmptyData
        }
    }

    private func interceptRequest(request:HttpRequestParameters)->HttpRequestParameters{
        var params  = request
        for interceptor in HttpClient.globalInterceptors{
            params = interceptor.onRequest(requestParams: params)
        }
        for interceptor in self.instanceInterceptors{
            params = interceptor.onRequest(requestParams: params)
        }
        return params
    }
    
    public func pushInstanceInterceptor(interceptor:HttpRequestInterceptor){
        self.instanceInterceptors.append(interceptor)
    }
    public func pushGlobalInterceptor(interceptor:HttpRequestInterceptor){
        HttpClient.globalInterceptors.append(interceptor)
    }
}













