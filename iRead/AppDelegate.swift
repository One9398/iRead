
//  AppDelegate.swift
//  iRead
//
//  Created by Simon on 16/4/4.
//  Copyright © 4016年 Simon. All rights reserved.
//

import UIKit
import AVOSCloud

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let queue = NSOperationQueue()
    var dataSource = [FeedModelsProvider]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasStyle")
        AVOSCloud.setApplicationId(iReadConfigure.leancloudAppID, clientKey: iReadConfigure.leancloudAppKey)
        
        return true
    }

    func applicationWillTerminate(application: UIApplication) {

    }

}

