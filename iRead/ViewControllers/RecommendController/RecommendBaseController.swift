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
    var errorFeedProviders = Set<FeedModelsProvider>()
    
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
    }
    
    
    // MARK: - Configure Data
    
    func configureNotification() {
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadData", name: YZDisplayViewClickOrScrollDidFinshNote, object: self)
    }
    
    // MARK: - Event Handle
    
    func loadData() {
        print("loadData")
        
        self.tableView.editing = false
        errorFeedProviders.removeAll()
        feedProviders.removeAll()
        
        // show HUD
        if items.count == 0 {
            self.noticeTop("当前分类没有资讯源~")
        } else {
            loadAcitivity.startAnimating()            
        }
        
        for i in 0..<items.count {
            let feedItem = items[i]
          
            let provider = FeedModelsProvider(feedItem: feedItem, failure: {
                [unowned self] error, message in
                
                if let error = error {
                    
                    print("️️️♻️♻️♻️ \(error.localizedDescription)")
                    let feedProvider = FeedModelsProvider(feedItem: feedItem, failure: nil, completion: nil)
                    self.errorFeedProviders.insert(feedProvider)
                    self.feedProviders.remove(feedProvider)
                   
                    if  self.feedProviders.isEmpty {
                        // hide HUD
                        print("\(self.feeds.count) items all fetch done   !!!!!x")
                       
                        let feedCount = self.items.count - self.errorFeedProviders.count
                        
                        if feedCount <= 0 {
                            iReadAlert.showErrorMessage(title: "网络异常", message: "Oops~网络不给力", dismissTitle: "好吧", inViewController: self)
                        } else {
                            self.noticeTop( "获取到\(feedCount)条资讯源", autoClear: true, autoClearTime: 1)
                        }
                    }
                    
                }
                
                self.loadAcitivity.stopAnimating()
                
                }, completion: {
                    [unowned self] feedModel in
                    
                    self.loadAcitivity.stopAnimating()
                    
                    guard let feedModel = feedModel else {
                        assertionFailure("feedModel unaviablable")
                        return
                    }
                    
                    self.feedResource.appendFeed(feedModel)
                   
                    self.feedProviders.remove(FeedModelsProvider(feedItem: feedItem, failure: nil, completion: nil))
                    
                    print(feedModel)
                   
                    self.tableView.reloadData()
                   
                    if  self.feedProviders.isEmpty {
                            // hide HUD
                        print("\(self.items.count) items all fetch done   !!!!!x")
                        
                        self.noticeTop( "获取到\(self.items.count - self.errorFeedProviders.count)条资讯源", autoClear: true, autoClearTime: 1)
                    }
                    
            })
            
            feedProviders.insert(provider)
            provider.handlProvider()

            
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
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! FeedBaseTableViewCell
        print(cell.textLabel?.text)
        
        if cell.textLabel?.text == nil {
            return
        }
        let feedListVC = FeedListController()
        print(feeds[indexPath.row])
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
                        [unowned self] error, message in
                        
                        iReadAlert.showErrorMessage(title: "获取出错", message: message!, dismissTitle: "好吧", inViewController: self)
                        
                        }, completion: {
                            [unowned self] feedModel in
                            
                            guard let feedModel = feedModel else { assertionFailure("feed unavibale") ; return }
                            
                            self.feedResource.appendFeed(feedModel)
                            self.feedResource.appendFeedItem(feedItem)
                            
                            print(feedModel)
                            
                            self.tableView.reloadData()
                            self.noticeTop("添加成功", autoClear: true, autoClearTime: 1)
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
