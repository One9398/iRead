//
//  BaseCollectionViewCell.swift
//  iRead
//
//  Created by Simon on 16/3/17.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

protocol BaseCollectionViewCellProtocol: NSObjectProtocol {
    func baseCollectionViewCellSharedActionDidHandle(cell: BaseCollectionViewCell, item: FeedItemModel?)
    
}


class BaseCollectionViewCell: MaterialCollectionViewCell {

    var card: BaseCardView?
    var timeButton: FlatButton?
    var authorButton: FlatButton?
    var categoryButton: FlatButton?
    weak var actionDelegate: BaseCollectionViewCellProtocol?
    var item: FeedItemModel?
    
    
    var titleLab: UILabel?
    var detail : UILabel?
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    // MARK: - View Life Cycle ♻️

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareForCell()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Preparation 📱
   
    private func prepareForCell() {

        prepareForCardView()
        prepareForTitleView()
        prepareForBottomView()
        
    }
    
    private func prepareForCardView() {
        var cardView: BaseCardView? = self.contentView.subviews.first as? BaseCardView
        
        cardView = BaseCardView()
        cardView?.shadowColor = iReadColor.themeLightBlueColor
        
        self.backgroundColor = nil
        self.pulseColor = nil
        self.backgroundView = UIView()
        
        self.contentView.addSubview(cardView!)
        
        cardView!.pulseScale = false
        cardView!.divider = false
        cardView!.depth = .Depth3
        
        card = cardView
        
        self.contentView.addSubview(cardView!)
        
        cardView!.frame = self.bounds
    }
    
    private func prepareForTitleView() {
        let titleLabel: UILabel = UILabel()
        titleLabel.textColor = iReadColor.themeBlackColor
        titleLabel.font = iReadFont.regualWithSize(18)
        titleLabel.numberOfLines = 2
        titleLab = titleLabel
        card!.titleLabel = titleLabel
        card!.titleLabel?.setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        
        let detailLabel: UILabel = UILabel()
        detailLabel.text = ""
        card!.detailView = detailLabel
        
    }
    
    private func prepareForBottomView() {
        let timeBtn = configureFlatButton("未知时间", iconName: "icon_time")
        timeButton = timeBtn
        let authorBtn = configureFlatButton("未知作者", iconName: "icon_author")
        authorButton = authorBtn
        let categoryBtn = configureFlatButton("未知分类", iconName: "icon_category")
        categoryButton = categoryBtn
        
        card!.leftButtons = [timeBtn, authorBtn, categoryBtn]
        card!.leftButtons?[0].setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        timeButton?.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8)
        timeButton?.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        
        let shareBtn = configureActionButton(self, action: "sharedActionHandle:")
        card!.rightButtons = [shareBtn]
        
    }
    
    //MARK: - Configure Data
    
    private func configureActionButton(target: AnyObject?, action: Selector) -> FlatButton {
        let actionBtn = FlatButton()
        actionBtn.setImage(UIImage(named: "icon_share_normal"), forState: .Normal)
        actionBtn.setImage(UIImage(named: "icon_share_highlight"), forState: .Highlighted)
        actionBtn.pulseColor = iReadColor.themeDarkBlueColor
        
        actionBtn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        
        return actionBtn
    }
    
    private func configureFlatButton(text: String ,iconName: String) -> FlatButton {
        let btn = FlatButton()
        btn.pulseColor = nil
        btn.setTitle(text, forState: .Normal)
        btn.setImage(UIImage(named: iconName), forState: .Normal)
        btn.setTitleColor(iReadColor.themeDarkGrayColor, forState: .Normal)
        btn.titleLabel?.font = iReadFont.lightWithSize(10)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, -4)
//        btn.setContentHuggingPriority(1000, forAxis: .Vertical)
        
        return btn
    }
    
    func updateContent(model: FeedItemModel?) {
        if let cardView = card, let feedItem = model {
  
            self.item = feedItem
            titleLab?.text = feedItem.title
            cardView.titleLabel?.sizeToFit()
            
            if feedItem.isRead {
                self.card?.depth = .None
            } else {
                self.card?.depth = .Depth3
            }

            if feedItem.author != "" {
                authorButton?.setTitle(feedItem.author, forState: .Normal)
            } else if feedItem.source != "" {
                authorButton?.setTitle(feedItem.source, forState: .Normal)
            }
            
            if feedItem.pubDate != "" {
                
                let date: NSDate?
                let dateString: String?
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "MM-dd / HH:mm"
                

                if feedItem.pubDate.containsString("-") {
                    date = NSDate(fromRFC3339String: feedItem.pubDate)
               
                    dateString = dateFormatter.stringFromDate(date!)
                    
                } else {
                    date = NSDate(fromRFC822String: feedItem.pubDate)
                    dateString = dateFormatter.stringFromDate(date!)

                }

                timeButton?.setTitle(dateString, forState: .Normal)
 
            }
            
            if feedItem.category != "" {
                categoryButton?.setTitle(feedItem.category, forState: .Normal)
            }
            
        }
    }

    func updateArticleReadState(item: FeedItemModel) {
        item.isRead = true
        card?.depth = .None
        card?.drawRect(self.bounds)
    }
    
    // MARK: - Handle Event
    func sharedActionHandle(btn: FlatButton) {
        self.actionDelegate?.baseCollectionViewCellSharedActionDidHandle(self, item: item)
    }
}

