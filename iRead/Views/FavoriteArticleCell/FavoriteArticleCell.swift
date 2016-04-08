//
//  FavoriteArticleCell.swift
//  iRead
//
//  Created by Simon on 16/4/7.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class FavoriteArticleCell: MaterialTableViewCell {

    var articleModel: FeedItemModel = FeedItemModel()
    var cardView: CardView!
    var titleLab: UILabel!
    var detailLab: UILabel!
    
    convenience init(articleModel: FeedItemModel) {
        self.init(style: .Default, reuseIdentifier: NSStringFromClass(FavoriteArticleCell.self))
        self.articleModel = articleModel
        self.backgroundColor = nil
        self.pulseColor = nil
        
        prepareForCell()
    }

    private func prepareForCell() {
        
        prepareForCardView()
        prepareForTitleView()
    }

    private func prepareForCardView() {

        let cardView = CardView(frame: CGRectZero)
        cardView.shadowColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeDarkGrayColor)
        cardView.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
        cardView.pulseScale = false
        cardView.divider = false
        cardView.depth = .Depth3
        self.cardView = cardView
        cardView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(cardView)
        cardView.frame = self.bounds
    }
    
    private func prepareForTitleView() {
        let titleLabel: UILabel = UILabel()
        titleLab = titleLabel
        titleLabel.text = "我喜爱的文章"
        titleLabel.textColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlackColor, nightColor: iReadColor.themeWhiteColor)
        titleLabel.font = iReadFont.regualWithSize(18)
        titleLabel.numberOfLines = 2
        cardView.titleLabel = titleLabel
        cardView.titleLabel?.setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        
        let detailLabel: UILabel = UILabel()
        detailLabel.textColor = iReadColor.themeLightGrayColor
        detailLab = detailLabel
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM月dd日,HH点mm分"
        let dateString = dateFormatter.stringFromDate(NSDate())
        detailLab.text = "收藏于 " + dateString
        cardView.detailView = detailLabel
        
    }
    
    func configureCellContent(articleItem: FeedItemModel) {
        titleLab.text = articleItem.title
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        cardView.snp_makeConstraints(closure: {
            make in
            make.top.equalTo(self).offset(5)
            make.left.equalTo(self).offset(15)
            make.right.equalTo(self).offset(-15)
            make.bottom.equalTo(self).offset(-5)
        })
    }
}
