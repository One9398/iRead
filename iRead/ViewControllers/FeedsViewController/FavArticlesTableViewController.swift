//
//  FavArticlesTableViewController.swift
//  iRead
//
//  Created by Simon on 16/4/7.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class FavArticlesTableViewController: UITableViewController {
    
    private let feedResource = FeedResource.sharedResource
    private var favArticles: [FeedItemModel] {
        return FeedResource.sharedResource.favoriteArticles
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()

        prepareForTableView()
        prepareForEmptyView()
        self.tabBarController?.tabBar.hidden = false
        hidesBottomBarWhenPushed = true
    }

    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
        tableView.contentOffset = CGPointMake(0, -84)
        
        if self.navigationController!.navigationBarHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    
    private func prepareForEmptyView() {
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
    }
    
    private func prepareForTableView() {
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        tableView.contentInset = UIEdgeInsetsMake(84, 0, 44, 0)
        
        tableView.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeWhiteColor, nightColor: iReadColor.themeLightBlackColor)
        tableView.registerClass(FavoriteArticleCell.self, forCellReuseIdentifier: NSStringFromClass(FavoriteArticleCell.self))
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Table view data source & delegate
extension FavArticlesTableViewController {
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return favArticles.count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        let article = favArticles[indexPath.row];
        
        let cell = FavoriteArticleCell(articleModel: article)
        cell.configureCellContent(article)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 120
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        
        let removeAction = UITableViewRowAction(style: .Default, title: "取消收藏", handler: {
            [unowned self] action, indexpath in
            self.feedResource.removeFavoriteArticle(self.favArticles[indexpath.row], index: indexPath.row)
            tableView.reloadData()
        })
        
        return [removeAction];
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = self.favArticles[indexPath.row]
        let articleVC = ArticleViewController(feedItem: item)
        
        self.navigationController?.pushViewController(articleVC, animated: true)
        
    }
}
