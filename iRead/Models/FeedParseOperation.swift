
//
//  FeedParseOperation.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation
import Ono



protocol FeedParseOperationDataPorvider {
    var parseData: NSData? { get }
}

class FeedParseOperation: ConcurrentOperation {
    
    enum iReadParseError: ErrorType {
        case DocumentError(FeedItem2)
        case RootElementError(FeedItem2)
        case XMLTypeError(FeedItem2)
        
        var desc : String {
            switch self {
            case .DocumentError(let item):
                return "\(item.feedURL) 文档解析错误"
            case .RootElementError(let item):
                return "\(item.feedURL) 根元素解析错误"
            case .XMLTypeError(let item):
                return "\(item.feedURL) 类型解析错误"
            }
        }
    }
    
    private var feedType: FeedType = .Other
    
    private var feedData: NSData?
    private var feedItemModels:[FeedItemModel]
    private var feedModel: FeedModel
    private let feedItem: FeedItem2
    private var document: ONOXMLDocument?
    
    private let completion: ((FeedModel?) -> ())?
    private let failure: FailureHandler?

    init(feedData: NSData?, feedItem: FeedItem2, failure: FailureHandler?, completion: ((FeedModel?) -> ())?) {
       
        self.feedItem = feedItem
        self.feedData = feedData
        feedItemModels = [FeedItemModel]()
        
        feedModel = FeedModel()
        
        feedModel.feedType = FeedType(rawValue:feedItem.feedType)!
        feedModel.source = feedItem.feedURL
        feedModel.isFollowed = feedItem.isSub
 
        self.feedType = FeedType(rawValue:feedItem.feedType)!
        self.completion = completion
        self.failure = failure
        
        super.init()

    }
    
    override func main() {

        if cancelled {
            state = .Finished
            return
        }
        
        // 由于Operation的依赖关系,所解析要Data由遵守FeedParseOperationDataPorvider的对象提供
        let parseData: NSData?
        if let feedData = feedData {
            parseData = feedData
        } else {
            let dataProvider = dependencies.filter{ $0 is FeedParseOperationDataPorvider }.first as? FeedParseOperationDataPorvider
            parseData = dataProvider?.parseData
        }
        
        guard let feedData = parseData else {
            state = .Finished
            return
        }
        
        do {
             try parseXMLData(feedData)
        } catch let error as iReadParseError {
            
            let aError = NSError(domain: "com.iRead.simon", code: 2222, userInfo: [NSLocalizedDescriptionKey : error.desc])
            dispatch_async(dispatch_get_main_queue(), {
                self.postDocumentParseErrorNotification(self.feedItem)
                self.failure!(error: aError, message: "数据解析失败")
                self.state = .Finished
            })
            
        } catch {
            fatalError("other xml type :")
        }
        
    }

    private func parseXMLData(data: NSData) throws  {
        
        do {
            
            self.document = try ONOXMLDocument(data: data)
            
        } catch{
            throw iReadParseError.DocumentError(feedItem)
        }

        let doc = self.document!
        if doc.rootElement == nil {
            throw iReadParseError.RootElementError(feedItem)
        }
        
        guard let xmlType = doc.rootElement.tag else {
            throw iReadParseError.XMLTypeError(feedItem)
        }
        
        if xmlType == "rss" {
            parseRSSByXPath(data, document: doc)
//            parseRSSBySearch(data, document: document)
        } else if xmlType == "feed" {
            parseAtomByXPath(data, document: doc)
    
        } else {
            throw iReadParseError.XMLTypeError(feedItem)
//            fatalError("other xml type :" + xmlType)
        }

    }
    
}

//: MARK: - ATOM解析
extension FeedParseOperation {
    private func parseAtomByXPath(data: NSData, document: ONOXMLDocument) {
        guard let feedElement = document.rootElement else {
            fatalError("rootElement invaild")
        }
        
        let title = fetchStringWithElement(feedElement, tagName: "title")
        let description = fetchStringWithElement(feedElement, tagName: "subtitle")
        let lastDate = fetchStringWithElement(feedElement, tagName: "updated")
       
        let linkEle = feedElement.childrenWithTag("link").last as! ONOXMLElement
        let link = linkEle["href"] as! String
        
        let imageURL = fetchStringWithElement(feedElement, XPath: "//url[1]")
        let authorEle = feedElement.childrenWithTag("author").last as! ONOXMLElement
        let author = fetchStringWithElement(authorEle, tagName: "name")

        
        feedModel.title = title
        feedModel.description = description
        feedModel.link = link
        feedModel.imagURL = imageURL
        feedModel.lastDate = lastDate
        
        let entries = feedElement.childrenWithTag("entry") as! [ONOXMLElement]
        
        for entry in entries {
            let title = fetchStringWithElement(entry, tagName: "title")
            
            let link = entry.firstChildWithTag("link").attributes ["href"] as! String
            
            let published = self.fetchStringWithElement(entry, tagName: "published")

            let content = self.fetchStringWithElement(entry, tagName: "content")
            let summary = self.fetchStringWithElement(entry, tagName: "summary")
            
            let category = entry.firstChildWithTag("category").attributes ["term"] as! String
            
            let itemModel = FeedItemModel()
            
            itemModel.link = link
            itemModel.pubDate = published
            itemModel.description = (content.isEmpty) ? summary : content
            itemModel.category = category
            itemModel.title = title
            itemModel.author = author
            
            feedItemModels.append(itemModel)
            
        }
        
        feedModel.items = feedItemModels
        executeCompletionOnMainThread()
    }
    
