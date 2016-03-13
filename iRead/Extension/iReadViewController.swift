//
//  iReadViewController.swift
//  iRead
//
//  Created by Simon on 16/3/8.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

extension UIViewController {
    func currentDeviceIsPhone() -> Bool {
        
        if traitCollection.userInterfaceIdiom == .Phone {
            return true
        }
        
        return false
    }
}
