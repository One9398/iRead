//
//  LaunchViewController.swift
//  iRead
//
//  Created by Simon on 16/3/3.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    
    private let animateDuration: NSTimeInterval = 1.2
    private let frameAnimationDuration: NSTimeInterval = 1.5
    private let animateDelay: NSTimeInterval = 0.5
    private let dampingRatio:CGFloat = 0.6
    private let springVelocity: CGFloat = 3
    
    private let circle_sizeWidth:CGFloat = 50
    private let bg_middleSizeWidth:CGFloat = 250
    private let bg_finalSizeWidth:CGFloat = 2000

    private var label_offsetYValue:CGFloat = -20
    private var logo_offsetYValue:CGFloat {
        
        var value = -100.0
        if UIScreen.mainScreen().bounds.height <= 480 {
            value = -60.0
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
    
    lazy var circleView:UIImageView = {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.circle_sizeWidth, self.circle_sizeWidth), false, UIScreen.mainScreen().scale)
        let ctx = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(ctx, UIColor.themeTintColot().CGColor)
        CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, self.circle_sizeWidth, self.circle_sizeWidth))
        CGContextFillPath(ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        let circle = UIImageView(image: image)
        circle.alpha = 0.0
        return circle
    }()
    
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureLayoutForUIComponent(circleView, offSetYValue: logo_offsetYValue)
        configureLayoutForUIComponent(logoImageView, offSetYValue: logo_offsetYValue)
        configureLayoutForUIComponent(labelImageView, offSetYValue: label_offsetYValue)
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCustomLaunchAnimation { (_) -> () in
            
            self.loadCustomBackgroundAnimation()
        }
        
    }
    
    // MARK: - UI Layout Configure
    private func configureLayoutForUIComponent(component: UIView, offSetYValue: CGFloat) {
        view.addSubview(component)
        component.translatesAutoresizingMaskIntoConstraints = false
        let centerXConstraint = component.centerXAnchor.constraintEqualToAnchor(view.centerXAnchor)
        let centerYConstraint = component.centerYAnchor.constraintEqualToAnchor(view.centerYAnchor, constant: offSetYValue)
        
        NSLayoutConstraint.activateConstraints([centerXConstraint, centerYConstraint])
    }
    
    // MARK: - Other Configure
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        
        if traitCollection.userInterfaceIdiom == .Phone {
            return .Portrait
        }
        
        return .All
    }
    
    // MARK: - Custom Animation
    private func loadCustomLaunchAnimation(completion:(Bool)->()) {
        
        // Logo出现动画
        UIView.animateWithDuration(animateDuration, delay: animateDelay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: springVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.logoImageView.alpha = 1.0
            
            self.logoImageView.transform = CGAffineTransformMakeTranslation(0, self.logo_offsetYValue)
            
            }) { (finished) -> Void in
                
                // Lable出现动画
                UIView.animateWithDuration(self.animateDuration * 0.5, animations: { () -> Void in
                    self.labelImageView.alpha = 1.0
                    self.labelImageView.transform = CGAffineTransformIdentity
                    
                    }, completion: completion)
                
        }
        
    }
    
    private func loadCustomBackgroundAnimation() {
        
        // 背景改变动画
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "bounds")
        keyFrameAnimation.duration = frameAnimationDuration
        keyFrameAnimation.repeatCount = 0;
        keyFrameAnimation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut), CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
        let initalBounds = NSValue(CGRect: CGRectZero)
        let secondBounds = NSValue(CGRect: CGRectMake(0, 0, bg_middleSizeWidth, bg_middleSizeWidth))
        let finalBounds = NSValue(CGRect: CGRectMake(0, 0, bg_finalSizeWidth, bg_finalSizeWidth))
        keyFrameAnimation.values = [initalBounds,secondBounds,finalBounds]
        keyFrameAnimation.keyTimes = [0.0, 0.5,1.0]
        keyFrameAnimation.delegate = self
        
        self.circleView.alpha = 1.0
        circleView.transform = CGAffineTransformMakeTranslation(0, self.logo_offsetYValue)
        
        self.circleView.layer.addAnimation(keyFrameAnimation, forKey: "LaunchAnimation")
        
        CATransaction.setDisableActions(true)
        self.circleView.bounds = CGRectMake(0, 0, bg_finalSizeWidth, bg_finalSizeWidth)
    
    }

    private func loadCustomLaunchAnimation2() {
        
        UIView.animateWithDuration(animateDuration, delay: animateDelay, usingSpringWithDamping: dampingRatio, initialSpringVelocity: springVelocity, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            
            self.logoImageView.alpha = 1.0
            
            self.logoImageView.transform = CGAffineTransformMakeTranslation(0, self.logo_offsetYValue)
            
            }) { (finished) -> Void in
                
                UIView.animateWithDuration(self.animateDuration * 0.5, animations: { () -> Void in
                    self.labelImageView.alpha = 1.0
                    self.labelImageView.transform = CGAffineTransformIdentity
                    
                    }, completion: { (done) -> Void in
                        
                        self.loadCustomBackgroundAnimation()
                })
                
        }
        
    }
    
    private func replaceRootViewController() {
        let rootController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController()
        
        UIApplication.sharedApplication().delegate?.window!!.rootViewController = rootController
    }
    
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
        replaceRootViewController()
    }
    
}

