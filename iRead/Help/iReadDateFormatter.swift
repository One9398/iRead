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
    
//    func getBeijingTimeWithStyle(styleString : String) -> String {
//
//        let date = NSDate()
//        print(styleString)
//        print(date)
//        self.dateFormat = "MM月"
//        let dateString = self.stringFromDate(date)
//        return dateString
//    }
    func getCurrentDateString(StyleString: String) -> String {
        
        self.dateFormat = StyleString
        let dateString = self.stringFromDate(NSDate())
        return dateString
    }
    
    static func isDuringNight() -> Bool {
        guard let hour = Int(iReadDateFormatter.sharedDateFormatter.getCurrentDateString("HH")) else { return false }
        if hour >= 19 || hour <= 6 {
            return true
        } else {
            return false
        }
    }
    
    func getCustomDateStringFromDateString(string: String, styleString: String) -> String {
        let date: NSDate?
        var dateString: String = string
        
        self.dateFormat = string
        
        if !string.isEmpty {
            
            self.dateFormat = styleString
            
            if string.containsString("-") {
                date = NSDate(fromRFC3339String:string)
                if date != nil {
                    dateString = self.stringFromDate(date!)
                } else {
                    dateString = ""
                }
                
            } else {
                date = NSDate(fromRFC822String: string)
                dateString = self.stringFromDate(date!)
                
            }
        }
        
        return dateString
    }

}
