//
//  iReadLoadView.swift
//  iRead
//
//  Created by Simon on 16/3/25.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class iReadLoadView: PCAngularActivityIndicatorView {

    override init!(activityIndicatorStyle style: PCAngularActivityIndicatorViewStyle) {
        
        super.init(activityIndicatorStyle: iReadHelp.currentDeviceIsPhone() ? .Default : .Large)
        
        self.color = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlueColor, nightColor: iReadColor.themeGrayColor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.snp_makeConstraints(closure: {
            make in
            make.center.equalTo(self.superview!.snp_center)
        })
    }
    
    func showLoadingDuration(duration: NSTimeInterval) {
        self.startAnimating()
        delayTaskExectuing(duration, block: {
           self.stopAnimating()
        })
    }
}
