//
//  FeedModel.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

class FeedModel: CustomDebugStringConvertible {
    var title = ""
    var link = ""
    var description = ""
    var source = ""
    
    var imagURL = ""
    var items = [FeedItemModel]?()
    
    var index = 0
    var isFollowed = false
    var isFavorited = false
    var feedType = FeedType.Other
    

    var debugDescription: String {
        return title + "\n" + link + "\n" + description + "\n" + "ICON: " + imagURL + "\n" + "items : \(items?.count)"
    }
    
    static func loadLocalFeeds() -> [FeedModel] {
        return [
        ];
        
    }
    
}

extension FeedModel: Equatable { }

func ==(lhs: FeedModel, rhs: FeedModel) -> Bool {
    return lhs.link == rhs.link && lhs.title == rhs.title
}

class FeedItemModel: CustomDebugStringConvertible {
    var title = ""
    var link = ""
    var pubDate = ""
    var category = ""
    var description = ""

    var source = ""
    var dc = ""
    var author = ""

    var image = ""
    var isRead = false
    var isNoted = false
    var isFavorite = false
    
    var debugDescription: String {
        return title + "\n" + link + "\n" + image + "\n" + author + "\n" + description
    }
    
}