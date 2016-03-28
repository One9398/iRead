//
//  BaseSwitch.swift
//  iRead
//
//  Created by Simon on 16/3/23.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class BaseSwitch: MaterialSwitch {

    override init(state: MaterialSwitchState, style: MaterialSwitchStyle, size: MaterialSwitchSize) {
        super.init(state: state, style: style, size: size)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    class func createSwitch(readState: iReadThemeMode, isOn on: Bool = false) -> BaseSwitch {
        switch readState {
        case .DayMode:
            return linghtModelSwitch(on)
        case .NightMode:
            return darkModelSwitch(on)
        }
    }
    
    class func darkModelSwitch(open: Bool) -> BaseSwitch {
        return BaseSwitch(state: (open ? .On : .Off), style: .Default, size: iReadHelp.currentDeviceIsPhone() ? .Default : .Large)
    }
    class func linghtModelSwitch(open: Bool) -> BaseSwitch {
        return BaseSwitch(state: (open ? .On : .Off), style: .LightContent, size: iReadHelp.currentDeviceIsPhone() ? .Default : .Large)
    }

}
