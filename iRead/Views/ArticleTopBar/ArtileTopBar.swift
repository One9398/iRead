//
//  ArtileTopBar.swift
//  iRead
//
//  Created by Simon on 16/3/24.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

protocol ArtileTopBarDelegate : NSObjectProtocol {
    
    func artileTopBarClickedBackButton(aritleTopBar: ArtileTopBar,  backButton: BaseButton)
    func artileTopBarClickedSurfButton(arlitleTopBar: ArtileTopBar,  surfButton: BaseButton)
}

enum ArticleStyle : String {
    case Normal
    case Darkness
}

class ArtileTopBar: UIView {

    weak var eventHandleDelegate: ArtileTopBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSubButtons()
        updateSubButtons()
        self.backgroundColor = iReadColor.themeClearColor
        
    }
    
    @IBOutlet weak var surfButton: BaseButton!
    @IBOutlet weak var backButton: BaseButton!
    private func configureSubButtons() {
        surfButton.pulseColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeClearColor)
        backButton.pulseColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeClearColor)
    }
    
    private func updateSubButtons() {
        surfButton.tintColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeGrayColor)
        backButton.tintColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeGrayColor)
        
        surfButton.backgroundColor = iReadColor.themeClearColor
        backButton.backgroundColor = iReadColor.themeClearColor
    }
    
    func changeArticleTopBarStyle(style: ArticleStyle = .Normal) {
        var styleColor = iReadColor.themeClearColor
        switch style {
        case .Darkness:
            styleColor = iReadColor.themeLightWhiteColor
        case .Normal:
            styleColor = iReadColor.themeLightBlueColor
        }
        surfButton.tintColor = styleColor
        backButton.tintColor = styleColor
        
    }

    @IBAction func handleSurfButtonEvent(sender: BaseButton) {
        eventHandleDelegate?.artileTopBarClickedSurfButton(self, surfButton: sender)
    }
    
    @IBAction func handleBackButtonEvent(sender: BaseButton) {
        eventHandleDelegate?.artileTopBarClickedBackButton(self, backButton: sender)
    }

}
