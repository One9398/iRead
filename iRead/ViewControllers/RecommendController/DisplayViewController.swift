//
//  DisplayViewController.swift
//  iRead
//
//  Created by Simon on 16/3/9.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class DisplayViewController: YZDisplayViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        prepareForNavigationBar()
        prepareForHeaderView()
        
        configureChildViewControllers()
        
        print(navigationController)
        print("rootController: \(UIApplication.sharedApplication().delegate?.window!!.rootViewController)");
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Preparation 📱

    private func prepareForNavigationBar() {
        
        let titleLabel = UILabel()
        titleLabel.font = iReadFont.boldWithSize(18)
        titleLabel.text = "精选"
        titleLabel.sizeToFit()
        titleLabel.textColor = iReadColor.themeWhiteColor
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.barStyle = .Black
        navigationController!.navigationBar.setBackgroundImage(UIImage(named: "navigationbar_bg_recommand"), forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = UIImage()        
    }

    private func prepareForHeaderView() {

        isShowUnderLine = true
        underLineColor = iReadColor.themeRedColor
        norColor = iReadColor.themeWhiteColor
        selColor = iReadColor.themeRedColor
        titleScrollViewBackgroundImageView = UIImageView(image: UIImage(named: "header_bg_recommand"))
        titleFont = iReadFont.thinWithSize(12)
        underLineH = 2
    }
    private func configureChildViewControllers() {
        let viewControllerA1 = ViewControllerA()
        viewControllerA1.title = "科技见闻"
        addChildViewController(viewControllerA1)

        let viewControllerB1 = ViewControllerB()
        viewControllerB1.title = "信息技术"
        addChildViewController(viewControllerB1)

        let viewControllerA2 = ViewControllerA()
        viewControllerA2.title = "生活健康"
        addChildViewController(viewControllerA2)

        let viewControllerB2 = ViewControllerB()
        viewControllerB2.title = "艺术文学"
        addChildViewController(viewControllerB2)
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

}
