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
    func baseCollectionViewCellSharedActionDidHandle(cell: BaseCollectionViewCell, item: Article)

    func baseCollectionViewCellReadActionDidHandle(cell: BaseCollectionViewCell, item: Article)
    
}


class BaseCollectionViewCell: MaterialCollectionViewCell {

    var card: BaseCardView?
    var timeButton: FlatButton?
    var authorButton: FlatButton?
    var categoryButton: FlatButton?
    var shareButton : FlatButton?
    var readButton : FlatButton?
    
    weak var actionDelegate: BaseCollectionViewCellProtocol?
    var article: Article!
    
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
        cardView?.shadowColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeDarkGrayColor)
        cardView?.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
        
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
        titleLabel.textColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeBlackColor, nightColor: iReadColor.themeGrayColor)
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
        let authorBtn = configureFlatButton("匿名投稿", iconName: "icon_author")
        authorButton = authorBtn
        let categoryBtn = configureFlatButton("未分类", iconName: "icon_category")
        categoryButton = categoryBtn
        
        card!.leftButtons = [timeBtn, authorBtn, categoryBtn]
        card!.leftButtons?[0].setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        timeButton?.imageEdgeInsets = UIEdgeInsetsMake(0, -8, 0, 8)
        timeButton?.titleEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0)
        
        let shareBtn = configureActionButton("icon_share_normal".afterModeAjust(), highlightImage: "icon_share_highlight", target: self, action: "sharedActionHandle:")
        shareBtn.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton = shareBtn
        
        let readBtn = configureActionButton("icon_addList_normal".afterModeAjust(), highlightImage: "icon_addList_selected".afterModeAjust(), target: self, action: "readActionHandle:")
        readBtn.translatesAutoresizingMaskIntoConstraints = false
        self.readButton = readBtn
        
        self.contentView.addSubview(readBtn)
        self.contentView.addSubview(shareBtn)
    }
    
    //MARK: - Configure Data
    
    private func configureActionButton(normalImage: String, highlightImage: String, target: AnyObject?, action: Selector) -> FlatButton {
        let actionBtn = FlatButton()
        actionBtn.setImage(UIImage(named: normalImage), forState: .Normal)
        actionBtn.setImage(UIImage(named: highlightImage), forState: .Highlighted)
        actionBtn.setImage(UIImage(named: highlightImage), forState: .Selected)
        
        actionBtn.pulseColor = iReadColor.themeDarkBlueColor
        actionBtn.addTarget(target, action: action, forControlEvents: .TouchUpInside)
        actionBtn.contentEdgeInsetsPreset = .WideRectangle1        
        
        return actionBtn
    }
    
    private func configureFlatButton(text: String ,iconName: String) -> FlatButton {
        let btn = FlatButton()
        btn.pulseColor = nil
        btn.setTitle(text, forState: .Normal)
        btn.setImage(UIImage(named: iconName), forState: .Normal)
        btn.setTitleColor(iReadColor.themeDarkGrayColor, forState: .Normal)
        btn.titleLabel?.font = iReadFont.lightWithSize(10)
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, -2)
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -5)
//        btn.setContentHuggingPriority(1000, forAxis: .Vertical)
        
        return btn
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        shareButton?.snp_makeConstraints(closure: {
            make in
            make.right.equalTo(self.contentView).offset(-5)
            make.bottom.equalTo(self.contentView).offset(-5)
            
        })
        
        readButton?.snp_makeConstraints(closure: {
            make in
            make.right.equalTo(self.contentView).offset(-5)
            make.bottom.equalTo(self.shareButton!.snp_top).offset(-5)
            
        })
        
    }
    
    func updateContent(model: Article?) {
        if let cardView = card, let feedItem = model {
  
            self.article = feedItem
            titleLab?.text = feedItem.title
            cardView.titleLabel?.sizeToFit()
            cardView.titleLabelInset.top = 10
            
            if FeedResource.sharedResource.readArticles.contains({$0.title == feedItem.title}) {
                feedItem.isRead = true
            }
            
            if feedItem.isRead {
                self.card?.depth = .None
            } else {
                self.card?.depth = .Depth3
            }
            
            if FeedResource.sharedResource.toreadArticles.contains({$0.title == feedItem.title}) {
                feedItem.isToread = true
            }
            
            if feedItem.isToread {
                readButton?.selected = true
            } else {
                readButton?.selected = false
            }

            var author: String = feedItem.author.isEmpty ? feedItem.source : feedItem.author
            author = author.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
            
            authorButton?.setTitle((author.isEmpty ? "匿名" : author.shortString()), forState: .Normal)
            
            let pubDate = iReadDateFormatter.sharedDateFormatter.getCustomDateStringFromDateString(feedItem.pubDate, styleString: "MM-dd / HH:mm")
            timeButton?.setTitle(pubDate, forState: .Normal)
            
            if !feedItem.category.isEmpty {
                categoryButton?.setTitle(feedItem.category, forState: .Normal)
            }
            
        }
    }

    func updateArticleReadState(item: Article) {

        card?.depth = .None
        card?.drawRect(self.bounds)
    }
    
    // MARK: - Handle Event
    func sharedActionHandle(btn: FlatButton) {
        self.actionDelegate?.baseCollectionViewCellSharedActionDidHandle(self, item: article)
    }
    
    func readActionHandle(btn: FlatButton) {
        if iReadUserDefaults.isLogined {
            btn.selected = !btn.selected
        }
        
        self.actionDelegate?.baseCollectionViewCellReadActionDidHandle(self, item: article)
    }
}

