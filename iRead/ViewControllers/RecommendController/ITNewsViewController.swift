//
//  ITNewsViewController.swift
//  iRead
//
//  Created by Simon on 16/3/14.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class ITNewsViewController: UIViewController {
    
    let tableView: UITableView = UITableView()
    let cardView: CardView = CardView()
    
    var feedProviders = Set<FeedModelsProvider>()
    var feeds = FeedModel.loadLocalFeeds()
    
    var initialDataSource: [FeedItem] = FeedResource.sharedResource.items
    var errorShow = false
    // MARK: - View Life Cycle ♻️

    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCardView()
        prepareTableView()
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
            
            iReadAlert.showErrorMessage("Oops!", message: "网络获取出错,检查下网络呗~", dismissTitle: "好的", inViewController: self, withDismissAction: {
                
                self.errorShow = false
            })
            
        }
    }
    
    func parseFeedFailureHandle() {
        print("document parse error")
        
        if !errorShow {
            
            errorShow = true
            
            iReadAlert.showErrorMessage("Oops!", message: "RSS数据解析出错,地址不对嗷~", dismissTitle: "好的", inViewController: self, withDismissAction: {
                
                self.errorShow = false
            })
            
        }
    }
    
    func loadData() {
        print("loadData")
        
        self.tableView.editing = false
        feeds.removeAll()

       // show HUD
        
        for i in 0..<initialDataSource.count {
            let feedItem = initialDataSource[i]
            let provider = FeedModelsProvider(feedURL: feedItem.feedURL, index: i, feedType: feedItem.feedType) { (feedModel: FeedModel?) -> () in
                
                if let feedModel = feedModel {
                    
                    self.feeds.append(feedModel)

                    print(feedModel)
                    self.tableView.reloadData()
                    if self.feeds.count == self.initialDataSource.count {
                        // hide HUD
                        print("\(self.feeds.count) items all fetch done   !!!!!x")
                    }
                    
                }
                
            }
            
            feedProviders.insert(provider)

        }

    }
    
    func reduceButtonClicked(sender: NSObject) {
        print("need delete")
        tableView.editing = !tableView.editing
        
    }
    
    func plusButtonClicked(sender: NSObject) {
        print(__FUNCTION__)
        
        self.tableView.editing = false
        
        iReadAlert.showFeedInput("RSS源添加", placeholder: "输入源地址", confirmTitle: "确认", dismissTitle: "返回", inViewController: self, withFinishedAction: { (text: String) -> Void in
            
            if text.hasPrefix("http://") || text.hasPrefix("https://") {
                
                var isNew = true
                for i in 0..<self.feeds.count {
                    if text.isEqualIgnoreCaseStirng(self.initialDataSource[i].feedURL) {
                        iReadAlert.showErrorMessage("提示", message: "该RSS源已存在App中", dismissTitle: "明白", inViewController: self)
                        isNew = false
                    }
                }
                
                if isNew {
                    
                    _ = FeedModelsProvider(feedURL: text, index: self.feeds.count, feedType: .New, completion: {(model: FeedModel?) in
                        
                        if let model = model {
                            self.feeds.insert(model, atIndex: 0)
                            self.initialDataSource.append(FeedItem(feedURL: text, feedType: .New))
                            self.tableView.reloadData()
                        }
                    })
                    
                }
                
            } else {
                iReadAlert.showErrorMessage("出错了~", message: "所输入源地址格式错误", dismissTitle: "确定", inViewController: self)
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
       
        let refreshButton = BaseButton(normalImg: "icon_refresh_highlight", highlightImg: "icon_refresh_normal", target: self, action: "refreshButtonClicked:")
        cardView.leftButtons = [refreshButton]

        let plusButton = BaseButton(normalImg: "icon_add_highlight", highlightImg: "icon_add_normal", target: self, action: "plusButtonClicked:")
        let reduceButton = BaseButton(normalImg: "reduce_icon_highlight", highlightImg: "reduce_icon_noralma", target: self, action: "reduceButtonClicked:")
        
        cardView.rightButtons = [plusButton, reduceButton]
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        
        MaterialLayout.alignToParent(view, child: cardView, left: 20, right: 20, top: 20, bottom: 64)
        
    }
    
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ITNewsTableViewCell.self, forCellReuseIdentifier: NSStringFromClass(ITNewsTableViewCell.self))
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .None
        
    }
    
}

// MARK: - TableView Delegate & DataSource
extension ITNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return initialDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ITNewsTableViewCell.self), forIndexPath: indexPath) as! ITNewsTableViewCell
        
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
        initialDataSource =  initialDataSource.filter{ $0.feedURL != feed.source }
        
        feeds.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected \(indexPath.row)")

        let cell = tableView.cellForRowAtIndexPath(indexPath) as! ITNewsTableViewCell
        print(cell.textLabel?.text)
        
        if cell.textLabel?.text == nil {
            return
        }
        let feedListVC = FeedListController()
        feedListVC.configureContent(feeds[indexPath.row])
        
        self.navigationController?.pushViewController(feedListVC, animated: true)
     
    }
}
