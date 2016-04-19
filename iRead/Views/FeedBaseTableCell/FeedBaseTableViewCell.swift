//
//  FeedBaseTableViewCell.swift
//  iRead
//
//  Created by Simon on 16/3/26.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material
import Kingfisher

protocol BaseTableViewCellDelegate: NSObjectProtocol {
    func baseTableViewCell(cell: FeedBaseTableViewCell, didChangedSwitchState state: Bool, feed: FeedModel)
}

class FeedBaseTableViewCell: MaterialTableViewCell {
    
    var feedModel: FeedModel = FeedModel()
    var switchControl: BaseSwitch?
    var autoSwitch = false
    
    weak var tableCellDelegate : BaseTableViewCellDelegate?
    
    convenience init(feedModel: FeedModel) {
        
        self.init(style: .Subtitle, reuseIdentifier: NSStringFromClass(FeedBaseTableViewCell.self))
        self.feedModel = feedModel
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style:.Subtitle, reuseIdentifier: reuseIdentifier)
        prepareForCell()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func updateContent(feedModel: FeedModel) {
        self.feedModel = feedModel
        self.textLabel?.text = feedModel.title
        self.detailTextLabel?.text = feedModel.description
        self.hidden = false
        
        if feedModel.imagURL != "" {
            imageView?.kf_setImageWithURL(NSURL(string: feedModel.imagURL)!, placeholderImage: UIImage(named: "icon_placehold_logo2"), optionsInfo: [.Transition(ImageTransition.Fade(0.5))], completionHandler: { (image: Image?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) -> () in
                
                self.imageView?.image = image?.resize(toWidth: 32)
                
            })
            
        } else {
            imageView?.image = UIImage(named: "icon_placehold_logo2")?.resize(toWidth: 32)
        }
        
        
        if switchControl == nil {
            // 若果 当前时间为晚上则开启夜间模式
            let switchControl = BaseSwitch.createSwitch(iReadTheme.isNightMode() ? .NightMode : .DayMode, isOn: feedModel.isFollowed)
            switchControl.delegate = self
            
            self.switchControl = switchControl
            self.contentView.addSubview(switchControl)
            
        } else {
            switchControl?.setSwitchState(feedModel.isFollowed  ? .On : .Off, animated: false, completion: {
                control in
                self.autoSwitch = true
            })
        }

        
    }
    
    // MARK: - UI Preparation 📱
    
    private func prepareForCell() {
        self.selectionStyle = .None
        self.textLabel?.font = iReadFont.regual
        self.textLabel?.textColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlackColor, nightColor: iReadColor.themeLightWhiteColor)
        self.detailTextLabel?.font = iReadFont.lightWithSize(14)
        self.detailTextLabel?.textColor = iReadColor.themeDarkGrayColor
        
        self.imageView?.layer.cornerRadius = 16
        self.hidden = true
        self.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        switchControl?.translatesAutoresizingMaskIntoConstraints = false
        switchControl?.snp_makeConstraints(closure: {
            make in
            make.top.equalTo(self.contentView).offset(2 * iReadConstant.SwitchView.switchInset)
            make.trailing.equalTo(self.contentView).offset(-0.5 * iReadConstant.SwitchView.switchInset)
        })
    }
}

extension FeedBaseTableViewCell : MaterialSwitchDelegate {
    func materialSwitchStateChanged(control: MaterialSwitch) {
        
        // 当订阅界面cell的switch改变,执行当前回调事件,只更新推荐页相应cell的UI,不重复调用回调事件
        if !autoSwitch {
            tableCellDelegate?.baseTableViewCell(self, didChangedSwitchState: control.on, feed: feedModel)
        } else {
            autoSwitch = false
        }

    }
    
}