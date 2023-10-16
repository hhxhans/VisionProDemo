//
//  StringExtension.swift
//  Ar trial
//
//  Created by niudan on 2023/5/4.
//

import Foundation
import SwiftUI

extension String{
    mutating func Removelastblankspaces(){
        while self.last == " " {
            self.removeLast()
        }
    }
    var Droplastblankspaces:String{
        var Dropstring:String=self
        while Dropstring.last == " " {
            Dropstring.removeLast()
        }
        return Dropstring
    }
    func convertBase(from: Int, to: Int) -> String? {
        return Int(self, radix: from)
            .map { String($0, radix: to) }
    }
    
    func converttohexcode()->String{
        let Decimalcodestring:[String]=Array(self.utf8)
            .map{String(Int($0))}
        let Convertablearray:[Bool]=Decimalcodestring.map {
            $0.convertBase(from: 10, to: 16) != nil
        }
        let convertable=Convertablearray.reduce(true) {
            $0 && $1
        }
        if convertable{
            return Array(self.utf8)
                .map{"%"+(String(Int($0)).convertBase(from: 10, to: 16)!)}
                .reduce("") { $0 + $1}
        }else{
            return self
        }

    }
    var LocalizedString: String{
        return String(localized: String.LocalizationValue(self))
    }

}
