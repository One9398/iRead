//
//  BaseButton.swift
//  iRead
//
//  Created by Simon on 16/3/14.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class BaseButton: FlatButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func createButton(normalImg: String, highlightImg: String,  target: AnyObject, action: Selector) -> BaseButton {
        let button = BaseButton(frame: CGRectZero)
        
            button.setImage(UIImage(named: normalImg), forState: .Normal)
            button.setImage(UIImage(named: highlightImg), forState: .Highlighted)
            button.pulseScale = false
            button.pulseColor = iReadColor.themeLightBlueColor
            button.addTarget(target, action: action, forControlEvents: .TouchDown)
        
        return button
    }
    
}
