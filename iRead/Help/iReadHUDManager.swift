//
//  iReadHUDManager.swift
//  iRead
//
//  Created by Simon on 16/4/21.
//  Copyright © 2016年 Simon. All rights reserved.
//

import SVProgressHUD

struct HUDManager {
    static let sharedManager = HUDManager()
    
    init() {
        SVProgressHUD.setFont(iReadFont.regualWithSize(14))
        SVProgressHUD.setForegroundColor(iReadColor.themeBlueColor)
        SVProgressHUD.setBackgroundColor(iReadColor.themeLightWhiteColor)
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setDefaultMaskType(.Clear)
        SVProgressHUD.setMinimumDismissTimeInterval(1.0)
        SVProgressHUD.setRingThickness(4)
    }
    
    func showupErrorMessage(message: String) {
        SVProgressHUD.showErrorWithStatus(message)
    }
    
    func showupSuccessMessage(message: String) {
        SVProgressHUD.showSuccessWithStatus(message)
    }
    
    func showupInfoMessage(message: String) {
        SVProgressHUD.showInfoWithStatus(message)
    }
    
     func showLoadingIndictor() {
        SVProgressHUD.show()
    }
    
    func hideCurrentHUDWithDuration(duration: NSTimeInterval = 0) {
        SVProgressHUD.dismissWithDelay(duration)
    }
    
}

extension UIViewController {
    
    func showupTopInfoMessage(message: String) {
        noticeTop(message, autoClear: true, autoClearTime: 1)
    }
    func showupErrorMessage(message: String) {
        HUDManager.sharedManager.showupSuccessMessage(message)
    }
    
    func showupSuccessMessage(message: String) {
        HUDManager.sharedManager.showupSuccessMessage(message)
    }
    
    func showupInfoMessage(message: String) {
        HUDManager.sharedManager.showupInfoMessage(message)
    }
    
}