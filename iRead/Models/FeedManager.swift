//
//  FeedManager.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation
struct FeedManager {
    static let defaultManager = FeedManager()
    
    init() {
        
    }
    
    static var currentSubscribedFeeds = [FeedModel]()
    static var itnewFeeds = [FeedModel]()
    static var techstudyFeeds = [FeedModel]()
    
}

