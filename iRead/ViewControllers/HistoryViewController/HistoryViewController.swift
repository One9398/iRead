//
//  HistoryViewController.swift
//  iRead
//
//  Created by Simon on 16/4/19.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class HistoryViewController: BaseChildViewController {
    
    private var tableView = UITableView()
    private var feedResource = FeedResource.sharedResource
    private var readArticles : [FeedItemModel] {
        return feedResource.fetchArticlesMarkedRead()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.titleLabel.text = "我的历史"
        
        prepareForTableView()
        prepareForEmptyView()

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        appearNavigationBar()
        appearTabbar()
        
    }
    
    func appearTabbar() {
        self.tabBarController?.tabBar.hidden = false
    }
    
    func appearNavigationBar() {
        if self.navigationController!.navigationBarHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareForEmptyView() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    private func prepareForTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(HistoryArticleCell.self, forCellReuseIdentifier: NSStringFromClass(HistoryArticleCell.self))
        tableView.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
        
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        view.addSubview(tableView)
        tableView.snp_makeConstraints(closure: {
            make in
            make.top.left.right.bottom.equalTo(self.view)
        })
    }
    
}

extension HistoryViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return readArticles.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(HistoryArticleCell.self), forIndexPath: indexPath) as! HistoryArticleCell
        
        let readArticle = self.readArticles[indexPath.row]
        cell.updateCellContent(readArticle)
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedArticle = readArticles[indexPath.row]
        let articleVC = ArticleViewController(feedItem: selectedArticle)
        self.navigationController?.pushViewController(articleVC, animated: true)
        
    }
    
}

extension HistoryViewController : DZNEmptyDataSetDelegate, DZNEmptyDataSetSource {
    
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "icon_empty_logo")
    }
    
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let emptyTitle  = "唉~, 没有浏览的历史"
        
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
        let descriptionStr = "先去找资讯看看吧."
        
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
