//
//  AppDelegate.swift
//  iRead
//
//  Created by Simon on 16/4/4.
//  Copyright © 4016年 Simon. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let queue = NSOperationQueue()
    var dataSource = [FeedModelsProvider]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        //feedTest()
        
        return true
    }


    var feedModelsProvider: FeedModelsProvider? = nil
    
    func feedTest() {
        
        let a = FeedResource.sharedResource.items
        print(a)
        
        for i in 0...4 {
            
            print(i)
            
            let feedItem = a[i]
            
            let provider = FeedModelsProvider(feedURL: feedItem.feedURL, index: i, feedType: feedItem.feedType, completion: { (model: FeedModel?) -> () in
                

                
            })

            dataSource.append(provider)
            
        }
        
//        _ = FeedModelsProvider(feedURL: "http://www.dgtle.com/rss/dgtle.xml", index: 2, feedType: FeedType.Art, completion: { (model) -> () in
//            print(NSThread.currentThread())
//            print(NSThread.currentThread())
//            print(model)
//            
//        })
        
        /*
        var model = FeedModel()
        model.index = 1
        model.link = "http://www.dgtle.com/rss/dgtle.xml"
        let op = FeedFetchOperation(URLString: model.link, index: model.index)
        queue.addOperation(op)
        
        var model2 = FeedModel()
        model2.index = 2
        model2.feedLink = "http://www.starming.com/index.php?v=index&rss=all"
        let op2 = FeedOperation(feedModel: model2)
        queue.addOperation(op2)
        
        var model3 = FeedModel()
        model3.index = 3
        model3.feedLink = "http://songshuhui.net/feed"
        let op3 = FeedOperation(feedModel: model3)
        queue.addOperation(op3)
        
        var model4 = FeedModel()
        model4.index = 4
        model4.feedLink = "http://www.36kr.com/feed"
        let op4 = FeedOperation(feedModel: model4)
        queue.addOperation(op4)
        
        var model5 = FeedModel()
        model5.index = 5
        model5.feedLink = "http://www.ifanr.com/feed"
        let op5 = FeedOperation(feedModel: model5)
        queue.addOperation(op5)
        queue.addObserver(self, forKeyPath: "operationCount", options: .New, context: nil)
       */

    }
}

