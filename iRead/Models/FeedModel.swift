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
    
    var imagURL = ""
    var items = [FeedItemModel]?()
    
    var index = 0
    var isFollowed = false
    var isFavorited = false
    var feedType = FeedType.Other
    

    var debugDescription: String {
        return title + "\n" + link + "\n" + description + "\n" + imagURL + "\n" + "items : \(items?.count)"
    }

}

class FeedItemModel: CustomDebugStringConvertible {
    var title = ""
    var link = ""
    var author = ""
    var pubDate = ""
    var category = ""
    var description = ""
    var isRead = false
    var isNoted = false
    var isFavorite = false
    
    var debugDescription: String {
        return title + "\n" + link + "\n" + description + "\n" + category + "\n" + author
    }
}