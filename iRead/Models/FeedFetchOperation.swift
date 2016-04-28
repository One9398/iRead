//
//  FeedFetchOperation.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Ono

class FeedFetchOperation: ConcurrentOperation {
    
    private var URLString:String
    private var feedData: NSData?
//    private var index = 0
    private let failure: FailureHandler?

    
    init(URLString: String, failure:FailureHandler?) {
        // 配置基本设置和数据idx
        self.URLString = URLString
        //        self.index = index
        self.failure = failure
        
        super.init()
    }

    // 操作被运行时带哦用
    override func main() {
        
        fetchXMLDataFromURLString(URLString, failureHandle: { (error, message) -> Void in
            
            print("Error\(self.URLString):\(message)")
            self.state = .Finished
            self.failure!(error: error, message: message)
            
            // 提示网络错误
            let notification = NSNotification(name: iReadNotification.FeedFetchOperationDidSinglyFailureNotification, object: self)
            NSNotificationQueue.defaultQueue().enqueueNotification(notification, postingStyle: .PostNow, coalesceMask: [.CoalescingOnName], forModes: nil)
            
            }) { (data) -> Void in
                
                self.feedData = data
                self.state = .Finished
                
                NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedFetchOperationDidSinglyFinishedNotification, object: self, userInfo: ["URLString" : self.URLString])
        }
    }
    
    deinit {
//        print("\(URLString) 网络获取数据结束, deinit")
    }
}

extension FeedFetchOperation: FeedParseOperationDataPorvider {
    var parseData: NSData? {
        return feedData
    }
}

