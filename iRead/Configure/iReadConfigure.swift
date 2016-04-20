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
    
    static let appstoreLink = "https://itunes.apple.com/us/app/wo-yue-ge-xing-zi-xun-yue-du-qi/id1105457596?l=zh&ls=1&mt=8"
    static let rateAppLink = "itms-apps://itunes.apple.com/app/id" + "1105457596"
    
}