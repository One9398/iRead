//
//  HistoryArticleCell.swift
//  iRead
//
//  Created by Simon on 16/4/19.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class HistoryArticleCell: MaterialTableViewCell {
    private var articleModel = FeedItemModel()
    
    func updateCellContent(articleModel: FeedItemModel) {
        self.textLabel?.text = articleModel.title
        self.detailTextLabel?.text = articleModel.readDate.usePlaceholdStringWhileIsEmpty("未知时间")
            + "      来源于 "
            + articleModel.author.usePlaceholdStringWhileIsEmpty("未知作者")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        prepareForCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        prepareForCell()
    }
    
    private func prepareForCell() {
        prepareForCellStyle()
        prepareForTitleTabel()
        prepareForTimeLabel()
        prepareForBottomLine()
    }
    
    private func prepareForBottomLine() {
        let line = UIView()
        line.backgroundColor = iReadColor.themeGrayColor
        self.addSubview(line)
        line.translatesAutoresizingMaskIntoConstraints = false
        line.snp_makeConstraints(closure: {
            make in
            make.height.equalTo(iReadConstant.ProfileSettingCell.lineHeight)
            make.trailing.leading.bottom.equalTo(self)
        })
        
    }
    
    private func prepareForTitleTabel() {
        self.textLabel?.font = iReadFont.regualWithSize(16)
        self.textLabel?.numberOfLines = 0
        self.textLabel?.textColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlackColor, nightColor: iReadColor.themeLightWhiteColor)
    }
    
    private func prepareForTimeLabel() {
        self.detailTextLabel?.font = iReadFont.lightWithSize(12)
        self.detailTextLabel?.textColor = iReadColor.themeDarkGrayColor
    }
    
    private func prepareForCellStyle() {
        self.selectionStyle = .None
        self.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
    }
}
