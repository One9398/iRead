//
//  iReadUserManager.swift
//  iRead
//
//  Created by Simon on 16/3/24.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

struct iReadUserManager {
    
}

struct Listener<T> : Hashable {
    let name: String
    typealias Action = T -> Void
    let action: Action
    var hashValue: Int {
        return name.hash
    }
    
}

func ==<T>(lhs: Listener<T>, rhs: Listener<T>) -> Bool {
    return lhs.name == rhs.name
}

class Listenable<T> {
    typealias SetterAction = T -> Void
    var setterAction: SetterAction
    var listenerSet = Set<Listener<T>>()
    
    var value: T {
        didSet {
            setterAction(value)
            
            for listen in listenerSet {
                listen.action(value)
            }
        }
    }
    
    init(value: T, setterAction: SetterAction) {

        self.value = value
        self.setterAction = setterAction
        
    }
    
    func bindListener(name: String, action: Listener<T>.Action) {
        let listener = Listener(name: name, action: action)
        listenerSet.insert(listener)
    }
    
    func fireListener(name: String, action: Listener<T>.Action) {
        bindListener(name, action: action)
        action(value)
    }
    
    func removeListener(name: String) {
        for listener in listenerSet {
            if listener.name == name {
                listenerSet.remove(listener)
                break;
            }
        }
    }
}

let AccessTokenKey = "AccessToken"
let AvaterURLStringKey = "AvaterURLString"
let NicknameKey = "Nickname"
let ReadTimesKey = "ReadTimes"
let ReadTimeIntervalKey = "ReadTimeInterval"
let ReadCountsKey = "ReadCounts"
let ArticlesCountsKey = "ArticleCounts"
let ReadModeKey = "ReadMode"
let ThemeModeKey = "KeyMode"

class iReadUserDefaults {
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static var isLogined: Bool {
        if let _ = accessToken.value {
            return true
        } else {
            return false
        }
    }
    
    static var accessToken: Listenable<String?> {
        let token = defaults.stringForKey(AccessTokenKey)
        return Listenable<String?>(value: token) {
            accessToken in
            
            defaults.setObject(accessToken, forKey: AccessTokenKey)
            if let _ = UIApplication.sharedApplication().delegate as? AppDelegate {
                
            }
        }
    }
    
    static var avatarURLString: Listenable<String?> = {
        let URLString = defaults.stringForKey(AvaterURLStringKey)
        return Listenable<String?>(value: URLString) {
            avaterURLString in
            defaults.setObject(avaterURLString, forKey: AvaterURLStringKey)
            
        }
    }()
    
    static var nickname: Listenable<String?> = {
        let name = defaults.stringForKey(NicknameKey)
        return Listenable<String?>(value: name) {
            nickname in
            defaults.setObject(nickname, forKey: NicknameKey)
        }
    }()
    
    static var readtimes: Listenable<String?> = {
        let times = defaults.stringForKey(ReadTimesKey)
        return Listenable<String?>(value: times) {
            readtimes in
            defaults.setObject(readtimes, forKey: ReadTimesKey)
        }
        
    }()
   
    static var articleCounts: Listenable<String?> = {
        let counts = defaults.stringForKey(ArticlesCountsKey)
        return Listenable<String?>(value: counts) {
            articlesCounts in
            defaults.setObject(articlesCounts, forKey: ArticlesCountsKey)
        }
    }()
    
    static func updateReadTime(timeInterval: NSTimeInterval) {
        let oldTimeInterval = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey) 
        let newTimeInterval = oldTimeInterval + Int(timeInterval)
        
        iReadUserDefaults.defaults.setInteger(newTimeInterval, forKey: ReadTimeIntervalKey)
        iReadUserDefaults.defaults.synchronize()
    }
    
    static func totalReadTimesString() -> String {
        let readTimes = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey)
        let hour = readTimes / 3600
        let min = readTimes / 60
       return "\(hour)时\(min)分"
    }
    
    static func avaterIconURLString() -> String {
        let urlString = iReadUserDefaults.defaults.stringForKey(AvaterURLStringKey)
        return urlString ?? ""
    }
    
    static func updateAvatorIconURLString(urlString: String) {
        iReadUserDefaults.defaults.setObject(urlString, forKey: AvaterURLStringKey)
        iReadUserDefaults.defaults.synchronize()
    }
    
    static func updateReadCounts(counts:Int) {
        let oldCounts = iReadUserDefaults.defaults.integerForKey(ReadCountsKey)
        let newCounts = oldCounts + counts
        iReadUserDefaults.defaults.setInteger(newCounts, forKey: ReadCountsKey)
        iReadUserDefaults.defaults.synchronize()
    }
    
    static func totalReadCountsString() -> String {
        let counts =  iReadUserDefaults.defaults.integerForKey(ReadCountsKey)
        return "\(counts)篇"
    }
    
    static var isReadModeOn : Bool {
        return iReadUserDefaults.defaults.boolForKey(ReadModeKey)
    }
    static func updateReadMode() {
        updateModeWithKey(ReadModeKey)
    }
    
    static var isThemeModeOn : Bool {
        return iReadUserDefaults.defaults.boolForKey(ThemeModeKey)
    }
    static func updateThemeMode() {
        updateModeWithKey(ThemeModeKey)
    }
    
    private static func updateModeWithKey(key: String) {
        let oldMode = iReadUserDefaults.defaults.boolForKey(key)
        iReadUserDefaults.defaults.setBool(!oldMode, forKey: key)
    }
    
}