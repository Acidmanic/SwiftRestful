//
//  Jsonable.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/7/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation
import NamingConventions

public typealias JsonMediumType = [String:Any]
public typealias JsonArrayMediumType = [Any]

public protocol Jsonable{
    
    
    init()
    func load(jsonData:JsonMediumType!)
    func getJsonData() -> JsonMediumType
}

public extension Array{
    
    public func getJsonData() -> [Any]{
        var ret:[Any] = []
        for kid in self{
            if let jkid = kid as? Jsonable{
                ret.append(jkid.getJsonData())
            }else if let arkid = kid as? Array{
                ret.append(arkid.getJsonData())
            }else{
                ret.append(kid)
            }
        }
        return ret
    }
    
}
public protocol JsonableKey{}
extension String:JsonableKey{}
public extension Dictionary where Key:JsonableKey,Value:Any{
    public func getValueByCase(key:Key,naming:NamingConvention)->Any!{
        if let stringKey = key as? String{
            let innerKey = ConventionConverter().autoConvert(from: stringKey, to: naming)
            if let convertedBackKey = innerKey as? Key {
                return self[convertedBackKey]
            }
        }
        return nil
    }
    public func getValueByAnyOfCases(key:Key,namingCases:[NamingConvention])->Any!{
        for naming in namingCases{
            if let ret = self.getValueByCase(key: key, naming: naming){
                return ret
            }
        }
        return nil
    }
}
public extension Jsonable {
    
    private func isAtomic(_ data:Any)->Bool{
        if data as? String != nil {return true}
        if data as? Double != nil {return true}
        if data as? Float32 != nil {return true}
        if data as? Float64 != nil {return true}
        if data as? Float != nil {return true}
        if data as? Int != nil {return true}
        if data as? Int8 != nil {return true}
        if data as? Int16 != nil {return true}
        if data as? Int32 != nil {return true}
        if data as? Int64 != nil {return true}
        if data as? UInt != nil {return true}
        if data as? UInt8 != nil {return true}
        if data as? UInt16 != nil {return true}
        if data as? UInt32 != nil {return true}
        if data as? UInt64 != nil {return true}
        if data as? Bool != nil {return true}
        if data as? Character != nil {return true}
        return false;
    }
    
    private func isCustomeAtomic(_ data:Any)->String!{
        if let value = data as? Timespan {return value.toString()}
        return nil;
    }
    private func unwrap(any:Any!)->Any!{
        let mir = Mirror(reflecting:any)
        if let buster = any as? Optional<Any>{
            if mir.children.count==0{
                return nil
            }
            let (_,some)=mir.children.first!
            return some
        }else{
            return any
        }
    }
    
    public func getJsonData() -> JsonMediumType{
        var ret=JsonMediumType()
        let mir = Mirror(reflecting:self)
        for kid in mir.children{
            if let label = kid.label {
                if let uwrappedKid = kid.value as Any! {
                    if let jbl = uwrappedKid as? Jsonable {
                        ret[label] = jbl.getJsonData()
                    }else if let fjbl = unwrap(any:uwrappedKid) as? Jsonable{
                        ret[label] = fjbl.getJsonData()
                    }else if let ary = kid.value as? [Any]{
                        ret[label] = ary.getJsonData()
                    }else if let cat = isCustomeAtomic(kid.value){
                        ret[label] = cat
                    }else if isAtomic(kid.value){
                        ret[label] = kid.value
                    }
                }
            }
        }
        return ret
    }
    
    
    public func loadArray<T:Jsonable>(jsonData:Any!)->[T]{
        var ret:[T]=[]
        if let jitems = jsonData as? [JsonMediumType]{
            for jitem in jitems{
                let item = T()
                item.load(jsonData: jitem)
                ret.append(item)
            }
        }
        return ret
    }
    
    
}
