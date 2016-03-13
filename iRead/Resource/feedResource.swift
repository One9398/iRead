//
//  feedResource.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

enum FeedType: String {
    case IT, New, Life, Art, Other,Blog
}

struct FeedResource  {
    static let sharedResource = FeedResource()
    var items = [FeedItem]()
    
    init() {
        
        let path = NSBundle.mainBundle().pathForResource("feeds", ofType: "plist")
        let source = NSArray(contentsOfFile: path!)
        
        for item in source! {
            let feedItem = FeedItem(feedURL: item["feedURL"] as! String, feedType: FeedType(rawValue: item["feedType"] as! String)!)

            items.append(feedItem)
            
        }
        
    }
    
    
}

struct FeedItem {
    let feedURL: String
    let feedType: FeedType
    init(feedURL: String, feedType: FeedType) {
        self.feedType = feedType
        self.feedURL = feedURL
        
    }
    
}