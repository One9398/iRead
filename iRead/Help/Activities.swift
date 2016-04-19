//
//  Activities.swift
//  iRead
//
//  Created by Simon on 16/4/19.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import MonkeyKing

class WeChatActivity: AnyActivity {
    
    enum Type {
        
        case Session
        case Timeline
        
        var type: String {
            switch self {
            case .Session:
                return iReadConfigure.WeChatAccount.sessionType
            case .Timeline:
                return iReadConfigure.WeChatAccount.timelineType
            }
        }
        
        var title: String {
            switch self {
            case .Session:
                return iReadConfigure.WeChatAccount.sessionTitle
            case .Timeline:
                return iReadConfigure.WeChatAccount.timelineTitle
            }
        }
        
        var image: UIImage {
            switch self {
            case .Session:
                return iReadConfigure.WeChatAccount.sessionImage
            case .Timeline:
                return iReadConfigure.WeChatAccount.timelineImage
            }
        }
        
    }
    
    init(type: Type, message: MonkeyKing.Message, finish:  MonkeyKing.SharedCompletionHandler) {
        MonkeyKing.registerAccount(.WeChat(appID: iReadConfigure.WeChatAccount.appID, appKey: iReadConfigure.WeChatAccount.appKey))
        
        super.init(
            type: type.type,
            title: type.title,
            image: type.image,
            message: message,
            completionHandler: finish
        )
    }
}