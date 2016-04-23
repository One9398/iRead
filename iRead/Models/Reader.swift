//
//  Reader.swift
//  iRead
//
//  Created by Simon on 16/4/22.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation
import AVOSCloud

class Reader: AVUser {
    @NSManaged var avater: AVFile?
    @NSManaged var readMode: Bool
    @NSManaged var themeMode: Bool
    @NSManaged var readTime: Int
    @NSManaged var readCounts: Int
    @NSManaged var avater_url: String?
    
    override static func parseClassName() -> String! {
        return "_User"
    }
    
    func configureWhenFirstRegister() {
        
    }
    
}