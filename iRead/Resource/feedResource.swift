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
    case News, Tech, Life, Other,Blog
}

enum ArticleType: String {
    case FavoriteType, ToreadType, ReadType
}

enum FeedSource {
    case User(String)
    case Default
    var identifiter: String{
        switch self {
        case .User(let id):
            return id
        case .Default:
            return "god"
        }
    }
}

class FeedResource  {
    static let sharedResource = FeedResource()
    var items = [FeedItem2]()
    var subscribeItems : [FeedItem2] {
        return items.filter{ $0.isSub == true }
    }
    
    var defauktItems = [FeedItem2]()
    
    lazy var articles = [Article]()
    
    var favoriteArticles : [Article] {
        return articles.filter( {$0.isFavorited == true})
    }
    
    var toreadArticles : [Article] {
        return articles.filter( {$0.isToread == true})
    }
    
    var readArticles : [Article] {
        return articles.filter({$0.isRead == true})
    }
    
    var feeds = [FeedModel]()
    var subscirbeFeeds: [FeedModel] {
        return feeds.filter{ $0.isFollowed == true }
    }
    
    init() {
        print(iReadUserDefaults.currentUser)
    }
    
    func loadFeedItem(completion: (([FeedItem2], error: NSError?) -> ())?) {
        if iReadUserDefaults.isLogined  {
            loadUserFeedItemRemoteFile(completion)
        } else {
            loadDefaultFeedItemRemoteFile(completion)
//             loadFeedItemLocalFile(completion)
        }
    }
    
    func loadDefaultFeedItemRemoteFile(completion: (([FeedItem2], errors: NSError?) -> ())?) {
        let source = FeedSource.Default
        loadFeedItemRemoteFileFromSource(source, completion: completion)
    }
    
    func loadUserFeedItemRemoteFile(completion: (([FeedItem2], errors: NSError?) -> ())?) {
        let source = FeedSource.User(iReadUserDefaults.currentUser!.objectId)
        loadFeedItemRemoteFileFromSource(source, completion: completion)
    }
    
    func loadFeedItemRemoteFileFromSource(source: FeedSource,completion: (([FeedItem2], errors: NSError?) -> ())?) {
        print("start fetch from\(source)")
        print("服务器加载")
        
        let query = FeedItem2.query()
        query.whereKey(kSubscibeFeedItemOwnerKey, containsString: source.identifiter)
        query.cachePolicy = .NetworkElseCache
        
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?)in
            print("😎fetch \(objects!.count) items from remote")
            
            let items = objects as? [FeedItem2] ?? []
            completion?(items, errors: error)
            
            NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedItemsRemoteFetchDidFinishedNotification, object: nil)
        }

    }
    
    func loadUserArticlesFromServer(source: String, completion: (([Article], error: NSError?)->())?) {
        
        let query = Article.query()
        query.whereKey(kSubscibeFeedItemOwnerKey, containsString: source)
        query.cachePolicy = .NetworkElseCache
        query.findObjectsInBackgroundWithBlock{
            (objects: [AnyObject]?, error: NSError?) in
            print("😎fetch \(objects!.count) article from remote")
            let articles = objects as? [Article] ?? []
            completion?(articles, error: error)
            
            NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedArticlesRemoteFetchDidFinishedNotification, object: nil)
        }
    }
    
    func uploadUserArticlesToServer(userID: String, completion: ((error: NSError?) -> ())?){
        
        articles.forEach{
            $0.owner = userID
        }
        
        Article.saveAllInBackground(articles) {
            result, error in
            completion?(error: error)
        }
        
    }
    
    func uploadUserFeedItemsToServer(ownerID: String, completion: ((error: NSError?) -> ())?) {
        
        var userItems = [FeedItem2]()
        items.forEach{
            item in
            let userItem = FeedItem2.configureItemWithType(FeedType(rawValue: item.feedType)!, feedURL: item.feedURL, isSub: item.isSub, icon: item.icon, owner: ownerID)
            userItems.append(userItem)
        }
        
        items = userItems
        FeedItem2.saveAllInBackground(items){
            result, error in

            completion?(error: error)
        }
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
    func fetchArticles(articleType: ArticleType) -> [Article] {
        switch articleType {
        case .FavoriteType:
            return favoriteArticles
        case .ToreadType:
            return toreadArticles
        case .ReadType:
            return readArticles
        }
    }
    
    private func updateArticles(article: Article) {
        if articles.contains(article) {
            print("articles include it")
        } else {
            
            let exist = articles.contains{$0.title == article.title}
            if exist {
                print("文章已经存在了")
            } else {
                articles.append(article)
            }
            
        }
        article.saveArticleStateInBackground()
    }
    
    func updateFavoriteStateArticle(article: Article) {
        article.isFavorited = !article.isFavorited
        updateArticles(article)
    }
    
    func updateToreadStateArticle(article: Article) {
        article.isToread = !article.isToread
        updateArticles(article)
    }

    func updateReadStateArticle(article: Article) {
        article.isRead = true

        updateArticles(article)
    }
}

class Article: AVObject, AVSubclassing {
    @NSManaged var owner: String
    
    @NSManaged var title: String
    @NSManaged var link: String
    @NSManaged var pubDate: String
    @NSManaged var category: String
    @NSManaged var source: String
    @NSManaged var author: String
    @NSManaged var content: String
    @NSManaged var addDate: String
    @NSManaged var readDate: String
    
    @NSManaged var isRead: Bool
    @NSManaged var isFavorited: Bool
    @NSManaged var isToread: Bool
    
    static func parseClassName() -> String! {
        return "Article"
    }
    
    static func configureArticleWithLink(link: String, title: String,content: String, pubDate: String, author: String, category: String = "", source:String = "") -> Article {
        let article = Article()
       
        article.link = link.usePlaceholdStringWhileIsEmpty("未知链接")
        article.title = title.usePlaceholdStringWhileIsEmpty("未知标题")
        article.pubDate = pubDate.usePlaceholdStringWhileIsEmpty("不久前")
        article.author = author.usePlaceholdStringWhileIsEmpty("匿名")
        article.category = category.usePlaceholdStringWhileIsEmpty("未知分类")
        article.source = source.usePlaceholdStringWhileIsEmpty("未知来源")
        article.content = content
        
        article.owner = ""
        article.addDate = ""
        article.readDate = ""
        article.isRead = false
        article.isFavorited = false
        article.isToread = false
        
        return article
    }
    
    func saveArticleStateInBackground() {
        
        guard let reader = iReadUserDefaults.currentUser else { print("当前没有用户") ; return }
        
        self.owner = reader.objectId
        self.saveInBackgroundWithBlock{
            result, error in
            if filterError(error) {
                print("😎save done \(result)")
            }
        }
        
    }
    
}

let kSubscibeFeedItemOwnerKey = "owner"
class FeedItem2: AVObject, AVSubclassing {
    
    @NSManaged var feedURL: String
    @NSManaged var isSub: Bool
    @NSManaged var feedType: String
    @NSManaged var owner: String
    @NSManaged var icon: String
    
    static func parseClassName() -> String! {
        return "FeedItem"
    }
    
    static func configureItemWithType(feedType: FeedType, feedURL: String, isSub: Bool,icon: String = "", owner: String = "god") -> FeedItem2 {
        let feedItem2 = FeedItem2()
        feedItem2.feedURL = feedURL
        feedItem2.isSub = isSub
        feedItem2.feedType = feedType.rawValue
        feedItem2.owner = owner
        feedItem2.icon = icon
        
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

