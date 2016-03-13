//
//  iReadString.swift
//  
//
//  Created by Simon on 16/3/11.
//
//

import Foundation

extension String {
    func isEqualIgnoreCase(rhs: String) -> Bool {
    
        return rhs.lowercaseString == self.lowercaseString
        
    }
}