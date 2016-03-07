//
//  ViewController.swift
//  iRead
//
//  Created by Simon on 16/3/7.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private let animateDuration: NSTimeInterval = 1.2
    private let animateDelay: NSTimeInterval = 0.5
    private let dampingRatio:CGFloat = 0.6
    private let springVelocity: CGFloat = 3
    private var label_offsetYValue:CGFloat = -20
    private var logo_offsetYValue:CGFloat {

        var value = -100.0
        if UIScreen.mainScreen().bounds.height <= 480 {
            value = -20.0
            self.label_offsetYValue = 50.0
        }
        
        return CGFloat(value)
    }
    
    
    lazy var logoImageView:UIImageView = {
        let logo = UIImageView(image: UIImage(named: "launch_logo"))
        logo.sizeToFit()
        logo.alpha = 0

        return logo
    }()
    
    lazy var labelImageView:UIImageView = {
        let labelImg = UIImageView(image: UIImage(named: "iRead"))
        labelImg.alpha = 0.0
        labelImg.sizeToFit()

        return labelImg
    }()
    
    //: MARK: - 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        configureLayoutForUIComponent(labelImageView, offSetValue: label_offsetYValue)
        configureLayoutForUIComponent(logoImageView, offSetValue: logo_offsetYValue)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

       loadCustomLaunchAnimation()
        
    }

    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func loadCustomLaunchAnimation() {
        
        UIView.animateWithDuration(animateDuration, delay: animateDelay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: springVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.logoImageView.alpha = 1.0
            
            self.logoImageView.transform = CGAffineTransformMakeTranslation(0, self.logo_offsetYValue)
            
            }) { (finished) -> Void in
                
                
                self.labelImageView.transform = CGAffineTransformMakeScale(0.8, 0.8)
                UIView.animateWithDuration(self.animateDuration * 0.5, animations: { () -> Void in
                    self.labelImageView.alpha = 1.0
                    self.labelImageView.transform = CGAffineTransformIdentity
                    
                    }, completion: { (done) -> Void in
                        
                        let time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1 * Double(NSEC_PER_SEC) ))
                        
                        dispatch_after(time_t, dispatch_get_main_queue(), { () -> Void in
                            self.replaceRootViewController()
                        })
                        
                })
                
                
        }

    }
    
    func replaceRootViewController() {
        let storyboard = self.storyboard
        let rootController = storyboard?.instantiateViewControllerWithIdentifier("RootNavigationController")
        
        UIView.animateWithDuration(self.animateDuration, animations: { () -> Void in
            
            UIApplication.sharedApplication().delegate?.window!!.rootViewController = rootController
        })
    }

//: MARK: - UIConfigure
    private func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false

        let centerXConstraint = logoImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let centerYConstraint = logoImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: logo_offsetYValue)

        NSLayoutConstraint.activateConstraints([centerXConstraint, centerYConstraint])
    }
    
    private func configureLableImageView() {
        
        view.addSubview(labelImageView)
        labelImageView.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = labelImageView.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let centerYConstraint = labelImageView.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: label_offsetYValue)
        
        NSLayoutConstraint.activateConstraints([centerXConstraint, centerYConstraint])
    }
    
    private func configureLayoutForUIComponent(component: UIView, offSetValue: CGFloat) {
        view.addSubview(component)
        component.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = component.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let centerYConstraint = component.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: offSetValue)
        
        NSLayoutConstraint.activateConstraints([centerXConstraint, centerYConstraint])
    }

}
