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
    
    var skipInterceptions:Bool=false
    
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
        result.RequestResult=HttpResponseStatus.InvalidUrl
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
            
            let res = (response as? HTTPURLResponse)
            
            let responseCode = res?.statusCode ?? 0
            
            let result = HttpResponse<Data>()
            
            self.fillResultFromHeaders(result: result, response: res)
 
            if HttpClient.isReponseOK(code: responseCode) == false {
        
                result.RequestResult=HttpResponseStatus.Error
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
    
    private func fillResultFromHeaders(result: HttpResponse<Data>,response: HTTPURLResponse!){
        if response != nil {
            for (key,value) in (response?.allHeaderFields)! {
                if let sKey = key as? String,let sValue = value as? String {
                    result.ResponseHeaders[sKey]=sValue
                    if sKey == HttpHeaderCollection.ContentCharset {
                        result.ResponseCharset = sValue
                    }else if sKey == HttpHeaderCollection.ContentType && sValue.contains("charset"){
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
        result.ResponseCharsetEncoding = HttpClient.getEncodingFor(charset: result.ResponseCharset)
    }
    
    public static func getEncodingFor(charset:String)->String.Encoding{
        let iana = CFStringConvertIANACharSetNameToEncoding(charset as CFString)
        if iana != kCFStringEncodingInvalidId {
            let nsEncoding = CFStringConvertEncodingToNSStringEncoding(iana)
            return String.Encoding(rawValue: nsEncoding)
        } else {
            return String.Encoding.utf8
        }
    }
    
    public static func isReponseOK(code:Int)->Bool{
        return (code/100) == 2
    }
    
    private func unwarpData(data:Data!,ret:HttpResponse<Data>){
        if let safeData = data {
            ret.Value=safeData
            ret.RequestResult=HttpResponseStatus.Succeed
        }else{
            ret.RequestResult=HttpResponseStatus.EmptyData
        }
    }

    private func interceptRequest(request:HttpRequestParameters)->HttpRequestParameters{
        
        if skipInterceptions {
            return request
        }
        
        let params = ListHttpInterceptor()
            .intercept(interceptors:HttpClient.globalInterceptors, params:request)
        
        return ListHttpInterceptor()
            .intercept(interceptors:self.instanceInterceptors, params:params)
    
    }
    
    public func pushInstanceInterceptor(interceptor:HttpRequestInterceptor){
        self.instanceInterceptors.append(interceptor)
    }
    public func pushGlobalInterceptor(interceptor:HttpRequestInterceptor){
        HttpClient.globalInterceptors.append(interceptor)
    }
}













