//
//  HttpApiClient.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/6/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation


public class HttpApiClient:HttpClient{
    
    func get(url:String,callback:@escaping(_ result:HttpResult<String>)->Void){
        download(url: url, method: HttpMethod.GET,
                 headers: [HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType],
                 callback: stringCallback(callback: callback))
    }
    
    func get(url:String,params:[String:String]!,accept:String,
             callback:@escaping(_ result:HttpResult<String>)->Void){
        var fullurl = url
        if params != nil {
            fullurl = url + "?" + ParameterConversion().encodeParams(params:params)
        }
        download(url: fullurl, method: HttpMethod.GET,
                 headers: [HttpHeaderCollection.Accept:accept],
                 callback: stringCallback(callback: callback))
    }

    func getJson<T:Jsonable>(url:String,params:[String:String]!,
                 callback:@escaping(_ result:HttpResult<T>)->Void){
        var fullurl = url
        if params != nil {
            fullurl = url + "?" + ParameterConversion().encodeParams(params:params)
        }
        download(url: fullurl, method: HttpMethod.GET,
                 headers: [HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType],
                 callback: jsonCallback(callback: callback))
    }
    
    func post(url:String,body:Data!,format:String,callback:@escaping(_ result:HttpResult<Data>)->Void){
        download(url: url, method: HttpMethod.POST,
                 headers: [HttpHeaderCollection.ContentType:format,HttpHeaderCollection.Accept:format],
                 contentData:body,callback:callback)
    }
    
    func post<T:Jsonable>(url:String,json:Jsonable,callback:@escaping(_ result:HttpResult<T>)->Void){
        let medium = json.getJsonData()
        
        let data = try? JSONSerialization.data(withJSONObject: medium, options: [])
        download(url: url, method: HttpMethod.POST,
                 headers: [HttpHeaderCollection.ContentType:HttpHeaderCollection.JsonContentType,
                           HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType],
                 contentData:data,
                 callback: jsonCallback(callback: callback))
    }
    
    func post(url:String,urlParams:[String:String],accept:String,callback:@escaping(_ result:HttpResult<String>)->Void){
        let data = ParameterConversion().encodeParams(params: urlParams).data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.POST,
                 headers: [HttpHeaderCollection.Accept:accept,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: data, callback: stringCallback(callback: callback))
    }
    
    func postReceiveJson<T:Jsonable>(url:String,urlParams:[String:String],callback:@escaping(_ result:HttpResult<T>)->Void){
        let data = ParameterConversion().encodeParams(params: urlParams)
            .data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.POST,
                 headers: [HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: data, callback: jsonCallback(callback: callback))
    }
    
    
    
