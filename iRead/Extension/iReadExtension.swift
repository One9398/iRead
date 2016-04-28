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
        case icon_sharedLogo = "icon_sharedLogo"
        case icon_cleanup2 = "icon_cleanup2"
        case icon_close = "icon_close"
        case icon_placehold_logo2 = "icon_placehold_logo2"
        case launch_logo = "launch_logo"
    }
    
    convenience init!(assetsIdentifier: AssetsIdentifier) {
        self.init(named:assetsIdentifier.rawValue)
    }
    
    func largestCenteredSquareImage() -> UIImage {
        let scale = self.scale
        
        let originalWidth  = self.size.width * scale
        let originalHeight = self.size.height * scale
        
        let edge: CGFloat
        if originalWidth > originalHeight {
            edge = originalHeight
        } else {
            edge = originalWidth
        }
        
        let posX = (originalWidth  - edge) / 2.0
        let posY = (originalHeight - edge) / 2.0
        
        let cropSquare = CGRectMake(posX, posY, edge, edge)
        
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, cropSquare)!
        
        return UIImage(CGImage: imageRef, scale: scale, orientation: self.imageOrientation)
    }
    
    func resizeToTargetSize(targetSize: CGSize) -> UIImage {
        let size = self.size
        
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        
        let scale = UIScreen.mainScreen().scale
        let newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSizeMake(scale * floor(size.width * heightRatio), scale * floor(size.height * heightRatio))
        } else {
            newSize = CGSizeMake(scale * floor(size.width * widthRatio), scale * floor(size.height * widthRatio))
        }
        
        let rect = CGRectMake(0, 0, floor(newSize.width), floor(newSize.height))
        
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}

extension UIViewController {
    
    func filterShowUpError(error: NSError?) -> Bool{
        if error != nil {
            print("save errror\(error)")
            self.showupTopInfoMessage(error!.localizedDescription)
            return false
        } else {
            return true
        }
    }
    
    func presentLoginViewControllerWhenNoUser(completion:(()->Void)? = nil) {
        
        if iReadUserDefaults.isLogined {
            print("当前用户已存在")
        } else {
            let userViewController  = UIStoryboard(name: "User", bundle: nil).instantiateInitialViewController()
            
            self.presentViewController(userViewController!, animated: true, completion: {
                delayTaskExectuing(0.3, block: {
                    self.showupInfoMessage("请先登录")
                })
                
                completion?()
            })
        }
    }
}

