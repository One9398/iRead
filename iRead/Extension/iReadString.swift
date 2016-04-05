//
//  iReadString.swift
//  
//
//  Created by Simon on 16/3/11.
//
//

import Foundation

extension String {
    func isEqualIgnoreCaseStirng(rhs: String) -> Bool {
        return rhs.lowercaseString == self.lowercaseString
    }
    
    func usePlaceholdStringWhileIsEmpty(string: String) -> String {
        return (self == "") ? string : self
        
    }
}

