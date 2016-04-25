//
//  feedResource.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation
import AVOSCloud

enum FeedType: String {
    case ITNews, TechStudy, Life, Other,Blog
}

enum ArticleType: String {
    case FavoriteType, ToreadType
}

class FeedResource  {
    static let sharedResource = FeedResource()
    var items = [FeedItem2]()
    var subscribeItems : [FeedItem2] {
        return items.filter{ $0.isSub == true }
    }
    
    var defauktItems = [FeedItem2]()
    
    var favoriteArticles = [FeedItemModel]()
    var toreadArticles = [FeedItemModel]()
    
    // todo
    var readArticles = [FeedItemModel]()
    
    var feeds = [FeedModel]()
    var subscirbeFeeds: [FeedModel] {
        return feeds.filter{ $0.isFollowed == true }
    }
    
    init() {
        
    }
    
    func loadFeedItem(completion: (([FeedItem2], error: NSError?) -> ())?) {
        if iReadUserDefaults.isLogined  {
            loadFeedItemRemoteFile(completion)
        } else {
            loadFeedItemLocalFile(completion)
        }
    }
    
    func loadFeedItemRemoteFile(completion: (([FeedItem2], errors: NSError?) -> ())?) {
        print("start fetch")
        let query = FeedItem2.query()
        query.whereKey(kSubscibeFeedItemOwnerKey, containsString: iReadUserDefaults.currentUser!.objectId)
        query.cachePolicy = .NetworkElseCache
        
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?)in
            print("😎fetch \(objects!.count) items from remote")
            
            let items = objects as? [FeedItem2] ?? []
            completion?(items, errors: error)
            
            NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedItemsRemoteFetchDidFinishedNotification, object: nil)
        }

        print("服务器加载")
        
    }
    
    func loadFeedItemLocalFile(completion: (([FeedItem2], error: NSError?) -> ())?) {
        print("本地加载")
        let path = NSBundle.mainBundle().pathForResource("feeds", ofType: "plist")
        let source = NSArray(contentsOfFile: path!)
       
        var items = [FeedItem2]()
        for itemDic in source! {
            let item = FeedItem2(className: FeedItem2.parseClassName(), dictionary: itemDic as! [NSObject : AnyObject])
            items.append(item)
        }
        completion?(items,error:  nil)
    }
    
    func fetchCurrentTypeFeedItems(type: FeedType) -> [FeedItem2] {
        return items.filter({ $0.feedType == type.rawValue })
    }
    
    func fetchCurrentTypeFeeds(type: FeedType) -> [FeedModel] {
        return feeds.filter({ $0.feedType == type })
    }
    
    func fetchCurrentSubscribedFeeds() -> [FeedModel] {
        return feeds.filter{ $0.isFollowed == true }
    }
    
    func fetchCurrentSubscribedItems() -> [FeedItem2] {
        return items.filter{ $0.isSub == true }
    }
    
    func appendFeed(feed: FeedModel) {
        if let index = feeds.indexOf(feed) {
            feeds[index] = feed
        } else {
//            feeds.append(feed)
            feeds.insert(feed, atIndex: 0)
        }
    }
    
    func appendFeedItem(item: FeedItem2) {
        items.insert(item, atIndex: 0)
    }
   
    // 也移除了item
    func removeFeed(feed: FeedModel) {
        
        guard let index = feeds.indexOf(feed) else { assertionFailure("remove feed not exist") ; return }
        feeds.removeAtIndex(index)

        guard let indexItem = items.indexOf({ item in  item.feedURL == feed.source }) else { assertionFailure("remove item not exist") ; return }

        let item = items.removeAtIndex(indexItem)
        removeFeedItem(item)

    }
    
    func updateFeedState(feed: FeedModel) {
        
        print("\(feed.title) + \(feed.isFollowed)")
        
        guard let index = feeds.indexOf(feed) else { assertionFailure("update feed not exist") ; return }
        feeds[index].isFollowed = feed.isFollowed
        
        guard let indexItem =  items.indexOf({ item in  item.feedURL == feed.source }) else { assertionFailure("update feed not exist") ; return }
       
        let item = items[indexItem]
        item.isSub = feed.isFollowed
        updateItemState(item)
    }
    
    func removeAllFeed() {
        feeds.removeAll()
    }

    func removeFeedItem(item: FeedItem2) {
        
        if iReadUserDefaults.isLogined {
            item.deleteInBackgroundWithBlock{
                result, error in
                if filterError(error) {
                    print("😎delete done \(result)")
                }
            }
        }
    }
    
    func updateItemState(feedItem: FeedItem2) {
        
        if iReadUserDefaults.isLogined {
            feedItem.fetchWhenSave = true
            feedItem.saveInBackgroundWithBlock{
                result, error in
                if filterError(error) {
                    print("😎save done \(result)")
                }
            }
        }
    }
 
    // MARK: 文章操作
    func fetchArticles(articleType: ArticleType) -> [FeedItemModel] {
        switch articleType {
        case .FavoriteType:
            return favoriteArticles
        case .ToreadType:
            return toreadArticles
        }
    }
    func updateArticleState(article: FeedItemModel) {
        self.favoriteArticles =  self.favoriteArticles.filter{$0.title != article.title}
    }
    
    func appendFavoriteArticle(article: FeedItemModel) {
        self.favoriteArticles.insert(article, atIndex: 0)
    }
    
    func removeFavoriteArticle(article: FeedItemModel, index: Int?){
       
        if let index = index {
            self.favoriteArticles.removeAtIndex(index)
        } else {
            self.favoriteArticles = self.favoriteArticles.filter({$0.title != article.title})
        }
        
    }
    
    func updateArticleToReadState(article: FeedItemModel) {
        self.toreadArticles =  self.toreadArticles.filter{$0.isToread != article.isToread}
    }
    
    func appendToreadArticle(article: FeedItemModel) {
        self.toreadArticles.insert(article, atIndex: 0)
    }
    
    func removeToreadArticle(article: FeedItemModel, index: Int?){
        
        if let index = index {
            self.toreadArticles.removeAtIndex(index)
        } else {
            self.toreadArticles = self.favoriteArticles.filter({$0.isToread != false})
        }
        
    }

    // todo
    func appendReadArticle(article: FeedItemModel) {
        
        if (!self.readArticles.contains({return $0.title == article.title})) {
            article.readDate = iReadDateFormatter.sharedDateFormatter.getCurrentDateString("MM月dd日,HH点mm分")
            self.readArticles.insert(article, atIndex: 0)
            iReadUserDefaults.updateReadCounts(1)
            print("add a read article")
        }
        
    }
    
    func removeReadArticle(article: FeedItemModel, index: Int?){
        
        if let index = index {
            self.readArticles.removeAtIndex(index)
        } else {
            self.readArticles = self.readArticles.filter({$0.isRead != false})
        }
    }
    
    func fetchArticlesMarkedRead() -> [FeedItemModel] {
        return self.readArticles
    }
}

class FeedItem2: AVObject, AVSubclassing {
    
    @NSManaged var feedURL: String
    @NSManaged var isSub: Bool
    @NSManaged var feedType: String
    @NSManaged var owner: String
    
    static func parseClassName() -> String! {
        return "FeedItem"
    }
    
    static func configureItemWithType(feedType: FeedType, feedURL: String, isSub: Bool, owner: String = "god") -> FeedItem2 {
        let feedItem2 = FeedItem2()
        feedItem2.feedURL = feedURL
        feedItem2.isSub = isSub
        feedItem2.feedType = feedType.rawValue
        return feedItem2
    }
    
    func saveBackgroundWhenLogin() {
        if let reader =  iReadUserDefaults.currentUser {
            self.owner = reader.objectId
            self.saveInBackgroundWithBlock{
                result, error in
                if filterError(error) {
                    print("😎save done \(result)")
                }
            }
        }
    }
    
}

let kSubscibeFeedItemOwnerKey = "owner"