    private func executeCompletionOnMainThread() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in

            self.completion?(self.feedModel)
            
            self.state = .Finished
            
            // 通知混乱Bug to fix
//            NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedParseOperationDidSinglyFinishedNotification, object: nil, userInfo: ["index" : self.index])
            
        })
        
    }
    
    func postDocumentParseErrorNotification(item: FeedItem2) {
        NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedParseOperationDidSinglyFailureNotification, object: item)
    }
}

//: MARK: - RSS解析
extension FeedParseOperation {
    
    private func fetchStringWithElement(ele: ONOXMLElement!, tagName: String) -> String {
        
        let resultEle = ele.firstChildWithTag(tagName)
        return  (resultEle != nil) ? resultEle.stringValue() : ""
    }
    
    private func fetchStringWithElement(ele: ONOXMLElement!, XPath: String) -> String {
        
        let resultEle = ele.firstChildWithXPath(XPath)
        return  (resultEle != nil) ? resultEle.stringValue() : ""
    }
    
    private func parseRSSByXPath(data: NSData, document: ONOXMLDocument) {
        
        let channelElement = document.rootElement.children.last as! ONOXMLElement
        
        let title = fetchStringWithElement(channelElement, tagName: "title")
        let link = fetchStringWithElement(channelElement, tagName: "link")
        let description = fetchStringWithElement(channelElement, tagName: "description")
        let imageURL = fetchStringWithElement(channelElement, XPath: "//url[1]")
        let lastDate = fetchStringWithElement(channelElement, tagName: "lastBuildDate").usePlaceholdStringWhileIsEmpty(fetchStringWithElement(channelElement, tagName: "pubDate"))

        feedModel.title = title
        feedModel.lastDate = lastDate
        feedModel.description = description
        feedModel.link = link
        feedModel.imagURL = imageURL
        
        channelElement.enumerateElementsWithXPath("item") { (element, index, finished) -> Void in
            
            let itemModel = FeedItemModel()
            
            let title = self.fetchStringWithElement(element, tagName: "title")
            let link = self.fetchStringWithElement(element, tagName: "link")
            let description = self.fetchStringWithElement(element, tagName: "description")
            let pubDate = self.fetchStringWithElement(element, tagName: "pubDate")
            let author = self.fetchStringWithElement(element, tagName: "author")
            let source = self.fetchStringWithElement(element, tagName: "source")
            let category = self.fetchStringWithElement(element, tagName: "category")
            let creator = self.fetchStringWithElement(element, tagName: "creator")
            let content = self.fetchStringWithElement(element, tagName: "encoded")
            
            let image = element.firstChildWithXPath("./img[@*]")
            if image != nil {
                print(image)
            }
            
            itemModel.title = title
            itemModel.link = link
            itemModel.description = content.isEmpty ? description : content
            itemModel.pubDate = pubDate
            
            itemModel.author = (author.isEmpty) ? creator : author
            itemModel.category = category
            itemModel.source = source
            self.feedItemModels.append(itemModel)
            
        }
        
        feedModel.items = feedItemModels
        
        
        executeCompletionOnMainThread()
        
    }
    
    //: MARK: - 未使用
    
    private func parseRSSBySearch(data: NSData, document: ONOXMLDocument) {

        for element in document.rootElement.children {
            
            let element = element as! ONOXMLElement
            
            if element.tag == "channel" {
                
                for channelChild in element.children {
                    let channelChild = channelChild as! ONOXMLElement
                    let childContent = channelChild.stringValue()
                    let childTag = channelChild.tag
                    
                    if childTag.isEqualIgnoreCaseStirng("title") {
                        self.feedModel.title = childContent
                    }
                    
                    if childTag.isEqualIgnoreCaseStirng("link") {
                        feedModel.link = childContent
                    }
                    
                    if childTag.isEqualIgnoreCaseStirng("description") {
                        feedModel.description = childContent
                    }
                    
                    if childTag.isEqualIgnoreCaseStirng("image") {
                        for secondChild in channelChild.childrenWithTag("url") {
                            if let secondChildElement = secondChild as? ONOXMLElement {
                                feedModel.imagURL = secondChildElement.stringValue()
                            }
                        }
                    }
                    
                    // 解析Item
                    if childTag.isEqualIgnoreCaseStirng("item") {
                        let itemModel = FeedItemModel()
                        
                        for channelItem in channelChild.children {
                            
                            let channelItem = channelItem as! ONOXMLElement
                            let childContent = channelItem.stringValue()
                            let childTag = channelItem.tag
                            
                            if childTag.isEqualIgnoreCaseStirng("link") {
                                itemModel.link = childContent
                            }
                            
                            if childTag.isEqualIgnoreCaseStirng("title") {
                                itemModel.title = childContent
                            }
                            
                            if childTag.isEqualIgnoreCaseStirng("author") {
                                itemModel.author = childContent
                            }
                            
                            if childTag.isEqualIgnoreCaseStirng("pubDate") {
                                itemModel.pubDate = childContent
                            }
                            
                            if childTag.isEqualIgnoreCaseStirng("description") {
                                itemModel.description = childContent
                            }
                            
                            if childTag.isEqualIgnoreCaseStirng("category") {
                                itemModel.category = childContent
                            }
                            
                            feedItemModels.append(itemModel)
                            
                        }
                    }
                    
                }
                
            }
        }
        
        feedModel.items = feedItemModels
        feedModel.feedType = feedType
        
        executeCompletionOnMainThread()
    }
    
}