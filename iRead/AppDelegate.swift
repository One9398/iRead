
//  AppDelegate.swift
//  iRead
//
//  Created by Simon on 16/4/4.
//  Copyright © 4016年 Simon. All rights reserved.
//

import UIKit
import AVOSCloud
import LeanCloudSocialDynamic

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let queue = NSOperationQueue()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "hasStyle")
        
        setupLeanCloudSetting()
        setupOtherLoginPlatformsSetting()
        return true
    }

    func applicationWillTerminate(application: UIApplication) {

    }
}

extension AppDelegate {
    private func setupLeanCloudSetting() {
         AVOSCloud.setApplicationId(iReadConfigure.leancloudAppID, clientKey: iReadConfigure.leancloudAppKey)
        
        Reader.registerSubclass()
        FeedItem2.registerSubclass()
        Article.registerSubclass()
        
    }
    
    private func setupOtherLoginPlatformsSetting() {
        AVOSCloudSNS.setupPlatform(.SNSQQ, withAppKey: iReadConfigure.QQAccount.appID, andAppSecret: iReadConfigure.QQAccount.appKey, andRedirectURI: iReadConfigure.QQAccount.redirectURL)
        AVOSCloudSNS.setupPlatform(.SNSSinaWeibo, withAppKey: iReadConfigure.WeiboAccount.appID, andAppSecret: iReadConfigure.WeiboAccount.appKey, andRedirectURI: iReadConfigure.WeiboAccount.redirectURL)
        AVOSCloudSNS.setupPlatform(.SNSWeiXin, withAppKey: iReadConfigure.WeChatAccount.appID, andAppSecret: iReadConfigure.WeChatAccount.appKey, andRedirectURI: iReadConfigure.WeChatAccount.redirectURL)
    }
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        return AVOSCloudSNS.handleOpenURL(url)
    }
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        return AVOSCloudSNS.handleOpenURL(url)
    }
    
    func application(app: UIApplication, openURL url: NSURL, options: [String : AnyObject]) -> Bool {
        return AVOSCloudSNS.handleOpenURL(url)
    }
}

