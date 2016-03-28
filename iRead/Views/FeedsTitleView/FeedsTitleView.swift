//
//  FeedsTitleView.swift
//  iRead
//
//  Created by Simon on 16/3/25.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import DGRunkeeperSwitch

protocol FeedsTitleViewDelegate : NSObjectProtocol {
    func titleViewDidChangeSelected(sender: FeedsTitleView, isLeft: Bool)
}

class FeedsTitleView: DGRunkeeperSwitch {

    weak var delegate : FeedsTitleViewDelegate?
    override init(leftTitle: String!, rightTitle: String!) {
        super.init(leftTitle: leftTitle, rightTitle: rightTitle)
        

        self.selectedBackgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeBlueColor, nightColor: iReadColor.themeBlackColor)
        self.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlueColor)
        self.titleColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlueColor, nightColor: iReadColor.themeLightWhiteColor)
        self.selectedTitleColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlueColor)
        
        self.titleFont = iReadFont.medium
        
        self.frame = CGRect(x: 30.0, y: 40.0, width: 200.0, height: 30.0)
        self.addTarget(self, action: Selector("switchValueDidChange:"), forControlEvents: .ValueChanged)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func switchValueDidChange(sender: FeedsTitleView) {
        print("valueChanged: \(sender.selectedIndex)")
        delegate?.titleViewDidChangeSelected(sender, isLeft: sender.selectedIndex == 0 ? true : false)
    }

    
}
