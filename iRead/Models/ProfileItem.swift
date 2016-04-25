//
//  ProfileItem.swift
//  iRead
//
//  Created by Simon on 16/4/14.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

class ProfileGroup {
    var headerTitle = ""
    var footerTitle = ""
    var items: [ProfileItem]
    
    init(headerTitle: String, footerTitle: String, items: [ProfileItem]) {
        self.headerTitle = headerTitle
        self.footerTitle = footerTitle
        self.items = items
    }
}

class ProfileItem {
    var title: String  = ""
    var subTitle: String = ""
    var selectedAction: (()->())?
    var showSwitch: Bool = false
    var switchAction: ((Bool)->())?
    var icon : String = ""
    var isOn = false
    
    init (title: String = "", icon: String = "", showSwitch: Bool = false, selectedAction: (()->())?){
        self.title = title
        self.icon = icon
        self.showSwitch = showSwitch
        self.selectedAction = selectedAction
    }
    
    init (title: String = "", subTitle: String, icon: String = "",selectedAction: (()->())?){
        self.title = title
        self.subTitle = subTitle
        self.icon = icon
        self.selectedAction = selectedAction
    }

    convenience init(title: String, icon: String, selectedAction: (()->())) {
        self.init(title: title, icon: icon, showSwitch: false, selectedAction: selectedAction)
    }
    
    init(title: String,icon: String, showSwitch: Bool, switchAction: ((Bool)->())?) {
        self.title = title
        self.icon = icon
        self.showSwitch = showSwitch
        self.switchAction = switchAction
    }
}