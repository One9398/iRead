//
//  ProfileSettingCell.swift
//  iRead
//
//  Created by Simon on 16/4/14.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class ProfileSettingCell: MaterialTableViewCell {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    var profileItem: ProfileItem?
    
    private var switchControl: BaseSwitch?
    private var cellLine = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Value1, reuseIdentifier: NSStringFromClass(ProfileSettingCell.self))

    }
    
    convenience init(profileItem: ProfileItem) {
        self.init(style: .Value1, reuseIdentifier: NSStringFromClass(ProfileSettingCell.self))
        
        prepareForCell(profileItem: profileItem)
        configureCellContent(profileItem: profileItem)
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureCellContent(profileItem item: ProfileItem) {
        self.profileItem = item
        switchControl?.hidden = !item.showSwitch
        self.textLabel?.text = item.title
        self.imageView?.image = UIImage(named: item.icon)
        self.detailTextLabel?.text = item.subTitle
        self.accessoryType = (item.showSwitch && item.subTitle.isEmpty) ? .None : .DisclosureIndicator        
        self.pulseColor = item.showSwitch ? nil : MaterialColor.grey.lighten1
        
    }
    
    private func prepareForCell(profileItem item: ProfileItem) {
        
        self.selectionStyle = .None
        self.textLabel?.font = iReadFont.regualWithSize(16)
        self.detailTextLabel?.font = iReadFont.regualWithSize(14)
        self.textLabel?.textColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlackColor, nightColor: iReadColor.themeLightWhiteColor)
        self.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
        
        let switchControl = BaseSwitch.createSwitch(iReadTheme.isNightMode() ? .NightMode : .DayMode, isOn: item.isOn)
        switchControl.delegate = self
        self.switchControl = switchControl
        self.contentView.addSubview(switchControl)
        
        cellLine.backgroundColor = iReadColor.themeGrayColor
        self.addSubview(cellLine)

        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        cellLine.translatesAutoresizingMaskIntoConstraints = false
        cellLine.snp_makeConstraints(closure: {
            make in
            make.height.equalTo(iReadConstant.ProfileSettingCell.lineHeight)
            make.leading.trailing.bottom.equalTo(self)
            
        })
        
        switchControl?.translatesAutoresizingMaskIntoConstraints = false
        switchControl?.snp_makeConstraints(closure: {
            make in
            make.centerY.equalTo(self.contentView.snp_centerY)
            make.trailing.equalTo(self.contentView).offset(-0.5 * iReadConstant.SwitchView.switchInset)
        })
    }
}

extension ProfileSettingCell: MaterialSwitchDelegate {
    func materialSwitchStateChanged(control: MaterialSwitch) {
        
        profileItem?.switchAction?(control.on)
    }
}