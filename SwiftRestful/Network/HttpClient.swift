//
//  HttpClient.swift
//  Movies
//
//  Created by Mani Moayedi on 12/4/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

public enum HttpRequestResults{
    case Succeed
    case EmptyData
    case Error
    case InvalidUrl
    case NoRequestMade
}

public class HttpResult<T>{
    public var RequestResult:HttpRequestResults=HttpRequestResults.NoRequestMade
    public var Value:T!
    public var ArrayValue:[T]!
    public var resultIsArray:Bool=false
    public var ResponseError:Error!
    public var ResponseCode:Int=0
    
}

public enum HttpMethod:String{
    case POST
    case GET
    case DELETE
    case PUT
}

public class HttpHeaderCollection{
    public static let ContentType="Content-Type"
    public static let TextContentType="application/text"
    public static let JsonContentType="application/json"
    public static let XmlContentType="application/xml"
    public static let FormUrlContentType="application/x-www-form-urlencoded; charset=utf-8"
    public static let Accept="Accept"
    public static let Authorization="Authorization"
    public static let AuthorizationBearerPrefix="bearer "
}

public class HttpClient{
    
    private var instanceInterceptors:[HttpRequestInterceptor]=[]
    private static var globalInterceptors:[HttpRequestInterceptor]=[]
    
    public func download(url:String,method:HttpMethod,callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String] = [:]
        headers[HttpHeaderCollection.ContentType]=HttpHeaderCollection.TextContentType
        headers[HttpHeaderCollection.Accept]=HttpHeaderCollection.TextContentType
        download(url: url, method: method,
                 headers:headers, callback: callback)
    }
    
    
    public func download(url:String,method:HttpMethod,headers:[String:String],callback:@escaping (_ result:HttpResult<Data>)->Void){
        download(url: url, method: method,headers:headers,contentData:nil,callback: callback)
    }
    
    public func downloadPOST(url:String,urlPostString:String,accept:String!,callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String]=[:]
        headers[HttpHeaderCollection.ContentType]=HttpHeaderCollection.FormUrlContentType
        headers[HttpHeaderCollection.Accept]=(accept != nil) ? accept! : HttpHeaderCollection.XmlContentType
        let contentData = urlPostString.data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.POST,headers:headers,contentData:contentData,callback: callback)
    }
    
    
    public func downloadPOST(url:String,urlParams:[String:String],accept:String!,callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String]=[:]
        headers[HttpHeaderCollection.ContentType]=HttpHeaderCollection.FormUrlContentType
        headers[HttpHeaderCollection.Accept]=(accept != nil) ? accept! : HttpHeaderCollection.XmlContentType
        let contentData = encodeParams(params: urlParams).data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.POST,headers:headers,contentData:contentData,callback: callback)
    }
    
    public func download(url:String,method:HttpMethod,
                  contentData:Data!,contentType:String,
                  callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String]=[:]
        headers[HttpHeaderCollection.ContentType]=contentType
        headers[HttpHeaderCollection.Accept]=contentType
        download(url: url, method: method, headers: headers, contentData: contentData, callback: callback)
    }
    
    public func download(url:String,method:HttpMethod,headers:[String:String],
                  contentData:Data!,callback:@escaping (_ result:HttpResult<Data>)->Void){
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
    
    internal func badRequest(callback:@escaping (_ result:HttpResult<Data>)->Void){
        let result = HttpResult<Data>()
        result.RequestResult=HttpRequestResults.InvalidUrl
        callback(result)
    }
    
    private func performDownload(requestParams:HttpRequestParameters,
                                 callback:@escaping (_ result:HttpResult<Data>)->Void){
        let request = translateRequest(requestParams: requestParams)
        if request == nil {
            badRequest(callback:callback)
            return
        }
        let task = URLSession.shared.dataTask(with: request!, completionHandler: { (data,response,error) in
            let responseCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            if self.isReponseOK(code: responseCode) == false {
                let result = HttpResult<Data>()
                result.RequestResult=HttpRequestResults.Error
                result.ResponseError=error
                result.ResponseCode=responseCode
                callback(result)
            }else{
                callback(self.unwarpData(data:data,code:responseCode))
            }
        })
        task.resume()
    }
    private func isReponseOK(code:Int)->Bool{
        return (code/100) == 2
    }
    
    private func unwarpData(data:Data!,code:Int)->HttpResult<Data>{
        let ret = HttpResult<Data>()
        if let safeData = data {
            ret.Value=safeData
            ret.RequestResult=HttpRequestResults.Succeed
        }else{
            ret.RequestResult=HttpRequestResults.EmptyData
        }
        ret.ResponseCode=code
        return ret;
    }
    
    
    internal func encodeParams(params:[String:String])->String{
        var ret = ""
        var sep = ""
        for (key,value) in params {
            ret = ret + sep + key + "=" + value
            sep="&"
        }
        return ret.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
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













