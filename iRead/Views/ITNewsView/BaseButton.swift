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
    convenience init(normalImg: String, highlightImg: String, target:  AnyObject?, action: Selector) {

        self.init()

        self.setImage(UIImage(named: normalImg), forState: .Normal)
        self.setImage(UIImage(named: highlightImg), forState: .Highlighted)
        self.pulseScale = false
        self.pulseColor = iReadColor.themeLightBlueColor

        self.addTarget(target, action: action, forControlEvents: .TouchDown)
    }
}
