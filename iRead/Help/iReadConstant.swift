//
//  iReadConstant.swift
//  iRead
//
//  Created by Simon on 16/3/18.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

enum iReadConstant {
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
}
