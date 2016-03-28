//
//  FeedModelsProvider.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

class FeedModelsProvider {
    private let queue = NSOperationQueue()
    
    let feedItem: FeedItem
    // 主线程进行completion回调
    init(feedItem: FeedItem, failure:FailureHandler?, completion: (FeedModel?) -> ()) {
        
        
        self.feedItem = feedItem
        
        let fetchOpreation = FeedFetchOperation(URLString: feedItem.feedURL, failure: failure)
        
        let parseOpreation = FeedParseOperation(feedData: nil, feedItem: feedItem, failure: failure, completion: completion)
        
        parseOpreation.addDependency(fetchOpreation)
        queue.addOperations([fetchOpreation, parseOpreation], waitUntilFinished: false)
    }
    
    func cancel() {
        queue.cancelAllOperations()
    }
    
}

extension FeedModelsProvider: Hashable {
    var hashValue: Int {
        return (feedItem.feedURL).hashValue
    }
}

func ==(lhs: FeedModelsProvider, rhs: FeedModelsProvider) -> Bool {
    return lhs.feedItem.feedURL == rhs.feedItem.feedURL
}