//
//  iReadAlert.swift
//  iRead
//
//  Created by Simon on 16/3/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class iReadAlert {
    
    class func showErrorMessage(title: String, message: String,  dismissTitle: String, inViewController viewController: UIViewController?) -> () {
        
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "确认", style: .Default, handler: nil)
            
            alertController.addAction(dismissAction)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)            
            
        })
        
    }
    
    class func showErrorMessage(title: String, message: String,  dismissTitle: String, inViewController viewController: UIViewController?, withDismissAction dismissAction: () -> Void) -> () {
        
        dispatch_async(dispatch_get_main_queue(), {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
            let dismissAction = UIAlertAction(title: "确认", style: .Default) { action -> Void in
                dismissAction()
                
            }
            
            alertController.addAction(dismissAction)
            
            viewController?.presentViewController(alertController, animated: true, completion: nil)
            
        })
        
    }
    
    class func showFeedInput(title: String, placeholder: String?, confirmTitle: String?, dismissTitle: String, inViewController viewController: UIViewController?, withFinishedAction finishedAction: ((text: String) -> Void)?) {
        
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

            viewController?.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
  
}