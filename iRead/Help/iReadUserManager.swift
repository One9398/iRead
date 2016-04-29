//
//  iReadUserManager.swift
//  iRead
//
//  Created by Simon on 16/3/24.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation
//import AVOSCloud

let AccessTokenKey = "AccessToken"
let NicknameKey = "Nickname"
let ReadTimeIntervalKey = "readTime"
let ReadCountsKey = "readCounts"
let ArticlesCountsKey = "ArticleCounts"
let ReadModeKey = "readMode"
let NeedReadModeKey = "NeedReadModeKey"
let ThemeModeKey = "themeMode"
let UserDictionaryKey = "UserDictionary"
let UsernameKey = "username"
let AvatarURLKey = "avatar_url"
let TokenKey = "access_token"


class iReadUserDefaults {
    static let defaults = NSUserDefaults.standardUserDefaults()
    
    static var currentUser: Reader? {
        
        guard let reader = Reader.currentUser() else {
            return nil
        }
        
        reader.fetchWhenSave = true
        return reader
        
    }
    
    static var isLogined: Bool {
        if Reader.currentUser() != nil {
            return true
        } else {
            return false
        }
    }
    
    static func resetUserDefaults() {
        iReadUserDefaults.updateAvatorIconURLString("")

        iReadUserDefaults.defaults.setInteger(0, forKey: ReadTimeIntervalKey)
        iReadUserDefaults.defaults.setInteger(0, forKey: ReadCountsKey)
        iReadUserDefaults.defaults.setBool(false, forKey: ReadModeKey)
        iReadUserDefaults.defaults.setBool(false, forKey: ThemeModeKey)
        iReadUserDefaults.saveCurrentPlatformUserDictionary()
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
    
    static func avatarIconURLString() -> String {
        return iReadUserDefaults.defaults.stringForKey(AvatarURLKey) ?? ""
    }
    
    static func updateAvatorIconURLString(urlString: String) {
        iReadUserDefaults.defaults.setObject(urlString, forKey:AvatarURLKey)
        iReadUserDefaults.defaults.synchronize()
    }
    
    static func updateReadTime(timeInterval: NSTimeInterval) {
        
        let oldTimeInterval = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey)
        let newTimeInterval = oldTimeInterval + Int(timeInterval)
        iReadUserDefaults.defaults.setInteger(newTimeInterval, forKey: ReadTimeIntervalKey)
        saveUserDataEventuallyWithObjectWhileUserOn(newTimeInterval, key: ReadTimeIntervalKey)
        
    }
    
    static func totalReadTimesString() -> String {
        var readTimes: Int
        if iReadUserDefaults.isLogined {
            readTimes = currentUser!.readTime
            iReadUserDefaults.defaults.setInteger(currentUser!.readTime, forKey: ReadTimeIntervalKey)
        } else {
            readTimes = iReadUserDefaults.defaults.integerForKey(ReadTimeIntervalKey)
        }
        
        let hour = readTimes / 3600
        let min = readTimes / 60
        return "\(hour)时\(min)分"
    }
    
    static func updateReadCounts(counts:Int = 1) {
       
        let oldCounts = iReadUserDefaults.defaults.integerForKey(ReadCountsKey)
        let newCounts = oldCounts + counts
        iReadUserDefaults.defaults.setInteger(newCounts, forKey: ReadCountsKey)
        
        saveUserDataEventuallyWithObjectWhileUserOn(newCounts, key: ReadCountsKey)
    }
    
    static func totalReadCountsString() -> String {
        if iReadUserDefaults.isLogined {
            iReadUserDefaults.defaults.setInteger(currentUser!.readCounts, forKey: ReadCountsKey)
            print(currentUser?.readCounts)
            return "\(currentUser!.readCounts)篇"
        } else {
            let counts =  iReadUserDefaults.defaults.integerForKey(ReadCountsKey)
            return "\(counts)篇"
        }
    }
    
    static var isReadModeOn : Bool {
        if iReadUserDefaults.isLogined {
            iReadUserDefaults.defaults.setBool(currentUser!.readMode, forKey: ReadModeKey)
            return currentUser!.readMode
        } else {
            return iReadUserDefaults.defaults.boolForKey(ReadModeKey)
        }
    }
    
    static var changeReadMode: Bool {
        return iReadUserDefaults.defaults.boolForKey(NeedReadModeKey)
    }
    
    static func setNeedReadModeFlag () {
        let need = iReadUserDefaults.defaults.boolForKey(NeedReadModeKey)
        iReadUserDefaults.defaults.setBool(!need, forKey: NeedReadModeKey)
    }
    
    static func updateReadMode() {
        updateModeWithKey(ReadModeKey)
    }
    
    static var isThemeModeOn : Bool {
       
        if iReadUserDefaults.isLogined {

            iReadUserDefaults.defaults.setBool(currentUser!.themeMode, forKey: ThemeModeKey)
            return currentUser!.themeMode
        } else {
            return iReadUserDefaults.defaults.boolForKey(ThemeModeKey)
        }
        
    }
    
    static func updateThemeMode() {
        updateModeWithKey(ThemeModeKey)
    }
    
    private static func updateModeWithKey(key: String) {
        
        let oldMode = iReadUserDefaults.defaults.boolForKey(key)
        let newMode = !oldMode
        iReadUserDefaults.defaults.setBool(newMode, forKey: key)
        saveUserDataEventuallyWithObjectWhileUserOn(newMode, key: key)
        
    }
    
    static func saveUserDataEventuallyWithObjectWhileUserOn(object: AnyObject!, key: String) {
        
        if iReadUserDefaults.isLogined {
            currentUser?.setObject(object, forKey: key)
            currentUser?.saveInBackgroundWithBlock{
                result,error in
                if error != nil {
                    assertionFailure(error.localizedDescription)
                } else {
                    print("save done")
                }
            }
        }

    }
}