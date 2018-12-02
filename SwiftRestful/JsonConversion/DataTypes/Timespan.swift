//
//  TimeSpan.swift
//  ICP.UI.IOS
//
//  Created by Mani Moayedi on 12/18/17.
//  Copyright © 2017 Mani Moayedi. All rights reserved.
//

import Foundation

class Timespan{
    var hours:Int=0
    var minutes:Int=0
    var seconds:Int=0
    
    init(timeString:String!) {
        if timeString != nil{
            let parts=timeString.split(separator: ":")
            if parts.count==3{
                if let h = Int(parts[0]) {
                    if let m = Int(parts[1]){
                        let secs = String(parts[2]).split(separator: ".")
                        if secs.count > 0 {
                            if let s = Int(secs[0]) {
                                self.load(hours: h, minutes: m, seconds: s)
                            }
                        }
                    }
                }
                
            }
        }
    }
    
    private func load(hours:Int,minutes:Int,seconds:Int){
        self.hours=hours
        self.minutes=minutes
        self.seconds=seconds
    }
    
    init(hours:Int,minutes:Int,seconds:Int){
        self.load(hours: hours, minutes: minutes, seconds: seconds)
    }
    required init() {    }
    
    private func fixLength(value:Int)->String{
        var ret = "\(value)"
        while ret.count < 2 {
            ret = "0"+ret
        }
        return ret
    }
    
    func toString()->String{
        return "\(fixLength(value: self.hours)):\(fixLength(value: self.minutes)):\(fixLength(value: self.seconds))"
    }
    func toUIString()->String{
        return "\(fixLength(value: self.hours)):\(fixLength(value: self.minutes))"
    }
}
