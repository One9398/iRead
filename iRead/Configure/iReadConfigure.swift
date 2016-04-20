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
        static let appID = "wx20f582046a9ff3ac"
        static let appKey = "845dd26eded7926507c009b71d195f13"
        
        static let sessionType = "com.Simon.WeChat.Session"
        static let sessionTitle = "WeChat Session"
        static let sessionImage = UIImage(named: "wechat_session")!
        
        static let timelineType = "com.Simon.WeChat.Timeline"
        static let timelineTitle = "WeChat Timeline"
        static let timelineImage = UIImage(named: "wechat_timeline")!
    }
    
    
    struct QQAccount {
        static let appID = "1105271809"
        static let appKey = "G0NIdWovgaHf7UDc"
    }
    
    static let appstoreLink = "https://itunes.apple.com/us/app/wo-yue-ge-xing-zi-xun-yue-du-qi/id1105457596?l=zh&ls=1&mt=8"
    static let rateAppLink = "itms-apps://itunes.apple.com/app/id" + "1105457596"
    
    static let leancloudAppKey = "e57Cpmb6xF353w5gyM1LTmxK"
    static let leancloudAppID = "79MfJxOL7Dou5UJ8rp8POYeN-gzGzoHsz"
    
}