//
//  iReadHelp.swift
//  iRead
//
//  Created by Simon on 16/3/8.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

public struct iReadColor {
    public static let themeBlueColor = UIColor(red: 66/255.0, green: 190/255.0, blue: 252/255.0, alpha: 1.0)
    public static let themeClearColor = UIColor.clearColor()
    public static let themeWhiteColor = UIColor(red: 247/255.0, green: 247/255.0, blue: 247/255.0, alpha: 1.0)
    public static let themeLightBlueColor = MaterialColor.blue.lighten3
    public static let themeLightGrayColor = UIColor(red: 176/255.0, green: 190/255.0, blue: 197/255.0, alpha: 1.0)
    
    public static let themeLightBlackColor = UIColor(red: 46/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1.0)
    
    public static let themeDarkBlueColor = UIColor(red: 2/255.0, green: 119/255.0, blue: 189/255.0, alpha: 1.0)
    
    public static let themeRedColor = UIColor(red: 253/255.0, green: 91/255.0, blue: 107/255.0, alpha: 1.0)
    
    public static let themeBlackColor = UIColor(red: 25/255.0, green: 25/255.0, blue: 25/255.0, alpha: 1.0)
    
    public static let themeGrayColor = UIColor(red: 238/255.0, green: 238/255.0, blue: 238/255.0, alpha: 1.0)
    
    public static let themeDarkGrayColor = MaterialColor.grey.darken1

    public static let themeLightWhiteColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    
    public static func themeModelTinColor(dayColor dayColor: UIColor, nightColor: UIColor) -> UIColor {
        return iReadTheme.isNightMode() ? nightColor : dayColor
    }
    
    public static func themeModelBackgroundColor(dayColor dayColor: UIColor, nightColor: UIColor) -> UIColor {
        return iReadTheme.isNightMode() ? nightColor : dayColor
    }
}

public struct iReadFont {
    
    //: 默认Size 16
    
    public static let thin = RobotoFont.thin
    public static func thinWithSize(size: CGFloat) -> UIFont {
        return RobotoFont.thinWithSize(size)
    }
    
    public static let medium = RobotoFont.medium
    public static func mediumWithSize(size: CGFloat) -> UIFont {
        return RobotoFont.mediumWithSize(size)
    }
    
    public static let light = RobotoFont.light
    public static func lightWithSize(size: CGFloat) -> UIFont {
        return RobotoFont.lightWithSize(size)
    }
    
    public static let regual = RobotoFont.regular
    public static func regualWithSize(size: CGFloat) -> UIFont {
        return RobotoFont.regularWithSize(size)
    }
    
    public static let bold = RobotoFont.bold
    public static func boldWithSize(size: CGFloat) -> UIFont {
        return RobotoFont.boldWithSize(size)
    }
    
}

enum iReadThemeMode: String {
    case NightMode = "NightMode"
    case DayMode = "DayMode"
}

struct iReadTheme {
    static func getCurrentThemeMode() -> iReadThemeMode {
        
        return NSUserDefaults.standardUserDefaults().boolForKey("NightMode") ? .NightMode : .DayMode
    }
    
    static func isNightMode() -> Bool {
//            return true
            return NSUserDefaults.standardUserDefaults().boolForKey("NightMode")

    }
    
    static func isDayMode() -> Bool {
        //            return true
        return !NSUserDefaults.standardUserDefaults().boolForKey("NightMode")
    }
    
    static func changeThemeMode() {
        let mode = NSUserDefaults.standardUserDefaults().boolForKey("NightMode")
        NSUserDefaults.standardUserDefaults().setBool(!mode, forKey: "NightMode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
}

struct iReadHelp {
    static func currentDeviceIsPhone() -> Bool {
        
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return true
        }
        
        return false
    }
    
}

// Block延时执行,允许主动停止
typealias CancelableBlock = (cancel: Bool) -> Void

func delayTaskExectuing(intervalTime: NSTimeInterval, block: dispatch_block_t) -> CancelableBlock? {
    var resultBlock: CancelableBlock?
    
    let cancelableBlock: CancelableBlock = {
        (cancel: Bool) in
        if cancel {
            resultBlock = nil
        } else {
            dispatch_async(dispatch_get_main_queue(), block)
        }
    }
    
    resultBlock = cancelableBlock
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(intervalTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        if let resultBlock = resultBlock {
            resultBlock(cancel: false)
        }
    }
    
    return resultBlock
    
}

func cancleTaskExecuting(cancelableBlock: CancelableBlock?) {
    cancelableBlock?(cancel: true)
}