    func postInUrl(url:String,urlParams:[String:String],accept:String,callback:@escaping(_ result:HttpResult<String>)->Void){
        download(url: url+"?"+ParameterConversion().encodeParams(params: urlParams),
                 method: HttpMethod.POST,
                 headers: [HttpHeaderCollection.Accept:accept,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: nil, callback: stringCallback(callback: callback))
    }
    
    func postInUrlReceiveJson<T:Jsonable>(url:String,urlParams:[String:String],callback:@escaping(_ result:HttpResult<T>)->Void){
        download(url: url+"?"+ParameterConversion().encodeParams(params: urlParams),
                 method: HttpMethod.POST,
                 headers: [HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: nil, callback: jsonCallback(callback: callback))
    }
    
    
    
    
    func put(url:String,body:Data!,format:String,callback:@escaping(_ result:HttpResult<Data>)->Void){
        download(url: url, method: HttpMethod.PUT,
                 headers: [HttpHeaderCollection.ContentType:format,HttpHeaderCollection.Accept:format],
                 contentData:body,callback:callback)
    }
    
    func put<T:Jsonable>(url:String,json:Jsonable,callback:@escaping(_ result:HttpResult<T>)->Void){
        let medium = json.getJsonData()
        
        let data = try? JSONSerialization.data(withJSONObject: medium, options: [])
        download(url: url, method: HttpMethod.PUT,
                 headers: [HttpHeaderCollection.ContentType:HttpHeaderCollection.JsonContentType,
                           HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType],
                 contentData:data,
                 callback: jsonCallback(callback: callback))
    }
    
    func put(url:String,urlParams:[String:String],accept:String,callback:@escaping(_ result:HttpResult<String>)->Void){
        let data = ParameterConversion().encodeParams(params: urlParams).data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.PUT,
                 headers: [HttpHeaderCollection.Accept:accept,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: data, callback: stringCallback(callback: callback))
    }
    
    func putReceiveJson<T:Jsonable>(url:String,urlParams:[String:String],callback:@escaping(_ result:HttpResult<T>)->Void){
        let data = ParameterConversion().encodeParams(params: urlParams).data(using: String.Encoding.utf8)
        download(url: url, method: HttpMethod.PUT,
                 headers: [HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: data, callback: jsonCallback(callback: callback))
    }
    
    
    
    func putInUrl(url:String,urlParams:[String:String],accept:String,callback:@escaping(_ result:HttpResult<String>)->Void){
        download(url: url+"?"+ParameterConversion().encodeParams(params: urlParams),
                 method: HttpMethod.PUT,
                 headers: [HttpHeaderCollection.Accept:accept,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: nil, callback: stringCallback(callback: callback))
    }
    
    func putInUrlReceiveJson<T:Jsonable>(url:String,urlParams:[String:String],callback:@escaping(_ result:HttpResult<T>)->Void){
        download(url: url+"?"+ParameterConversion().encodeParams(params: urlParams),
                 method: HttpMethod.PUT,
                 headers: [HttpHeaderCollection.Accept:HttpHeaderCollection.JsonContentType,
                           HttpHeaderCollection.ContentType:HttpHeaderCollection.FormUrlContentType],
                 contentData: nil, callback: jsonCallback(callback: callback))
    }
    
    
    
    private func stringCallback(callback:@escaping(_ result:HttpResult<String>)->Void)
        -> (_ result:HttpResult<Data>)->Void{
            let ret = {(result:HttpResult<Data>) in
                let res = HttpResult<String>()
                res.ResponseCode=result.ResponseCode
                if result.RequestResult==HttpRequestResults.Succeed{
                    if let unwrapped = String(data:result.Value,encoding:.utf8){
                        res.Value=unwrapped;
                        res.RequestResult=HttpRequestResults.Succeed
                    }else{
                        res.RequestResult=HttpRequestResults.EmptyData
                    }
                }else{
                    res.RequestResult=result.RequestResult
                    res.ResponseError=result.ResponseError
                    res.Value=nil
                }
                callback(res)
            }
            return ret
    }
    
    private func jsonCallback<T:Jsonable>(callback:@escaping(_ result:HttpResult<T>)->Void)
        -> (_ result:HttpResult<Data>)->Void{
            let ret = {(result:HttpResult<Data>) in
                let res = HttpResult<T>()
                res.ResponseCode=result.ResponseCode
                if result.RequestResult == HttpRequestResults.Succeed{
                    if let unwrapped = result.Value{
                        if let json = try? JSONSerialization.jsonObject(with: unwrapped
                            , options: .mutableContainers){
                        if let jdata = json as? JsonMediumType {
                            res.Value = T();
                            res.Value.load(jsonData: jdata)
                            res.RequestResult=HttpRequestResults.Succeed
                        }else if let jarry = json as? JsonArrayMediumType{
                            var array:[T]!=[]
                            for jitem in jarry{
                                if let jmed = jitem as? JsonMediumType{
                                    let item = T()
                                    item.load(jsonData: jmed)
                                    array.append(item)
                                }
                            }
                            res.ArrayValue=array
                            res.resultIsArray=true
                            res.RequestResult=HttpRequestResults.Succeed
                        }else{
                            res.RequestResult=HttpRequestResults.EmptyData
                        }
                        }
                    }else{
                        res.RequestResult=HttpRequestResults.EmptyData
                    }
                }else{
                    res.RequestResult=result.RequestResult
                    res.ResponseError=result.ResponseError
                    res.Value=nil
                }
                callback(res)
            }
            return ret
    }
    

    
}
