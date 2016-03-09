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
    
    override func viewDidLoad() {

        delegate = self
        prepareForTabbar()
        
    }
    
    // MARK: - UI Preparation 📱

    private func prepareForTabbar() {
        tabBar.backgroundColor = iReadColor.themeWhiteColor
        tabBar.tintColor = iReadColor.themeBlueColor
        tabBar.itemPositioning = .Fill
        tabBar.shadowImage = UIImage()
        tabBar.backgroundImage = UIImage()
    }
    
    override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return DisplayViewController()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
}

extension RootTabbarController: UITabBarControllerDelegate {
    
}
