//
//  ArticleView.swift
//  iRead
//
//  Created by Simon on 16/3/20.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import WebKit

public class ArticleView: WKWebView {
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    public private (set) var touchPoint = CGPointZero
    
    override init(frame: CGRect, configuration: WKWebViewConfiguration) {
        super.init(frame: frame, configuration: configuration)
        
        let tap = UITapGestureRecognizer(target: self, action: "tapTest:")
        tap.delegate = self
        self.scrollView.addGestureRecognizer(tap)
    }
    
    
    func tapTest(recognizer: UITapGestureRecognizer) {
        touchPoint = CGPointMake(recognizer.locationInView(self).x, recognizer.locationInView(self).y)
    }

}

extension ArticleView : UIGestureRecognizerDelegate {
    public func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
        
    }
}