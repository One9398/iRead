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

protocol BaseTableViewCellProtocol: NSObjectProtocol {
    func baseTableViewCell(cell: FeedBaseTableViewCell, didChangedSwitchState state: Bool, feed: FeedModel)
}

class FeedBaseTableViewCell: MaterialTableViewCell {
    
    var feedModel: FeedModel = FeedModel()
    var switchControl: BaseSwitch?
    weak var tableCellDelegate : BaseTableViewCellProtocol?
    
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
        
        self.switchControl?.hidden = false
        self.switchControl?.setSwitchState(feedModel.isFollowed ? .On : .Off, animated: false, completion: nil)
        
    }
    
    // MARK: - UI Preparation 📱
    
    private func prepareForCell() {
        self.selectionStyle = .None
        self.textLabel?.font = iReadFont.regual
        self.textLabel?.textColor = iReadColor.themeBlackColor
        self.detailTextLabel?.font = iReadFont.lightWithSize(14)
        self.detailTextLabel?.textColor = iReadColor.themeDarkGrayColor
        self.imageView?.layer.cornerRadius = 16
        self.hidden = true
        
        // 若果 当前时间为晚上则开启夜间模式
        let switchControl = BaseSwitch.createSwitch(.DayMode, isOn: feedModel.isFollowed)
        switchControl.delegate = self
        
        switchControl.hidden = true
        self.switchControl = switchControl
        self.contentView.addSubview(switchControl)
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
        if control.on {
            feedModel.isFollowed = true
        } else {
            feedModel.isFollowed = false
            
        }
        
        tableCellDelegate?.baseTableViewCell(self, didChangedSwitchState: control.on, feed: feedModel)
    }
    
}