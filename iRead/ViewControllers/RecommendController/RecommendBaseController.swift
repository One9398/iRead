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

class RecommendBaseController: UIViewController {
    
    let tableView: UITableView = UITableView()

    var recommendView: RecommandCardView = RecommandCardView()
    
    lazy var loadAcitivity: iReadLoadView = {
        var  loadActivity = iReadLoadView(activityIndicatorStyle: .Default)
        self.tableView.addSubview(loadActivity)
        return loadActivity
    }()
    
    var feedProviders = Set<FeedModelsProvider>()
    let feedResource = FeedResource.sharedResource
    
    // 指定类型的Model
    var feeds: [FeedModel] {
        let feeds = feedResource.fetchCurrentTypeFeeds(self.feedType)
        return feeds
    }
    
    // 指定类型的item
    var items: [FeedItem] {
        let tems = feedResource.fetchCurrentTypeFeedItems(self.feedType)
        return tems
    }

    var errorShow = false
    // MARK: - View Life Cycle ♻️
    private var feedType: FeedType = .Other
    
    convenience init(feedType: FeedType) {
        self.init()
        self.feedType = feedType
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareRecommendView()
        prepareTableView()
        prepareEmptyView()
        
//        configureNotification()
        loadData()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
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
        
        if items.count == 0 {
            self.noticeTop("当前类型没有资讯源~")
        } else {
            loadAcitivity.startAnimating()            
        }
        // show HUD
        
        for i in 0..<items.count {
            let feedItem = items[i]
          
            let provider = FeedModelsProvider(feedItem: feedItem, failure: {
                error, message in
                
                print(" ♻️♻️♻️♻️♻️♻️ error happen \(message)")
//                self.noticeError("加载错误...")
                
                }, completion: {
                    [unowned self] feedModel in
                   
                    
                    self.loadAcitivity.stopAnimating()
                    
                    guard let feedModel = feedModel else {
                        assertionFailure("feedModel unaviablable")
                        return
                    }
                    
                    self.feedResource.appendFeed(feedModel)
                    
                    print(feedModel)
                   
                    self.tableView.reloadData()
                   
                    if self.feeds.count == self.items.count {
                            // hide HUD
                        print("\(self.feeds.count) items all fetch done   !!!!!x")
                   
                    }
                        
            })

            feedProviders.insert(provider)
            
        }
        
    }

    // MARK: - UI Preparation 📱
    
    private func prepareRecommendView() {
        recommendView = RecommandCardView(detailView: tableView)
        recommendView.eventDelegate = self
        recommendView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(recommendView)
        
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
        cell.updateContent(feeds[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return iReadConstant.RecommendTable.heightForCell
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
        return .Delete
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        print(indexPath.row)
        
        let feed =  feeds[indexPath.row]
        feedResource.removeFeed(feed)
        
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

// MARK: - BaseTableViewCellDelegate
extension RecommendBaseController : BaseTableViewCellDelegate {
    func baseTableViewCell(cell: FeedBaseTableViewCell, didChangedSwitchState state: Bool, feed: FeedModel) {
        
        let infoMsg: String = state ? "\(feed.title) 订阅成功" : "\(feed.title) 订阅取消"
        
        self.noticeTop( infoMsg, autoClear: true, autoClearTime: 1)
        
        feed.isFollowed = !feed.isFollowed
        feedResource.updateFeedState(feed)
//        tableView.reloadData()
        self.tableView.reloadRowsAtIndexPaths([tableView.indexPathForCell(cell)!], withRowAnimation: .None)
        
    }
}

// MARK: - RecommandCardViewDelegate
extension RecommendBaseController : RecommandCardViewDelegate {
    func recommandCardViewPlusButtonClicked(button: BaseButton) {
        print(__FUNCTION__)
        
        self.tableView.editing = false
        
        iReadAlert.showFeedInput(title: "RSS源添加", placeholder: "输入源地址", confirmTitle: "确认", dismissTitle: "返回", inViewController: self, withFinishedAction: { (text: String) -> Void in
            
            if text.hasPrefix("http://") || text.hasPrefix("https://") {
               
                var isNew = true
                
                for i in 0..<self.feeds.count {
                    
                    if text.isEqualIgnoreCaseStirng(self.items[i].feedURL) {
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
                            
                            guard let feedModel = feedModel else { assertionFailure("feed unavibale") ; return }
                            
                            self.feedResource.appendFeed(feedModel)
                            self.feedResource.appendFeedItem(feedItem)
                           
                            print(feedModel)
                           
                            self.tableView.reloadData()

                            if self.feeds.count == self.items.count {
                                    // hide HUD
                                print("item  fetch done   !!!!!x")
                               
                            }
                    })
                    
                }
                
            } else {
                iReadAlert.showErrorMessage(title: "出错了~", message: "所输入源地址格式错误", dismissTitle: "确定", inViewController: self)
            }
            
        })
    }
    
    func recommandCardViewReducettonClicked(button: BaseButton) {
        
        if feeds.count <= 0 {
            print("no feed delete")
            return
        }
        
        print("need delete")
        tableView.editing = !tableView.editing
    }
    
    func recommandCardViewRefreshButtonClicked(button: BaseButton) {
        loadData()
    }
}

// MARK: - DZNEmptyDataSetDelegate&DZNEmptyDataSetSource
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
        return iReadConstant.EmptyView.verticalOffset
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return iReadConstant.EmptyView.spaceHeight
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

