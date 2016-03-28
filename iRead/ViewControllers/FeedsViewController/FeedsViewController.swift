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
    private var subscribeFeeds: [FeedModel] {
        get {
            return FeedManager.currentSubscribedFeeds
        }
    }
   
    // MARK: - View Life Cycle ♻️

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        prepareForNavigationBar()
        prepareForEmptyView()
        prepareForTableView()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Preparation 📱

    private func prepareForNavigationBar() {
        let feedsTitleView = FeedsTitleView(leftTitle: "订阅", rightTitle: "收藏")
        feedsTitleView.delegate = self
        self.feedsTitleView = feedsTitleView
        self.navigationItem.titleView = feedsTitleView
        
        navigationController!.navigationBar.setBackgroundImage(UIImage(named: iReadTheme.isNightMode() ? "navigationbar_nightbg_recommand" : "navigationbar_bg_recommand"), forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = UIImage()
    }
    
    private func prepareForTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(FeedBaseTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(FeedBaseTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        view.addSubview(tableView)
        tableView.snp_makeConstraints(closure: {
            make in
            make.top.left.right.bottom.equalTo(self.view)
        })
        
    }
    
    private func prepareForEmptyView() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
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
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ITNewsTableViewCell.self), forIndexPath: indexPath) as! ITNewsTableViewCell
        cell.tableCellDelegate = self
        
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
        
//        let feed = feeds[indexPath.row]
//        initialDataSource =  initialDataSource.filter{ $0.feedURL != feed.source }
        
//        feeds.removeAtIndex(indexPath.row)
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
//        feedListVC.configureContent(feeds[indexPath.row])
        
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

extension FeedsViewController : BaseTableViewCellProtocol {
    func baseTableViewCell(cell: FeedBaseTableViewCell, didChangedSwitchState state: Bool, feed: FeedModel) {
        
        if state {
            print("\(feed.title) 订阅成功")
        } else {
            print("\(feed.title) 订阅取消")
        }
        
    }
}

extension FeedsViewController : FeedsTitleViewDelegate {
    func titleViewDidChangeSelected(sender: FeedsTitleView, isLeft: Bool) {
        if isLeft {
            
        } else {
            print("go to favicateor")
        }
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
        return -10
    }
    
    func spaceHeightForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return 20
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
        return iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
    }
    
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        return false
        
    }
}
