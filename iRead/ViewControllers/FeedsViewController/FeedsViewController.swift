//
//  FeedsViewController.swift
//  iRead
//
//  Created by Simon on 16/3/3.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material
import DZNEmptyDataSet

class FeedsViewController: UIViewController {

    private var feedsTitleView: FeedsTitleView?
    private let tableView: UITableView = UITableView()
    private var toreadButton: UIButton?
    private var feedResource = FeedResource.sharedResource
    private var subscribeFeeds: [FeedModel] {
        let feeds = feedResource.fetchCurrentSubscribedFeeds()
        return feeds
    }
    private var subscribeItems: [FeedItem2] {
        let items = feedResource.fetchCurrentSubscribedItems()
        return items
    }

    
    lazy var loadAcitivity: iReadLoadView = {
        var  loadActivity = iReadLoadView(activityIndicatorStyle: .Default)
        self.view.addSubview(loadActivity)
        
        return loadActivity
    }()
    
    private var feedProviders = Set<FeedModelsProvider>()
    private var errorFeedProviders = Set<FeedModelsProvider>()
    
    private var childVC: FavArticlesTableViewController?
    private var shouldAjustOffset = false
    
    // MARK: - View Life Cycle ♻️
    deinit {
        destoryNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureNotification()
        prepareForNavigationBar()
        prepareForEmptyView()
        prepareForTableView()
        prepareForRefreshView()
        
        loadUserSubscribedItems()
    }
    
    private func loadUserSubscribedItems() {
        print("xxxxxxxx")
        print(feedResource.items.count)
        guard feedResource.items.count > 0 else {
            tabBarController?.selectedIndex = 0
            return
        }
        
        guard iReadUserDefaults.isLogined else { return }
        guard feedResource.subscribeItems.count > 0 else { return }
        
        loadAcitivity.startAnimating()
        feedResource.loadFeedItem(){
            (feedItems:[FeedItem2], error: NSError?) in
            if let error = error {
                self.showupTopInfoMessage(error.localizedDescription)
            } else {
                self.feedResource.items = feedItems
                self.loadData()
            }
            print(self.loadAcitivity)
            self.loadAcitivity.stopAnimating()
        }
    }
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        updateUIWhenArticlesChange()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        print(tableView.contentOffset)
        print(tableView.contentInset)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Preparation 📱

    private func prepareForTabBar() {
        hidesBottomBarWhenPushed = true;
    }
    
    private func prepareForNavigationBar() {
        let feedsTitleView = FeedsTitleView(leftTitle: "订阅", rightTitle: "收藏")
        feedsTitleView.delegate = self
        self.feedsTitleView = feedsTitleView
        self.navigationItem.titleView = feedsTitleView
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(named: iReadTheme.isNightMode() ? "navigationbar_nightbg_recommand" : "navigationbar_bg_recommand"), forBarMetrics: .Default)
        navigationController?.navigationBar.shadowImage = UIImage()

        let button = UIButton(frame: CGRectMake(0,0,40,40))
        button.setImage(UIImage(assetsIdentifier: .icon_toread_info_normal), forState: .Normal)
        button.setImage(UIImage(assetsIdentifier: .icon_toread_info_selected), forState: .Selected)
        button.setTitle(" ", forState: .Normal)
        button.titleLabel?.font = iReadFont.lightWithSize(16)
        button.contentEdgeInsets.right = -20
        toreadButton = button
        button.addTarget(self, action: "showToreadArticlesTable", forControlEvents: .TouchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: button)
    }
    
    private func prepareForTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(SubFeedCell.self, forCellReuseIdentifier: NSStringFromClass(SubFeedCell.self))
        tableView.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlackColor)
        
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        view.addSubview(tableView)
        tableView.snp_makeConstraints(closure: {
            make in
            make.top.left.right.bottom.equalTo(self.view)
        })
    }
    
    private func prepareForRefreshView() {

        MaterialLoader.addRefreshHeader(tableView,
            loaderColor:iReadColor.themeModelTinColor(
                dayColor: iReadColor.themeBlueColor,
                nightColor: iReadColor.themeBlackColor
            ),
            action: {
            self.loadData()
            delayTaskExectuing(2.0, block: {
                self.tableView.endRefreshing()
            })
            
        })

    }
    
    private func prepareForEmptyView() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    // MARK : Configure Data
    
    func loadData() {
        print("loadData")
        
        errorFeedProviders.removeAll()
        feedProviders.removeAll()

        for i in 0..<subscribeItems .count {
            let feedItem = subscribeItems[i]
            
            let provider = FeedModelsProvider(feedItem: feedItem, failure: {
                error, message in
                
                print(" ♻️♻️♻️♻️♻️♻️ error happen \(message)")
                
                if let error = error {
                    
                    print("️️️♻️♻️♻️ \(error.localizedDescription)")
                    let feedProvider = FeedModelsProvider(feedItem: feedItem, failure: nil, completion: nil)
                    self.errorFeedProviders.insert(feedProvider)
                    self.feedProviders.remove(feedProvider)
                    
                    if  self.feedProviders.isEmpty {
                        // hide HUD
                        print("\(self.subscribeItems.count) items all fetch done   !!!!!x")
                        self.tableView.reloadData()
                        
                        let feedCount = self.subscribeItems.count - self.errorFeedProviders.count
                        
                        if feedCount <= 0 {
                            iReadAlert.showErrorMessage(title: "网络异常", message: "Oops~网络不给力", dismissTitle: "好吧", inViewController: self)
                        } else {
                            self.showupTopInfoMessage( "订阅了\(feedCount)条资讯源")
                        }
                    }
                }
                
                }, completion: {
                    [unowned self] feedModel in
                    guard let feedModel = feedModel else {
                        assertionFailure("feedModel unaviablable")
                        return
                    }
                    
                    self.feedResource.appendFeed(feedModel)
                    
                    self.feedProviders.remove(FeedModelsProvider(feedItem: feedItem, failure: nil, completion: nil))
                    
                    
                    self.tableView.reloadData()
                    
                    if  self.feedProviders.isEmpty {
                        // hide HUD
                        print("\(self.subscribeItems.count) items all fetch done   !!!!!x")
                        self.tableView.reloadData()
                        self.showupTopInfoMessage("订阅了\(self.subscribeItems.count - self.errorFeedProviders.count)条资讯源")
                    }
                    
            })
            
            feedProviders.insert(provider)
            provider.handlProvider()
            
        }
        
    }
    
    func showToreadArticlesTable() {
        
        if feedResource.toreadArticles.isEmpty {
            self.showupTopInfoMessage("没有待读的资讯")
            return
        }
        
        print(feedResource.toreadArticles.count)
        print("show toreadview")
        let toreadArticleController = ToreadViewController(articleType: .ToreadType)
        self.navigationController?.pushViewController(toreadArticleController, animated: true)
    }
    
    func updateUIWhenArticlesChange() {
        tableView.reloadData()
        if feedResource.toreadArticles.count > 0 {
            toreadButton?.selected = true
        } else {
            toreadButton?.selected = false
        }
    }
    
    func configureNotification() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUIWhenArticlesChange", name: iReadNotification.FeedArticlesRemoteFetchDidFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateUIWhenArticlesChange", name: iReadNotification.FeedArticlesToreadStateDidChangedNotification, object: nil)
    }
    func destoryNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: iReadNotification.FeedArticlesRemoteFetchDidFinishedNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: iReadNotification.FeedArticlesToreadStateDidChangedNotification, object: nil)
    }
}

