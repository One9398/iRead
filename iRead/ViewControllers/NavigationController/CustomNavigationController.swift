//
//  CustomNavigationController.swift
//  iRead
//
//  Created by Simon on 16/3/9.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class CustomNavigationController: RootNavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    // 让子控制器自己决定方向 http://stackoverflow.com/questions/12520030/how-to-force-a-uiviewcontroller-to-portait-orientation-in-ios-6?lq=1
    override func shouldAutorotate() -> Bool {
        return self.viewControllers.last?.shouldAutorotate() ?? true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.viewControllers.last?.supportedInterfaceOrientations() ?? .Portrait
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return self.viewControllers.last?.preferredInterfaceOrientationForPresentation() ?? .Portrait
    }
    
    
}
