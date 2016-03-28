//
//  iReadLoadView.swift
//  iRead
//
//  Created by Simon on 16/3/25.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class iReadLoadView: PCAngularActivityIndicatorView {

//    convenience init() {
//        
//        self.init(activityIndicatorStyle: iReadHelp.currentDeviceIsPhone() ? .Default : .Large)
//
//    }
    
    override init!(activityIndicatorStyle style: PCAngularActivityIndicatorViewStyle) {
        super.init(activityIndicatorStyle: style)
        
        self.color = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlueColor, nightColor: iReadColor.themeLightBlueColor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func showLoadingDuration(duration: NSTimeInterval) {
        self.startAnimating()
        delayTaskExectuing(duration, block: {
           self.stopAnimating()
        })
    }
}
