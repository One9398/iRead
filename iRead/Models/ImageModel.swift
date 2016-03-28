//
//  ImageModel.swift
//  iRead
//
//  Created by Simon on 16/3/23.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

struct ImageModel {
    var title = ""
    var urlString = ""
    init(title: String, urlString: String) {
        self.title = title
        self.urlString = urlString
    }
}