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
    
    mutating func shortString(maxCount: Int = 8) -> String {
        if self.characters.count <= maxCount {
            return self
        } else {
            
            let range = Range(start: startIndex.advancedBy(maxCount/2),end: self.endIndex)
            self.replaceRange(range, with: "...")
            
            return self
        }
    }
    
    func afterModeAjust() -> String {
        return iReadTheme.isNightMode() ? self + "_night" : self
        
    }
}

