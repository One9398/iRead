//
//  iReadDateFormatter.swift
//  iRead
//
//  Created by Simon on 16/3/23.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class iReadDateFormatter: NSDateFormatter {
    static let sharedDateFormatter = iReadDateFormatter()
    
    override init() {
        super.init()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func getCustomDateStringFromDateString(string: String, styleString: String) -> String {
        let date: NSDate?
        var dateString: String = string
        
        self.dateFormat = string
        
        if !string.isEmpty {
            
            self.dateFormat = styleString
            
            if string.containsString("-") {
                date = NSDate(fromRFC3339String:string)
                
                dateString = self.stringFromDate(date!)
                
            } else {
                date = NSDate(fromRFC822String: string)
                dateString = self.stringFromDate(date!)
                
            }
        }
        
        return dateString
    }

}
