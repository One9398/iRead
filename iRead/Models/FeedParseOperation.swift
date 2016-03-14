
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
    
    private var index = 0
    private var feedType: FeedType = .Other
    
    private var feedData: NSData?
    private var feedItemModels:[FeedItemModel]?
    private var feedModel: FeedModel?
    
    private let completion: (FeedModel?) -> ()

    init(feedData: NSData?, index: Int, feedType: FeedType, completion: (FeedModel?) -> ()) {

        self.feedData = feedData
        feedItemModels = [FeedItemModel]()
        feedModel = FeedModel()
        feedModel?.index = index
        feedModel?.feedType = feedType
        
        self.feedType = feedType
        self.completion = completion
        self.index = index
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
        
        parseXMLData(feedData)
        
    }

    private func parseXMLData(data: NSData) {
        
        guard let document = try? ONOXMLDocument(data: data) else {
            
            print("document create failure")
            
            state = .Finished
            return
        }
        
        guard let xmlType = document.rootElement.tag else {
            
            state = .Finished
            return
        }
        
        if xmlType == "rss" {
            parseRSSByXPath(data, document: document)
            
        } else if xmlType == "feed" {
            parseAtomByXPath(data, document: document)
        } else {
            fatalError("other xml type :" + xmlType)
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

        let linkEle = feedElement.childrenWithTag("link").last as! ONOXMLElement
        let link = linkEle["href"] as! String
        
        let imageURL = fetchStringWithElement(feedElement, XPath: "//url[1]")
//        let author = self.fetchStringWithElement(feedElement, XPath: "/feed/author/name")
//        let a = feedElement.firstChildWithXPath("//author[1]")
        let authorEle = feedElement.childrenWithTag("author").last as! ONOXMLElement
        let author = fetchStringWithElement(authorEle, tagName: "name")
        
        feedModel?.title = title
        feedModel?.description = description
        feedModel?.link = link
        feedModel?.imagURL = imageURL
        
        print("---atom---")
        print(link)
        print("---atom---")
        
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
            itemModel.description = (content != "") ? content : summary
            itemModel.category = category
            itemModel.title = title
            itemModel.author = author
            
            feedItemModels?.append(itemModel)
            
        }
        
        feedModel?.items = feedItemModels
        
        executeCompletionOnMainThread()
        
        print(feedModel)
        
    }
    
    private func executeCompletionOnMainThread() {
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            print(NSThread.currentThread())
            self.completion(self.feedModel)
            
            self.state = .Finished
            
            NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedParseOperationDidSinglyFinishedNotification, object: nil, userInfo: ["index" : self.index])
            
        })
        
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
        
        feedModel?.title = title
        feedModel?.description = description
        feedModel?.link = link
        feedModel?.imagURL = imageURL
        
        channelElement.enumerateElementsWithXPath("item") { (element, index, finished) -> Void in
            
            let itemModel = FeedItemModel()
            
            let title = self.fetchStringWithElement(element, tagName: "title")
            let link = self.fetchStringWithElement(element, tagName: "link")
            let description = self.fetchStringWithElement(element, tagName: "description")
            let pubDate = self.fetchStringWithElement(element, tagName: "pubDate")
            let author = self.fetchStringWithElement(element, tagName: "author")
            let category = self.fetchStringWithElement(element, tagName: "category")
            
            itemModel.title = title
            itemModel.link = link
            itemModel.description = description
            itemModel.pubDate = pubDate
            itemModel.author = author
            itemModel.category = category
            
            self.feedItemModels?.append(itemModel)
            
        }
        
        feedModel?.items = feedItemModels
        
        
        executeCompletionOnMainThread()
        
        print(feedModel)
    }
    
    //: MARK: - 未使用
    private func parseRSSBySearch(data: NSData) {
        guard let document = try? ONOXMLDocument(data: data) else {
            print("Feed Parse Error, document is nil")
            state = .Finished
            return
        }
        
        for element in document.rootElement.children {
            
            let element = element as! ONOXMLElement
            
            if element.tag == "channel" {
                
                for channelChild in element.children {
                    let channelChild = channelChild as! ONOXMLElement
                    let childContent = channelChild.stringValue()
                    let childTag = channelChild.tag
                    
                    if childTag.isEqualIgnoreCaseStirng("title") {
                        self.feedModel?.title = childContent
                    }
                    
                    if childTag.isEqualIgnoreCaseStirng("link") {
                        feedModel?.link = childContent
                    }
                    
                    if childTag.isEqualIgnoreCaseStirng("description") {
                        feedModel?.description = childContent
                    }
                    
                    if childTag.isEqualIgnoreCaseStirng("image") {
                        for secondChild in channelChild.childrenWithTag("url") {
                            if let secondChildElement = secondChild as? ONOXMLElement {
                                feedModel?.imagURL = secondChildElement.stringValue()
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
                            
                            feedItemModels?.append(itemModel)
                            
                        }
                    }
                    
                }
                
            }
        }
        
        feedModel?.items = feedItemModels
        feedModel?.index = index
        feedModel?.feedType = feedType
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            print(NSThread.currentThread())
            self.completion(self.feedModel)
            
            self.state = .Finished
            
            NSNotificationCenter.defaultCenter().postNotificationName(iReadNotification.FeedParseOperationDidSinglyFinishedNotification, object: nil, userInfo: ["index" : self.index])
            
        })
    }
    
}