extension FeedsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
      return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subscribeFeeds.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(SubFeedCell.self), forIndexPath: indexPath) as! SubFeedCell
        cell.tableCellDelegate = self
        cell.updateContent(subscribeFeeds[indexPath.row])
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! SubFeedCell
        
        print(cell.textLabel?.text)
        
        if cell.textLabel?.text == nil {
            return
        }
        let feedListVC = FeedListController()
        
        feedListVC.configureContent(subscribeFeeds[indexPath.row])
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

extension FeedsViewController : BaseTableViewCellDelegate {
    func baseTableViewCell(cell: FeedBaseTableViewCell, didChangedSwitchState state: Bool, feed: FeedModel) {
        
        if !state {
            print("\(feed.title) 订阅取消")
            

            feed.isFollowed = !feed.isFollowed
            
            if let indexPath =  tableView.indexPathForCell(cell) {
            // 数组移除
                feedResource.updateFeedState(feed)
//                FeedResource.sharedResource.removeSubscribeItem(feed.source)
//                subscribeFeeds.removeAtIndex(indexPath.row)
                
                // 切换成非订阅,删除该Cell
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
            }
            
            if subscribeItems.count == 0 {
                shouldAjustOffset = true
                tableView.reloadData()
            } else {
                self.showupTopInfoMessage("\(feed.title) 订阅取消")
            }
           
            // 更新其他界面数据
            
            // TODO
            // 更新本地远程数据
            
            //HUD显示
            
        }
        
    }
}

extension FeedsViewController : FeedsTitleViewDelegate {
    func titleViewDidChangeSelected(sender: FeedsTitleView, isLeft: Bool) {
        if isLeft {
            childVC?.view.alpha = 0
        } else {
            // 呈现喜爱收藏文章列表控制器
            
            if childVC == nil {
                let favoriteFeedVC = FavArticlesTableViewController()
                childVC = favoriteFeedVC
                displayChildViewController(favoriteFeedVC)
            } else {
                childVC?.view.alpha = 1
            }
        }
    }
    
    func displayChildViewController(childVC: UIViewController) {
        addChildViewController(childVC)
        view.addSubview(childVC.view)
        childVC.view.frame = view.frame
        childVC.didMoveToParentViewController(self)
    }
    
}

extension FeedsViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
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
        let emptyTitle  = "唉~, 没有订阅的内容"
        
        let titleAttributes = [NSFontAttributeName: iReadFont.medium, NSForegroundColorAttributeName: iReadColor.themeDarkGrayColor]
        
        return NSAttributedString(string: emptyTitle, attributes: titleAttributes)
    }
    
    func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        
        if shouldAjustOffset {
            return iReadConstant.EmptyView.verticalOffset
        } else {
            return iReadConstant.EmptyView.verticalOffsetForFeedsViewController
        }

    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return iReadConstant.EmptyView.spaceHeight
    }
    
    func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let descriptionStr = "快去推荐看看,订阅一些适合自己的资讯源吧."
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        paragraphStyle.alignment = .Center
        
        let descriptionAttributes = [NSFontAttributeName: iReadFont.regualWithSize(13), NSForegroundColorAttributeName: iReadColor.themeDarkGrayColor, NSParagraphStyleAttributeName: paragraphStyle]
        
        return NSAttributedString(string: descriptionStr, attributes: descriptionAttributes)
    }
    
    
    func backgroundColorForEmptyDataSet(scrollView: UIScrollView!) -> UIColor! {
        return iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlackColor)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return false
    }
}
