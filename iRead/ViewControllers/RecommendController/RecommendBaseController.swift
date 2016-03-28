//
//  RecommendBaseController.swift
//  iRead
//
//  Created by Simon on 16/3/26.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material
import DZNEmptyDataSet

protocol RecommendFeedProtocol {
    var typeFeeds : [FeedItem]{get}
}

class RecommendBaseController: UIViewController, RecommendFeedProtocol {
    
    let tableView: UITableView = UITableView()
    let cardView: CardView = CardView()
    
    var feedProviders = Set<FeedModelsProvider>()
    var feeds = FeedModel.loadLocalFeeds()
    
    var initialDataSource: [FeedItem] = FeedResource.sharedResource.items
    var errorShow = false
    // MARK: - View Life Cycle ♻️
    private var feedType: FeedType = .Other
    
    var typeFeeds: [FeedItem] {
        get {
            let feeds = FeedResource.sharedResource.items.filter{$0.feedType == feedType}
            return feeds
        }
    }
    
    convenience init(feedType: FeedType) {
        self.init()
        self.feedType = feedType
    }

//    required init?(coder aDecoder: NSCoder) {
//        
//        super.init(coder: aDecoder)
//    }
//    convenience init(feedType: FeedType) {
//        self.init()
//        self.feedType = feedType
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCardView()
        prepareTableView()
        prepareEmptyView()
        configureNotification()
        loadData()
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        view.layoutIfNeeded()
        print("rotation bug need to fix")
        
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: iReadNotification.FeedFetchOperationDidSinglyFailureNotification, object: self)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: iReadNotification.FeedParseOperationDidSinglyFailureNotification, object: self)
    }
    
    
    // MARK: - Configure Data
    
    func configureNotification() {
        //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData", name: YZDisplayViewClickOrScrollDidFinshNote, object: self)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchFeedFailureHandle", name: iReadNotification.FeedFetchOperationDidSinglyFailureNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "parseFeedFailureHandle", name: iReadNotification.FeedParseOperationDidSinglyFailureNotification, object: nil)
        
    }
    
    // MARK: - Event Handle
    func fetchFeedFailureHandle() {
        print("alert fetch failure !")
        
        if !errorShow {
            
            errorShow = true
            
            iReadAlert.showErrorMessage(title: "Oops!", message: "网络获取出错,检查下网络呗~", dismissTitle: "好的", inViewController: self, withDismissAction: {
                
                self.errorShow = false
            })
            
        }
    }
    
    func parseFeedFailureHandle() {
        print("document parse error")
        
        if !errorShow {
            
            errorShow = true
            
            iReadAlert.showErrorMessage(title: "Oops!", message: "RSS数据解析出错,地址不对嗷~", dismissTitle: "好的", inViewController: self, withDismissAction: {
                
                self.errorShow = false
            })
            
        }
    }
    
    func loadData() {
        print("loadData")
        
        self.tableView.editing = false
        feeds.removeAll()
        
        // show HUD
        
        for i in 0..<typeFeeds.count {
            let feedItem = typeFeeds[i]
          
            let provider = FeedModelsProvider(feedItem: feedItem, failure: {
                error in
               
                
                }, completion: {
                    feedModel in
                    
                    if let feedModel = feedModel {
                        
                        self.feeds.append(feedModel)
                        
                        print(feedModel)
                        self.tableView.reloadData()
                        if self.feeds.count == self.typeFeeds.count {
                            // hide HUD
                            print("\(self.feeds.count) items all fetch done   !!!!!x")
                        }
                        
                    }
            })
//            let provider = FeedModelsProvider(feedURL: feedItem.feedURL, index: i, feedType: feedItem.feedType) { (feedModel: FeedModel?) -> () in
//                
//
//                
//            }
//            
            feedProviders.insert(provider)
            
        }
        
    }
    
    func reduceButtonClicked(sender: NSObject) {
        print("need delete")
        
        if feeds.count <= 0 {
            return
        }
        
        tableView.editing = !tableView.editing
        
    }
    
    func plusButtonClicked(sender: NSObject) {
        print(__FUNCTION__)
        
        self.tableView.editing = false
        
        iReadAlert.showFeedInput(title: "RSS源添加", placeholder: "输入源地址", confirmTitle: "确认", dismissTitle: "返回", inViewController: self, withFinishedAction: { (text: String) -> Void in
            
            if text.hasPrefix("http://") || text.hasPrefix("https://") {
                
                var isNew = true
                for i in 0..<self.feeds.count {
                    if text.isEqualIgnoreCaseStirng(self.typeFeeds[i].feedURL) {
                        iReadAlert.showErrorMessage(title: "提示", message: "该RSS源已存在App中", dismissTitle: "明白", inViewController: self)
                        isNew = false
                    }
                }
                
                if isNew {
                    
                    let feedItem = FeedItem(feedURL: text, feedType: self.feedType, isSub: false)
                    
                    _ = FeedModelsProvider(feedItem: feedItem, failure: {
                        error in
                        
                        
                        }, completion: {
                            feedModel in
                            
                            if let feedModel = feedModel {
                                
                                self.feeds.append(feedModel)
                                
                                print(feedModel)
                                self.tableView.reloadData()
                                if self.feeds.count == self.typeFeeds.count {
                                    // hide HUD
                                    print("\(self.feeds.count) items all fetch done   !!!!!x")
                                }
                                
                            }
                    })
                    
                }
                
            } else {
                iReadAlert.showErrorMessage(title: "出错了~", message: "所输入源地址格式错误", dismissTitle: "确定", inViewController: self)
            }
            
        })
    }
    
    func refreshButtonClicked(sender: NSObject) {
        print(__FUNCTION__)
        loadData()
    }
    
    // MARK: - UI Preparation 📱
    
    private func prepareCardView() {
        
        cardView.pulseColor = iReadColor.themeBlueColor
        cardView.backgroundColor = iReadColor.themeLightWhiteColor
        cardView.divider = false
        cardView.cornerRadiusPreset = .Radius1
        cardView.contentInsetPreset = .Square1
        cardView.leftButtonsInsetPreset = .Square1
        cardView.rightButtonsInsetPreset = .Square1
        cardView.depth = .Depth2
        cardView.detailView = tableView
        
        let refreshButton = BaseButton.createButton("icon_refresh_highlight", highlightImg: "icon_refresh_normal", target: self, action: "refreshButtonClicked:")
        cardView.leftButtons = [refreshButton]
        
        let plusButton = BaseButton.createButton("icon_add_highlight", highlightImg: "icon_add_normal", target: self, action: "plusButtonClicked:")
        let reduceButton = BaseButton.createButton("reduce_icon_highlight", highlightImg: "reduce_icon_noralma", target: self, action: "reduceButtonClicked:")
        
        cardView.rightButtons = [plusButton, reduceButton]
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        
        MaterialLayout.alignToParent(view, child: cardView, left: 20, right: 20, top: 20, bottom: 64)
        
    }
    
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(FeedBaseTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FeedBaseTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        
    }
    
    private func prepareEmptyView() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
}

