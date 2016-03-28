//
//  feedResource.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

enum FeedType: String {
    case ITNews, TechStudy, Life, Art, Other,Blog
}

class FeedResource  {
    static let sharedResource = FeedResource()
    var items = [FeedItem]()
    
    init() {
        
        let path = NSBundle.mainBundle().pathForResource("feeds", ofType: "plist")
        let source = NSArray(contentsOfFile: path!)
        
        for item in source! {
            
            let feedItem = FeedItem(feedURL: item["feedURL"] as! String, feedType: FeedType(rawValue: item["feedType"] as! String)!, isSub: item["isSub"] as! Bool)
            items.append(feedItem)
        }
        
    }
    
    func appendFeed(feedURL: String, feedType: FeedType, isSub: Bool) {
        
        let feedItem = FeedItem(feedURL: feedURL, feedType: feedType, isSub: isSub)
        
        items.append(feedItem)
    }
    
    func removeFeed(feedURL: String) {
        items =  items.filter{ $0.feedURL != feedURL }
    }
    
}

struct FeedItem {
    let feedURL: String
    let feedType: FeedType
    let isSub: Bool
    
    init(feedURL: String, feedType: FeedType, isSub: Bool) {
        self.feedType = feedType
        self.feedURL = feedURL
        self.isSub = isSub
    }
    
}