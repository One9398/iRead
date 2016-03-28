//
//  ArticleView.swift
//  iRead
//
//  Created by Simon on 16/3/20.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import WebKit

class ArticleView: WKWebView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
    }

}
