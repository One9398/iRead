//
//  iReadConfigure.swift
//  iRead
//
//  Created by Simon on 16/3/10.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

struct iReadNotification {
    static let FeedFetchOperationDidSinglyFinishedNotification = "FeedFetchOperationDidSinglyFinishedNotification"
    static let FeedParseOperationDidSinglyFinishedNotification = "FeedParseOperationDidSinglyFinishedNotification"
    
    static let FeedParseOperationDidSinglyFailureNotification = "FeedParseOperationDidSinglyFinishedNotification"
    static let FeedFetchOperationDidSinglyFailureNotification = "FeedFetchOperationDidSinglyFailureNotification"
}

struct iReadConfigure {
    struct WeChatAccount {
        static let appID = "wx10f099f798871364"
        static let appKey = ""
        
        static let sessionType = "com.Simon.WeChat.Session"
        static let sessionTitle = "WeChat Session"
        static let sessionImage = UIImage(named: "wechat_session")!
        
        static let timelineType = "com.Simon.WeChat.Timeline"
        static let timelineTitle = "WeChat Timeline"
        static let timelineImage = UIImage(named: "wechat_timeline")!
    }
}