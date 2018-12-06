//
//  CallbackConversion.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/5/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

class CallbackConversion{
    
    func mapExceptForData<T>(src:HttpResponse<Data>,dst:HttpResponse<T>){
        dst.ResponseCode=src.ResponseCode
        dst.ResponseHeaders=src.ResponseHeaders
        dst.ResponseCharset=src.ResponseCharset
        dst.ResponseCharsetEncoding = src.ResponseCharsetEncoding
        dst.RequestResult=src.RequestResult
        dst.ResponseError=src.ResponseError
        dst.Value=nil
        dst.ArrayValue=nil
        dst.resultIsArray=src.resultIsArray
    }
    
    func stringCallback(callback:@escaping(_ result:HttpResponse<String>)->Void)
        -> (_ result:HttpResponse<Data>)->Void{
            
            let ret = {(result:HttpResponse<Data>) in
                
                let res = HttpResponse<String>()
                
                self.mapExceptForData(src: result, dst: res)
                
                if result.RequestResult==HttpReponseStatus.Succeed{
                    
                    if let unwrapped = String(data:result.Value,encoding:res.ResponseCharsetEncoding){
                        res.Value=unwrapped;
                        res.RequestResult=HttpReponseStatus.Succeed
                    }else{
                        res.RequestResult=HttpReponseStatus.EmptyData
                    }
                    
                }
                
                callback(res)
            }
            
            return ret
    }
    
    
    func jsonCallback<T:Jsonable>(callback:@escaping(_ result:HttpResponse<T>)->Void)
        -> (_ result:HttpResponse<Data>)->Void{
            
            let ret = {(result:HttpResponse<Data>) in
                
                let res = HttpResponse<T>()
                
                self.mapExceptForData(src: result, dst: res)
                
                if result.RequestResult == HttpReponseStatus.Succeed{
                    
                    self.putDataInResult(data: result.Value, result: res)
                }
                
                callback(res)
            }
            return ret
    }
    
    
    func putDataInResult<T:Jsonable>(data:Data!, result:HttpResponse<T>){
        
        let conversionResult:DataToJsonConversionResult<T>
            = JsonConvert.dataToJsonable(data: data)
        
        if conversionResult.succeed {
            
            result.RequestResult = HttpReponseStatus.Succeed
            
            result.resultIsArray = conversionResult.isArray
            
            if conversionResult.isArray {
                result.ArrayValue = conversionResult.array
            }else{
                result.Value = conversionResult.value
            }
            
        }else{
            result.RequestResult = HttpReponseStatus.EmptyData
        }
    }
    
    
    
}
