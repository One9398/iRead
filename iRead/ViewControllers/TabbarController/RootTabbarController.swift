//
//  RootTabbarController.swift
//  iRead
//
//  Created by Simon on 16/3/8.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
class RootTabbarController: UITabBarController {
    
    // MARK: - View Life Cycle ♻️
    let RecommandVCType = 0
    let PersonalVCType = 1
    override func viewDidLoad() {

        delegate = self
        prepareForTabbar()
        selectedIndex = iReadUserDefaults.isLogined ? PersonalVCType : RecommandVCType
        print(iReadUserDefaults.isLogined)
        print(selectedIndex)
        
    }
    
    // MARK: - UI Preparation 📱

    private func prepareForTabbar() {
        tabBar.backgroundColor = iReadColor.themeClearColor
        tabBar.tintColor = iReadColor.themeBlueColor
        tabBar.itemPositioning = .Fill
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return RecommendController()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

extension RootTabbarController: UITabBarControllerDelegate {
    
}
