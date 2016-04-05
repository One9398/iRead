//
//  RecommandCardView.swift
//  iRead
//
//  Created by Simon on 16/3/28.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

protocol RecommandCardViewDelegate : NSObjectProtocol {
    
    func recommandCardViewRefreshButtonClicked(button: BaseButton)
    
    func recommandCardViewPlusButtonClicked(button: BaseButton)
    
    func recommandCardViewReducettonClicked(button: BaseButton)
}

class RecommandCardView: BaseCardView {

    
    weak var eventDelegate: RecommandCardViewDelegate?
    
    
    convenience init(detailView: UIView) {
       
        self.init(frame: CGRectNull)
        
        self.pulseColor = nil
        self.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
        self.divider = false
        self.cornerRadiusPreset = .Radius1
        self.contentInsetPreset = .Square1
        self.leftButtonsInsetPreset = .Square1
        self.rightButtonsInsetPreset = .Square1
        self.depth = .Depth2
        self.detailView = detailView
        self.detailView?.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
        
        let refreshButton = BaseButton.createButton("icon_refresh_highlight", highlightImg: "icon_refresh_normal", target: self, action: "refreshButtonClicked:")
        self.leftButtons = [refreshButton]
        
        let plusButton = BaseButton.createButton("icon_add_highlight", highlightImg: "icon_add_normal", target: self, action: "plusButtonClicked:")
        let reduceButton = BaseButton.createButton("reduce_icon_highlight", highlightImg: "reduce_icon_noralma", target: self, action: "reduceButtonClicked:")
        
        self.rightButtons = [plusButton, reduceButton]
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        MaterialLayout.alignToParent(superview!, child: self, left: iReadConstant.RecommendCardView.leftDis, right: iReadConstant.RecommendCardView.rightDis, top: iReadConstant.RecommendCardView.topDis, bottom: iReadConstant.RecommendCardView.bottomDis)
    }

}


extension RecommandCardView {
    func reduceButtonClicked(sender: BaseButton) {

        self.eventDelegate?.recommandCardViewReducettonClicked(sender)
    }
    
    func plusButtonClicked(sender: BaseButton) {

        self.eventDelegate?.recommandCardViewPlusButtonClicked(sender)

    }
    
    func refreshButtonClicked(sender: BaseButton) {

        self.eventDelegate?.recommandCardViewRefreshButtonClicked(sender)
    }
    
}


