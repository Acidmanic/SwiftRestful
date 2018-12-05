//
//  CallbackConversion.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

class CallbackConversion{
    
    func getEncodingFor(charset:String)->String.Encoding{
        let iana = CFStringConvertIANACharSetNameToEncoding(charset as CFString)
        if iana != kCFStringEncodingInvalidId {
            let nsEncoding = CFStringConvertEncodingToNSStringEncoding(iana)
            return String.Encoding(rawValue: nsEncoding)
        } else {
            return String.Encoding.utf8
        }
    }
    
    func stringCallback(callback:@escaping(_ result:HttpResult<String>)->Void)
        -> (_ result:HttpResult<Data>)->Void{
            let ret = {(result:HttpResult<Data>) in
                let res = HttpResult<String>()
                res.ResponseCode=result.ResponseCode
                res.ResponseHeaders=result.ResponseHeaders
                res.ResponseCharset=result.ResponseCharset
                let encoding = self.getEncodingFor(charset: res.ResponseCharset)
                if result.RequestResult==HttpRequestResults.Succeed{
                    if let unwrapped = String(data:result.Value,encoding:encoding){
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
    
    
    func jsonCallback<T:Jsonable>(callback:@escaping(_ result:HttpResult<T>)->Void)
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
