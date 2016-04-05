//
//  iReadExtension.swift
//  iRead
//
//  Created by Simon on 16/3/31.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

extension UIColor {
    class func RGBColor(rgb: Int) -> UIColor {
        return UIColor(red: CGFloat((rgb & 0xFF0000 >> 16)) / 255.0, green: CGFloat((rgb & 0x00FF00 >> 8)) / 255.0, blue: CGFloat((rgb & 0x0000FF))/255.0, alpha: 1.0)
    }
}