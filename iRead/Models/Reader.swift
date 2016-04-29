//
//  Reader.swift
//  iRead
//
//  Created by Simon on 16/4/22.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation
//import AVOSCloud

let kReaderSubscribeItems = "subscribeItems"

class Reader: AVUser {
    @NSManaged var readMode: Bool
    @NSManaged var themeMode: Bool
    @NSManaged var readTime: Int
    @NSManaged var readCounts: Int
    @NSManaged var avater_url: String
    @NSManaged var subscribeItems: [AnyObject]?
    
    override static func parseClassName() -> String! {
        return "_User"
    }
    
}