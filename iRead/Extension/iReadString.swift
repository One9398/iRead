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
    
    
//   对字符串的邮箱验证:  http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
    
    func isVaildUsername() -> Bool {
        return self.characters.count > 0
    }
    
    func isVaildPassword() -> Bool {
        return self.characters.count >= 6
    }
    
    func isValidEmail() -> Bool {
        
        if self.characters.count <= 0 {
            return false
        } else {
            
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
            let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailTest.evaluateWithObject(self)
        }


    }
}

