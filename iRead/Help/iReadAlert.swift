//
//  iReadAlert.swift
//  iRead
//
//  Created by Simon on 16/3/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class iReadAlert {
    
    class func showErrorMessage(title title: String, message: String,  dismissTitle: String, inViewController viewController: UIViewController?) -> () {
        
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            alertController.modalPresentationStyle = .None
            let dismissAction = UIAlertAction(title: "确认", style: .Default, handler: nil)
            alertController.addAction(dismissAction)
            viewController!.modalInPopover = false
 
            viewController?.presentViewController(alertController, animated: true, completion: nil)
            
        })
        
    }
    
    class func showInfoMessage(title title: String, message: String, dismissTitle: String, inViewController viewController: UIViewController, withDoneAction doneAction: (() -> Void)?, DismissAction dismissAction:  (() -> Void)?) {
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)

            if !iReadHelp.currentDeviceIsPhone() {
                alertController.modalPresentationStyle = .OverCurrentContext
                alertController.popoverPresentationController?.sourceView = viewController.view

                alertController.popoverPresentationController?.permittedArrowDirections = .Any
                
                for view in viewController.view.subviews {
                    if view is ArticleView {
                        let articleView = view as! ArticleView
                        alertController.popoverPresentationController?.sourceRect = CGRectMake(articleView.touchPoint.x, articleView.touchPoint.y , 1, 1)
                    }
                }
                /*
                for (UIView *view in myWebView.subviews)
                {
                if ([view isKindOfClass:[UIScrollView class]])
                {
                // Get UIScrollView object
                scrollview = (UIScrollView *) view;
                
                // Find the zoom and scroll offsets
                float zoom = scrollView.zoomScale;
                float xOffset = scrollView.contentOffset.x;
                float yOffset = scrollView.contentOffset.y;
                }
                }
*/
                
                alertController.popoverPresentationController?.permittedArrowDirections = .Any
            }
            
            let dismiss = UIAlertAction(title: "返回", style: .Default, handler: {
                action -> Void in
                dismissAction?()
            })
            
            let done = UIAlertAction(title: "前往", style: .Default, handler: {
                action -> Void in
                doneAction?()
            })
            

            alertController.addAction(done)

            alertController.addAction(dismiss)
            viewController.modalInPopover = false
 
            viewController.presentViewController(alertController, animated: true, completion: nil)

        })
    }
    
    class func showErrorMessage(title title: String, message: String,  dismissTitle: String, inViewController viewController: UIViewController?, withDismissAction dismissAction: () -> Void) -> () {
        
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "确认", style: .Default) { action -> Void in
                dismissAction()
                
            }
            
            alertController.addAction(dismissAction)
            viewController!.modalInPopover = false
 
            viewController?.presentViewController(alertController, animated: true, completion: nil)
            
        })
        
    }
    
    class func showFeedInput(title title: String, placeholder: String?, confirmTitle: String?, dismissTitle: String, inViewController viewController: UIViewController?, withFinishedAction finishedAction: ((text: String) -> Void)?) {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            let alertController = UIAlertController(title: title, message: nil, preferredStyle: .Alert)
            
            alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
                textField.placeholder = placeholder
            }
            
            let action: UIAlertAction = UIAlertAction(title: dismissTitle, style: .Destructive) { action -> Void in
            }
            
            let action2: UIAlertAction = UIAlertAction(title: confirmTitle, style: .Default) { action -> Void in
                if let finishedAction = finishedAction {
                    if let textField = alertController.textFields?.first, text = textField.text {
                        finishedAction(text: text)
                    }
                }
            }
            
            alertController.addAction(action)
            alertController.addAction(action2)
            viewController!.modalInPopover = false

            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
  
}