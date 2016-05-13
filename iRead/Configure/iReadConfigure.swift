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

    static let FeedItemsRemoteFetchDidFinishedNotification = "FeedItemsRemoteFetchDidFinishedNotification"
    
    static let FeedArticlesRemoteFetchDidFinishedNotification = "FeedArticlesRemoteFetchDidFinishedNotification"
    static let FeedArticlesToreadStateDidChangedNotification = "FeedArticlesToreadStateDidChangedNotification"
    static let FeedArticlesFavrivotedStateDidChangedNotification = "FeedArticlesFavrivotedStateDidChangedNotification"
    
    static let iReadserDidLogoutNotification = "iReadserDidLogoutNotification"
    
 
}

struct iReadConfigure {
    
    struct WeChatAccount {
        static let appID = "wx20f582046a9ff3ac"
        static let appKey = "845dd26eded7926507c009b71d195f13"
        static let redirectURL = ""
        
        static let sessionType = "com.Simon.WeChat.Session"
        static let sessionTitle = "WeChat Session"
        static let sessionImage = UIImage(assetsIdentifier: .wechat_icon)
        
        static let timelineType = "com.Simon.WeChat.Timeline"
        static let timelineTitle = "WeChat Timeline"
        static let timelineImage = UIImage(assetsIdentifier: .wechat_timeline_icon)
    }
    
    struct QQAccount {
        static let appID = "1105271809"
        static let appKey = "G0NIdWovgaHf7UDc"
        static let redirectURL = ""
        static let schemeKey = "1105271809"

    }
    
    struct WeiboAccount {
        static let appID = "207765974"
        static let appKey = "b37ef41a3fa884023339519a809e5c94"
        static let redirectURL = "http://www.baidu.com"
        static let schemeKey = "sinaweibosso.207765974"
    }

    
    static let appstoreLink = "https://itunes.apple.com/us/app/wo-yue-ge-xing-zi-xun-yue-du-qi/id1105457596?l=zh&ls=1&mt=8"
    static let rateAppLink = "itms-apps://itunes.apple.com/app/id" + "1105457596"
    
    struct LeanCloudService {
        static let appKey = "e57Cpmb6xF353w5gyM1LTmxK"
        static let appID = "79MfJxOL7Dou5UJ8rp8POYeN-gzGzoHsz"
    }
    
    struct BugtagsService {
        static let appKeyForBeta = "649ab2482f1c5cb1b75c8833e875dd14"
        static let appKeyForLive = "434e0f0040730ec2504084f1eb57af01"
    }
}