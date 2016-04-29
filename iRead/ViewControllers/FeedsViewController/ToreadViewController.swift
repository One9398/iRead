//
//  ToreadViewController.swift
//  iRead
//
//  Created by Simon on 16/4/8.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class ToreadViewController: ArticleTableViewController {
    
    private var toreadArticles: [Article] {
        return feedResource.toreadArticles
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForNavigationBar()
        title = "待读资讯集"
        navigationController?.navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName: iReadColor.themeLightWhiteColor
        ]
        
        self.automaticallyAdjustsScrollViewInsets = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    override func viewDidAppear(animated: Bool) {
         super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func prepareForNavigationBar() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(assetsIdentifier: .icon_baritem_back), style: .Plain, target: self, action: #selector(ToreadViewController.popCurrentViewController))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(assetsIdentifier: .icon_cleanup2), style: .Plain, target: self, action: #selector(ToreadViewController.cleanupCurrentToreadArticles))
    }
    
    func cleanupCurrentToreadArticles() {
        if toreadArticles.isEmpty {
            self.showupTopInfoMessage("没有待读的文章啦")
        } else {
            for article in toreadArticles {
                FeedResource.sharedResource.updateToreadStateArticle(article)
            }
        }
        
        tableView.reloadData()
        
    }
    
    func popCurrentViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

extension ToreadViewController {
    
        override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
    
            let removeAction = UITableViewRowAction(style: .Normal, title: "标记已读", handler: {
                [unowned self] action, indexpath in
                
                let article = self.toreadArticles[indexPath.row]
                self.feedResource.updateToreadStateArticle(article)
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .None)
                tableView.reloadData()
            })
           
            removeAction.backgroundColor = iReadColor.themeLightGrayColor
            
            return [removeAction];
        }
}

extension ToreadViewController {
    override func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(assetsIdentifier: .article_toread_placehold)
    }
    
    override func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let emptyTitle  = "唉~, 没有待读的资讯了..."
        
        let titleAttributes = [NSFontAttributeName: iReadFont.medium, NSForegroundColorAttributeName: iReadColor.themeDarkGrayColor]
        
        return NSAttributedString(string: emptyTitle, attributes: titleAttributes)
    }

    override func verticalOffsetForEmptyDataSet(scrollView: UIScrollView!) -> CGFloat {
        return iReadConstant.EmptyView.verticalOffset
    }
    
    override func descriptionForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let descriptionStr = "看到兴趣的资讯但没时间细看的内容,也可以保留下来哦."
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        paragraphStyle.alignment = .Center
        
        let descriptionAttributes = [NSFontAttributeName: iReadFont.regualWithSize(13), NSForegroundColorAttributeName: iReadColor.themeDarkGrayColor, NSParagraphStyleAttributeName: paragraphStyle]
        
        return NSAttributedString(string: descriptionStr, attributes: descriptionAttributes)
    }
}
