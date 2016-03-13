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
    
    let feedModel:FeedModel? = nil
    let feedItemModel: FeedItemModel? = nil
    let feedURL: String
    let index: Int

    // 主线程进行completion回调
    init(feedURL: String, index: Int, feedType: FeedType, completion: (FeedModel?) -> ()) {
        
        self.feedURL = feedURL
        self.index = index
        
        let fetchOpreation = FeedFetchOperation(URLString: feedURL, index: index)
        let parseOpreation = FeedParseOperation(feedData: nil, index: index, feedType: feedType, completion: completion)
        
        parseOpreation.addDependency(fetchOpreation)
        queue.addOperations([fetchOpreation, parseOpreation], waitUntilFinished: false)
        
    }
    
    func cancle() {
        queue.cancelAllOperations()
    }
    
}

extension FeedModelsProvider: Hashable {
    var hashValue: Int {
        return (feedURL).hashValue
    }
}

func ==(lhs: FeedModelsProvider, rhs: FeedModelsProvider) -> Bool {
    return lhs.feedURL == rhs.feedURL
}