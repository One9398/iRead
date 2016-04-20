//
//  iReadConstant.swift
//  iRead
//
//  Created by Simon on 16/3/18.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

enum iReadConstant {
    static let appidgroup = "group.simon.iread"
    struct ArticleView {
        static let contentMargin: CGFloat = 15.0
    }
    
    struct ScreenSize {
        static let width = UIScreen.mainScreen().bounds.width
        static let hight = UIScreen.mainScreen().bounds.height
    }
    
    struct TopBar {
        static let height = 64
        
    }
    
    struct MenuView {
        static let width: CGFloat = 48
        static let height: CGFloat = 48
        static let menuInset: CGFloat = 20.0
        
    }
    
    struct SwitchView {
        static let switchInset: CGFloat = 5.0
    }
    
    struct RecommendCardView {
        static let topDis: CGFloat = 20.0
        static let bottomDis: CGFloat = 64.0
        static let rightDis: CGFloat = 20
        static let leftDis: CGFloat = 20
    }

    struct EmptyView {
        static let verticalOffset: CGFloat = -10
        static let spaceHeight: CGFloat = 20
        
    }
    
    struct ProfileView {
        static let height = 140
        static let imageHeight = 100
        static let bottomMargin : CGFloat = 20
    }
    
    struct ProfileTabel {
        static let ProfileCellHeight: CGFloat = 40.0
        
    }
    
    struct ProfileSettingCell {
        static let lineHeight = 1
    }
    
    struct RecommendTable {
        static let heightForCell: CGFloat = 80
        
    }
    
    struct ThumbnailImage {
        static let width = 100
        static let height = 100
    }
}
