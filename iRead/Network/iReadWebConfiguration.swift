//
//  iReadWebConfiguration.swift
//  iRead
//
//  Created by Simon on 16/3/21.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import WebKit

class iReadWebConfiguration: WKWebViewConfiguration {

    static let sharedConfiguration = WKWebViewConfiguration()
    
    override init() {
        super.init()
        
    }
    
}
