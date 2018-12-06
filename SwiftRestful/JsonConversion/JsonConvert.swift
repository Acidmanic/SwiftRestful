//
//  JsonConvert.swift
//  SwiftRestful iOS
//
//  Created by Mani Moayedi on 12/6/18.
//  Copyright © 2018 Mani Moayedi. All rights reserved.
//

import Foundation

public class JsonConvert{
    
    public static func dataToJsonable<T:Jsonable>(data:Data!)->DataToJsonConversionResult<T>{
        
        let ret = DataToJsonConversionResult<T>()
        
        if let unwrapped = data{
            
            if let json = try? JSONSerialization.jsonObject(with: unwrapped
                , options: .mutableContainers){
                
                if let jdata = json as? JsonMediumType {
                    ret.value = T();
                    ret.value.load(jsonData: jdata)
                    ret.succeed=true
                    ret.isArray=false
                }else if let jarry = json as? JsonArrayMediumType{
                    var array:[T]!=[]
                    for jitem in jarry{
                        if let jmed = jitem as? JsonMediumType{
                            let item = T()
                            item.load(jsonData: jmed)
                            array.append(item)
                        }
                    }
                    ret.array=array
                    ret.succeed=true
                    ret.isArray=true
                }
            }
        }
        return ret
    }
}


