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

class ArtileTopBar: UIView {

    weak var eventHandleDelegate: ArtileTopBarDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureSubButtons()
        updateSubButtons()
    }
    
    @IBOutlet weak var surfButton: BaseButton!
    @IBOutlet weak var backButton: BaseButton!
    private func configureSubButtons() {
        surfButton.pulseColor = iReadColor.themeLightBlueColor
        backButton.pulseColor = iReadColor.themeLightBlueColor

    }
    
    private func updateSubButtons() {
       
        surfButton.tintColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeLightWhiteColor)
        backButton.tintColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeLightWhiteColor)
        
        surfButton.backgroundColor = iReadColor.themeClearColor
        backButton.backgroundColor = iReadColor.themeClearColor
    }
    
    
    func updateArticleTopBarThemeMode(mode: iReadThemeMode = .DayMode) {
        updateSubButtons()
    }

    @IBAction func handleSurfButtonEvent(sender: BaseButton) {
        eventHandleDelegate?.artileTopBarClickedSurfButton(self, surfButton: sender)
    }
    
    @IBAction func handleBackButtonEvent(sender: BaseButton) {
        eventHandleDelegate?.artileTopBarClickedBackButton(self, backButton: sender)
    }

}
