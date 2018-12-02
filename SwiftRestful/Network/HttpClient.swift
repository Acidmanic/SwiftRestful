//
//  HttpClient.swift
//  Movies
//
//  Created by Mani Moayedi on 12/4/17.
//  Copyright © 2017 GK. All rights reserved.
//

import Foundation

enum HttpRequestResults{
    case Succeed
    case EmptyData
    case Error
    case InvalidUrl
    case NoRequestMade
}

class HttpResult<T>{
    var RequestResult:HttpRequestResults=HttpRequestResults.NoRequestMade
    var Value:T!
    var ArrayValue:[T]!
    var resultIsArray:Bool=false
    var ResponseError:Error!
    var ResponseCode:Int=0
    
}

enum HttpMethod:String{
    case POST
    case GET
    case DELETE
    case PUT
}

class HttpHeaderCollection{
    static let ContentType="Content-Type"
    static let TextContentType="application/text"
    static let JsonContentType="application/json"
    static let XmlContentType="application/xml"
    static let FormUrlContentType="application/x-www-form-urlencoded; charset=utf-8"
    static let Accept="Accept"
    static let Authorization="Authorization"
    static let AuthorizationBearerPrefix="bearer "
}

class HttpClient{
    
    private var instanceInterceptors:[HttpRequestInterceptor]=[]
    private static var globalInterceptors:[HttpRequestInterceptor]=[]
    
    func download(url:String,method:HttpMethod,callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String] = [:]
        headers[HttpHeaderCollection.ContentType]=HttpHeaderCollection.TextContentType
        headers[HttpHeaderCollection.Accept]=HttpHeaderCollection.TextContentType
        download(url: url, method: method,
                 headers:headers, callback: callback)
    }
    
    
    func download(url:String,method:HttpMethod,headers:[String:String],callback:@escaping (_ result:HttpResult<Data>)->Void){
        download(url: url, method: method,headers:headers,contentData:nil,callback: callback)
    }
    
    func download(url:String,urlPostString:String,accept:String!,callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String]=[:]
        headers[HttpHeaderCollection.ContentType]=HttpHeaderCollection.FormUrlContentType
        headers[HttpHeaderCollection.Accept]=(accept != nil) ? accept! : HttpHeaderCollection.XmlContentType
        let contentData = urlPostString.data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.POST,headers:headers,contentData:contentData,callback: callback)
    }
    
    
    func download(url:String,urlParams:[String:String],accept:String!,callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String]=[:]
        headers[HttpHeaderCollection.ContentType]=HttpHeaderCollection.FormUrlContentType
        headers[HttpHeaderCollection.Accept]=(accept != nil) ? accept! : HttpHeaderCollection.XmlContentType
        let contentData = encodeParams(params: urlParams).data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.POST,headers:headers,contentData:contentData,callback: callback)
    }
    
    func download(url:String,method:HttpMethod,
                  contentData:Data!,contentType:String,
                  callback:@escaping (_ result:HttpResult<Data>)->Void){
        var headers:[String:String]=[:]
        headers[HttpHeaderCollection.ContentType]=contentType
        headers[HttpHeaderCollection.Accept]=contentType
        download(url: url, method: method, headers: headers, contentData: contentData, callback: callback)
    }
    
    func download(url:String,method:HttpMethod,headers:[String:String],
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
    
    func pushInstanceInterceptor(interceptor:HttpRequestInterceptor){
        self.instanceInterceptors.append(interceptor)
    }
    func pushGlobalInterceptor(interceptor:HttpRequestInterceptor){
        HttpClient.globalInterceptors.append(interceptor)
    }
}













