//
//  iReadUserManager.swift
//  iRead
//
//  Created by Simon on 16/3/24.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

//struct iReadUserManager {
//    
//}
//
//struct Listener<T> : Hashable {
//    let name: String
//    typealias Action = T -> Void
//    let action: Action
//    var hashValue: Int {
//        return name.hash
//    }
//    
//}
//
//func ==<T>(lhs: Listener<T>, rhs: Listener<T>) -> Bool {
//    return lhs.name == rhs.name
//}
//
//class Listenable<T> {
//    typealias SetterAction = T -> Void
//    var setterAction: SetterAction
//    var listenerSet = Set<Listener<T>>()
//    
//    var value: T {
//        didSet {
//            setterAction(value)
//            
//            for listen in listenerSet {
//                listen.action(value)
//            }
//        }
//    }
//    
//    init(value: T, setterAction: SetterAction) {
//
//        self.value = value
//        self.setterAction = setterAction
//        
//    }
//    
//    func bindListener(name: String, action: Listener<T>.Action) {
//        let listener = Listener(name: name, action: action)
//        listenerSet.insert(listener)
//    }
//    
//    func fireListener(name: String, action: Listener<T>.Action) {
//        bindListener(name, action: action)
//        action(value)
//    }
//    
//    func removeListener(name: String) {
//        for listener in listenerSet {
//            if listener.name == name {
//                listenerSet.remove(listener)
//                break;
//            }
//        }
//    }
//}

import AVOSCloud

let AccessTokenKey = "AccessToken"
let AvatarURLStringKey = "AvatarURLString"
let NicknameKey = "Nickname"
let ReadTimeIntervalKey = "ReadTimeInterval"
let ReadCountsKey = "ReadCounts"
let ArticlesCountsKey = "ArticleCounts"
let ReadModeKey = "ReadMode"
let ThemeModeKey = "ThemeMode"
let UserDictionaryKey = "UserDictionary"
let UsernameKey = "username"
let AvatarKey = "avatar"
let TokenKey = "access_token"

typealias Failure = (NSError-> Void)
typealias Success = (Bool -> Void)


//struct iReadBool: BooleanType {
//    boolValue = false
//}

class iReadUserDefaults {
    static let defaults = NSUserDefaults.standardUserDefaults()
    private var failure: Failure?
    private var success: Success?
    
    static var currentUser: Reader {
        return Reader.currentUser()
    }
    
    static var isLogined: Bool {
        if Reader.currentUser() != nil {
            return true
        } else {
            return false
        }
    }
    
    static func saveCurrentPlatformUserDictionary(dict: [String : String] = [:]) {
        iReadUserDefaults.defaults.setObject(dict, forKey: UserDictionaryKey)
        print("current user data cached")
        
    }
    
    struct OtherUserInfo {
        var username = ""
        var avatar = ""
        var token = ""
    }
    
    static func fetchCurrentPlatformUserDictionary() -> OtherUserInfo {
        let userInfo = iReadUserDefaults.defaults.dictionaryForKey(UserDictionaryKey) as! [String : String]
        guard let username = userInfo["username"], avatar = userInfo["avatar"], token = userInfo["token"] else {
            assertionFailure("无法获取第三方用户信息")
            return OtherUserInfo()
        }
        
        return OtherUserInfo(username: username, avatar: avatar, token: token)
    }
    
    static func updateReadTime(timeInterval: NSTimeInterval) {
        let oldTimeInterval = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey) 
        let newTimeInterval = oldTimeInterval + Int(timeInterval)
        
        iReadUserDefaults.defaults.setInteger(newTimeInterval, forKey: ReadTimeIntervalKey)
        iReadUserDefaults.defaults.synchronize()
        
        saveUserDataEventuallyWithObject(newTimeInterval, key: ReadTimeIntervalKey)
        
    }
    
    static func totalReadTimesString() -> String {
        let readTimes = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey)
        let hour = readTimes / 3600
        let min = readTimes / 60
       return "\(hour)时\(min)分"
    }
    
    static func avatarIconURLString() -> String {
        let urlString = iReadUserDefaults.defaults.stringForKey(AvatarURLStringKey)
        return urlString ?? ""
    }
    
    static func updateAvatorIconURLString(urlString: String) {
        iReadUserDefaults.defaults.setObject(urlString, forKey: AvatarURLStringKey)
        iReadUserDefaults.defaults.synchronize()
    }
    
    static func updateReadCounts(counts:Int) {
        let oldCounts = iReadUserDefaults.defaults.integerForKey(ReadCountsKey)
        let newCounts = oldCounts + counts
        iReadUserDefaults.defaults.setInteger(newCounts, forKey: ReadCountsKey)
        iReadUserDefaults.defaults.synchronize()
        
        saveUserDataEventuallyWithObject(newCounts, key: ReadCountsKey)
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
        let newMode = !oldMode
        iReadUserDefaults.defaults.setBool(newMode, forKey: key)
        saveUserDataEventuallyWithObject(newMode, key: key)
    }
    
    static func saveUserDataEventuallyWithObject(object: AnyObject!, key: String) {
        currentUser.setObject(object, forKey: key)
        currentUser.saveEventually()
    }
}