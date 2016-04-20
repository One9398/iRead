//
//  RootNavigationController.swift
//  iRead
//
//  Created by Simon on 16/3/7.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class RootNavigationController: UINavigationController {
    
    // MARK: - View Life Cycle ♻️

    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactivePopGestureRecognizer?.delegate = self
        delegate = self
        
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    override func popToRootViewControllerAnimated(animated: Bool) -> [UIViewController]? {
        if animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToRootViewControllerAnimated(animated)
    }
    
    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {

        return super.popViewControllerAnimated(animated)
    }
    
    override func popToViewController(viewController: UIViewController, animated: Bool) -> [UIViewController]? {
        if animated {
            interactivePopGestureRecognizer?.enabled = false
        }
        
        return super.popToViewController(viewController, animated: false)
    }
    
//    override func preferredStatusBarStyle() -> UIStatusBarStyle {
//        return .LightContent
//    }
    
//    override func childViewControllerForStatusBarStyle() -> UIViewController? {
//        return ArticleViewController()
//    }
    
}

extension RootNavigationController: UINavigationControllerDelegate, UIGestureRecognizerDelegate {
    
    func navigationController(navigationController: UINavigationController, didShowViewController viewController: UIViewController, animated: Bool) {
        
        interactivePopGestureRecognizer?.enabled = false
    }
    
    func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == interactivePopGestureRecognizer {
            if viewControllers.count < 2 || visibleViewController == viewControllers[0] {
                return false;
            }
        }
        
        return true
    }

    
}
