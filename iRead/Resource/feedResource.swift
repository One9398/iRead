//
//  feedResource.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

enum FeedType: String {
    case ITNews, TechStudy, Life, Art, Other,Blog
}

enum ArticleType: String {
    case FavoriteType, ToreadType
}

class FeedResource  {
    static let sharedResource = FeedResource()
    var items = [FeedItem]()
    var subscribeItems : [FeedItem] {
        return items.filter{ $0.isSub == true }
    }
    
    var favoriteArticles = [FeedItemModel]()
    var toreadArticles = [FeedItemModel]()
    
    
    // todo
    var readArticles = [FeedItemModel]()
    
    var feeds = [FeedModel]()
    var subscirbeFeeds: [FeedModel] {
        return feeds.filter{ $0.isFollowed == true }
    }
    
    init() {
        
        let path = NSBundle.mainBundle().pathForResource("feeds", ofType: "plist")
        let source = NSArray(contentsOfFile: path!)
        
        for item in source! {
            
            let feedItem = FeedItem(feedURL: item["feedURL"] as! String, feedType: FeedType(rawValue: item["feedType"] as! String)!, isSub: item["isSub"] as! Bool)
            items.append(feedItem)
//            subscribeItems = items.filter{ $0.isSub == true }
            
        }
        
    }
    
    func fetchCurrentTypeFeedItems(type: FeedType) -> [FeedItem] {
        return items.filter({ $0.feedType == type })
    }
    
    func fetchCurrentTypeFeeds(type: FeedType) -> [FeedModel] {
        return feeds.filter({ $0.feedType == type })
    }
    
    func fetchCurrentSubscribedFeeds() -> [FeedModel] {
        return feeds.filter{ $0.isFollowed == true }
    }
    
    func fetchCurrentSubscribedItems() -> [FeedItem] {
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
    
    func appendFeedItem(item: FeedItem) {
//        items.append(item)
        items.insert(item, atIndex: 0)
    }
    
    func removeFeed(feed: FeedModel) {
        
        guard let index = feeds.indexOf(feed) else { assertionFailure("remove feed not exist") ; return }
        feeds.removeAtIndex(index)

        guard let indexItem = items.indexOf({ item in  item.feedURL == feed.source }) else { assertionFailure("remove item not exist") ; return }
        items.removeAtIndex(indexItem)
       
    }
    
    func updateFeedState(feed: FeedModel) {
        
//        feed.isFollowed = !feed.isFollowed
        print("\(feed.title) + \(feed.isFollowed)")
        
        guard let index = feeds.indexOf(feed) else { assertionFailure("update feed not exist") ; return }
        feeds[index].isFollowed = feed.isFollowed
        
        guard let indexItem =  items.indexOf({ item in  item.feedURL == feed.source }) else { assertionFailure("update feed not exist") ; return }
        items[indexItem].isSub = feed.isFollowed
        
    }
    
    func removeAllFeed() {
        feeds.removeAll()
    }

    func removeFeedItem(feedURL: String) {
        items =  items.filter{ $0.feedURL != feedURL }
    }
    
    func appendSubscribeItem(feedItem: FeedItem) {
    }
    
    func removeSubscribeItem(feedURL: String) {
    }
   
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

class FeedItem {
    let feedURL: String
    let feedType: FeedType
    var isSub: Bool
    
    init(feedURL: String, feedType: FeedType, isSub: Bool) {
        self.feedType = feedType
        self.feedURL = feedURL
        self.isSub = isSub
    }
    
}