// MARK: - TableView Delegate & DataSource
extension RecommendBaseController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return feeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(FeedBaseTableViewCell.self), forIndexPath: indexPath) as! FeedBaseTableViewCell
        cell.tableCellDelegate = self
        
        if feeds.count <= 0 {
            
        } else if (indexPath.row <= feeds.count - 1){
            cell.updateContent(feeds[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.row)
        
        let feed = feeds[indexPath.row]
        FeedResource.sharedResource.removeFeed(feed.source)
        
        feeds.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.row)")
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FeedBaseTableViewCell
        print(cell.textLabel?.text)
        
        if cell.textLabel?.text == nil {
            return
        }
        let feedListVC = FeedListController()
        feedListVC.configureContent(feeds[indexPath.row])
        
        self.navigationController?.pushViewController(feedListVC, animated: true)
        
    }
    
    func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        
        let cell  = tableView.cellForRowAtIndexPath(indexPath)
        
        if cell?.textLabel?.text == "" {
            return false
        }
        
        return true
    }
}

extension RecommendBaseController : BaseTableViewCellProtocol {
    func baseTableViewCell(cell: FeedBaseTableViewCell, didChangedSwitchState state: Bool, feed: FeedModel) {
        
        if state {
            print("\(feed.title) 订阅成功")
        } else {
            print("\(feed.title) 订阅取消")
        }
        
    }
}

extension RecommendBaseController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "icon_empty_logo")
    }
    
    func imageAnimationForEmptyDataSet(scrollView: UIScrollView!) -> CAAnimation! {
        let fadeAnimation = CABasicAnimation(keyPath: "alpha")
        fadeAnimation.fromValue = 0
        fadeAnimation.toValue = 1.0
        fadeAnimation.duration = 2.0
        
        return fadeAnimation
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let emptyTitle  = "Oops~, 没有有效的资讯源"
        
        let titleAttributes = [NSFontAttributeName: iReadFont.medium, NSForegroundColorAttributeName: iReadColor.themeDarkGrayColor]
        
        return NSAttributedString(string: emptyTitle, attributes: titleAttributes)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return -10
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return 20
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let descriptionStr = "可以尝试下方的刷新按钮,或者填一个自己的资讯源试试哦."
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        paragraphStyle.alignment = .Center
        
        let descriptionAttributes = [NSFontAttributeName: iReadFont.regualWithSize(13), NSForegroundColorAttributeName: iReadColor.themeDarkGrayColor, NSParagraphStyleAttributeName: paragraphStyle]
        
        return NSAttributedString(string: descriptionStr, attributes: descriptionAttributes)
    }
    
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return false
        
    }
}

