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

extension UIImage {
    
    enum AssetsIdentifier : String {
        case icon_addList_normal
        case icon_addList_selected
        case icon_feeds_count = "icon_feeds_count"
        case icon_baritem_back = "icon_baritem_back"
        case icon_favorite_empty_logo = "icon_favorite_empty_logo"
        case article_toread_placehold = "article_toread_placehold"
        case icon_toread_info_selected = "icon_toread_info_selected"
        case icon_toread_info_normal = "icon_toread_info_normal"
    }
    
    convenience init!(assetsIdentifier: AssetsIdentifier) {
        self.init(named:assetsIdentifier.rawValue)
    }
}