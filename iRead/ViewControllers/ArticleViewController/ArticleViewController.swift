//
//  ArticleViewController.swift
//  iRead
//
//  Created by Simon on 16/3/18.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import SnapKit
import WebKit
import SafariServices
import Material

class ArticleViewController: UIViewController {

    var feedItem: FeedItemModel!
    var feed: FeedModel?
    var feedResource = FeedResource.sharedResource
    private var fileResource = FileResource.sharedResource
    
    private lazy var articleStyle : ArticleStyle =  {
//        return ArticleStyle.Darkness
        let style: ArticleStyle = iReadTheme.isDayMode ? .Normal : .Darkness
        return style
    }()
    
    private var isScrolled = false
    private var isDecelerated = false
    private var imageModels = [ImageModel]()
    private var topBar : ArtileTopBar?
    private var actionView : ActionView?
    var iReadcontext = 222
    var scrollView = UIScrollView()
  	let diameter: CGFloat = 48
    var containerView = UIView()
    
    var destinationURL = ""
    var  loadActivity: iReadLoadView?
    
    var articleView : ArticleView = {
        let defaultConfigure = iReadWebConfiguration.sharedConfiguration
        let view = ArticleView(frame: CGRectZero, configuration:defaultConfigure)
        
        return view
        
    }()
    

   
    private var beginUpdate = false
    
    // MARK: - View Life Cycle ♻️
    
    override func loadView() {
        super.loadView()
        prepareForView()
        prepareForArticleView()
        prepareforLoadView()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        prepareForNavigationBar()
        prepareForMenuView()

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        iReadTimer.startRecordingTime()
        
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        scrollView.removeObserver(self, forKeyPath: "contentOffset", context: &iReadcontext)
        
        let timeinterval = iReadTimer.endRecodingTime()
        iReadUserDefaults.updateReadTime(timeinterval)
        print(timeinterval)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        beginUpdate = true
        scrollView.addObserver(self, forKeyPath: "contentOffset", options: [NSKeyValueObservingOptions.New, .Old], context: &iReadcontext)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Preparation 📱
    private func prepareForMenuView() {
        
        print(feedItem.isFavorite)
        let actionView = ActionView()
        if feedResource.favoriteArticles.contains({$0.title == feedItem.title}) {
            feedItem.isFavorite = true            
            actionView.updateFavoriteBtnState()
        }
        
        actionView.actionDelegate = self
        view.addSubview(actionView)
        self.actionView = actionView
        
    }
    
    private func prepareforLoadView() {
        loadActivity = iReadLoadView(activityIndicatorStyle: iReadHelp.currentDeviceIsPhone() ? .Default : .Large)
        loadActivity?.center = view.center
        view.addSubview(loadActivity!)
        loadActivity?.showLoadingDuration(0.5)
        
    }
    
    private func prepareForArticleView() {
        view.addSubview(articleView)
        articleView.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlackColor)
        articleView.scrollView.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlackColor)
        
        articleView.snp_makeConstraints(closure: {
            make in
            make.top.equalTo(self.view)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
            make.bottom.equalTo(self.view)
        })
    }

    private func prepareForNavigationBar() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        let topbar = UINib(nibName: "ArticleTopBar", bundle: nil).instantiateWithOwner(nil, options: nil).last as! ArtileTopBar
        topbar.eventHandleDelegate = self
        view.addSubview(topbar)
        self.topBar = topbar
        topbar.translatesAutoresizingMaskIntoConstraints = false
        topbar.snp_makeConstraints(closure: {
            make in
            make.leading.equalTo(self.view)
            make.top.equalTo(0)
            make.trailing.equalTo(self.view)
            make.height.equalTo(64)
            
        })
    }
    
    private func prepareForView() {
        self.view.backgroundColor = iReadColor.themeWhiteColor
    }
    
    override func preferredStatusBarUpdateAnimation() -> UIStatusBarAnimation {
        return .Fade
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }

    // MARK: - Congfigure Data
    convenience init(feedItem: FeedItemModel) {
        self.init()
        configureContent("文章", feedItem: feedItem, feedModel: nil)
    }
    
    convenience init(title: String?, feedItem model: FeedItemModel, feedModel: FeedModel) {

        self.init()
        configureContent(title, feedItem: model, feedModel: feedModel)
    }
    
    func configureContent(title: String?, feedItem model: FeedItemModel, feedModel: FeedModel?) {
        self.title = title
        feedItem = model

        let feedContent = model.description.stringByTrimmingCharactersInSet(NSCharacterSet.newlineCharacterSet())
        let feedTitle = model.title
        let feedDate = iReadDateFormatter.sharedDateFormatter.getCustomDateStringFromDateString(model.pubDate, styleString: "MM月dd日,HH点mm分")
        
        var feedAuthor = ""
        if let feedModel = feedModel {
            feedAuthor = model.author.usePlaceholdStringWhileIsEmpty(feedModel.title)
        } else {
            feedAuthor = model.author.usePlaceholdStringWhileIsEmpty("未知来源")
        }

        let htmlString = "<!DOCTYPE html><html><head><meta charset=utf-8><meta name=viewport content=\"width=device-width,initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0, user-scalable=no\"><meta http-equiv=X-UA-Compatible content=IE=edge><title></title></head><body><header style=heardInfo><a class=title>\(feedTitle)</a><a class=author>\(feedAuthor)</a><a class=pub-date>\("发布于" + feedDate)</a><div class=divider></div></header><div class=article-content>\(feedContent)</div>"
        
        articleView.loadHTMLString(htmlString, baseURL: nil)
        
        configureContentConstraint()
    }

    private func configureContentConstraint() {
        
        articleView.navigationDelegate = self
        articleView.UIDelegate = self
        articleView.scrollView.bouncesZoom = false

        articleView.scrollView.showsHorizontalScrollIndicator = false
        articleView.scrollView.showsVerticalScrollIndicator = false
        self.scrollView = articleView.scrollView
        
        addUserScriptsToUserContentController(iReadWebConfiguration.sharedConfiguration.userContentController)
        iReadWebConfiguration.sharedConfiguration.allowsInlineMediaPlayback = true
        iReadWebConfiguration.sharedConfiguration.requiresUserActionForMediaPlayback = true

    }
    
    // MARK:- Handle Event
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &iReadcontext {
            let scrollView = object as! UIScrollView
            
            if beginUpdate {
                if scrollView.dragging  {
                    hideSubviewAnimation()
                } else {
                    showSubviewAnimation()
                }
            }
            
        } else {
            super.observeValueForKeyPath(keyPath, ofObject: object, change: change, context: context)
        }
    }
    
    func loadLinkPageURLString(string: String?) {
        guard let urlStirng = string else {
            fatalError("no link load page")
        }
        
        let safariVC = SFSafariViewController(URL: NSURL(string: urlStirng)!)
        safariVC.delegate = self
        
        presentViewController(safariVC, animated: true, completion: nil)
    }
}

extension ArticleViewController : WKNavigationDelegate, WKUIDelegate, WKScriptMessageHandler {
    
    func webView(webView: WKWebView, didCommitNavigation navigation: WKNavigation!) {
        print("webview didCommitNav")
    }
    func webViewWebContentProcessDidTerminate(webView: WKWebView) {
        print("content be Terminated")
    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationAction navigationAction: WKNavigationAction, decisionHandler: (WKNavigationActionPolicy) -> Void) {

        let urlString = navigationAction.request.URLString
        print("should goto the link : " + navigationAction.request.URLString)

        if let scheme = navigationAction.request.URL?.scheme {
            if scheme == "about" {
                decisionHandler(.Allow)
                return
            } else if scheme == "mailto" {
                UIApplication.sharedApplication().openURL(navigationAction.request.URL!)
                return
            }
            
            if urlString.containsString("play") || urlString.containsString("video") || urlString.containsString("yy") {
                decisionHandler(.Allow)
                return
            } else if urlString.containsString("jpg") || urlString.containsString("png") || urlString.containsString("gif") {
                // show image
                decisionHandler(.Cancel)
                return
            }

            if let destinationURL = navigationAction.request.URL {
                self.destinationURL = destinationURL.absoluteString
            }

            iReadAlert.showInfoMessage(
                title: "需要跳转当前链接么~",
                message: "",
                dismissTitle: "返回",
                inViewController: self,
                withDoneAction:{

                    self.loadLinkPageURLString(navigationAction.request.URL?.absoluteString)
                    
                    decisionHandler(.Cancel)
                }
                , DismissAction: {
                    decisionHandler(.Cancel)
            })

            decisionHandler(.Cancel)
        }

    }
    
    func webView(webView: WKWebView, decidePolicyForNavigationResponse navigationResponse: WKNavigationResponse, decisionHandler: (WKNavigationResponsePolicy) -> Void) {
       
        print("should response : \(navigationResponse.response.URL?.URLString)")
        
        decisionHandler(.Allow)
    }
  
    func addUserScriptsToUserContentController(controller: WKUserContentController) {

        let styleScript = WKUserScript(source: fileResource.styleJSFile, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        let imgAdjustScript = WKUserScript(source: fileResource.imgAdjustJSFile, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        let dayScript = WKUserScript(source: fileResource.dayJSFile, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        let nightScript = WKUserScript(source: fileResource.nightJSFile, injectionTime: .AtDocumentStart, forMainFrameOnly: true)
        let imgFetchScript = WKUserScript(source: fileResource.imgFetchJSFile, injectionTime: .AtDocumentEnd, forMainFrameOnly: true)
        
        // 防止脚本重复加载
        if !NSUserDefaults.standardUserDefaults().boolForKey("hasStyle") {

            controller.addUserScript(styleScript)
            controller.addUserScript(imgFetchScript)
            controller.addUserScript(imgAdjustScript)
            
            if articleStyle == .Normal {
                controller.addUserScript(dayScript)
            } else {
                controller.addUserScript(nightScript)
            }

            controller.addScriptMessageHandler(self, name: "didFetchImagesOfContents")
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "hasStyle")
        }

        print(controller.userScripts)
    }

    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        
        if message.name == "didFetchImagesOfContents" {
            print("recieved message\(message.body)")
            configureImageModels(message.body)
        }
    }
    
    func configureImageModels(object: AnyObject) {
        if let array = object as? [[String: AnyObject]] {
            for entry in array {
                let image = ImageModel(title: entry["title"] as! String, urlString: entry["srcString"] as! String)
                imageModels.append(image)
            }
        }
        
    }

}


extension ArticleViewController: SFSafariViewControllerDelegate {
    
    func safariViewControllerDidFinish(controller: SFSafariViewController) {
        dismissViewControllerAnimated(false, completion: {
            print("dismissDone")
        })
    }
    
    func safariViewController(controller: SFSafariViewController, didCompleteInitialLoad didLoadSuccessfully: Bool) {
        
        print("did Load ");
    }
    
}

extension ArticleViewController: ActionViewDelegate {
    func acitonViewDidClickAcitonButton(actionBtn: FabButton, actionType: ActionType) {
        
        switch actionType {
        case .ShareContentAction:
            print("go to ShareContentAction")
        case .StoreContentAction:
            print("go to StoreContentAction")
            if actionBtn.selected {
                self.feedItem.isFavorite = true
                feedResource.appendFavoriteArticle(self.feedItem)
                self.feedItem.addDate = iReadDateFormatter.sharedDateFormatter.getCurrentDateString("MM月dd日,HH点mm分")
                
            } else {
                self.feedItem.isFavorite = false
                feedResource.removeFavoriteArticle(self.feedItem, index: nil)
            }

            
        case .ModeChangeAction:
            let changedStyle : ArticleStyle = (articleStyle == .Normal ? .Darkness : .Normal)
            topBar?.changeArticleTopBarStyle(changedStyle)
            articleStyle = changedStyle
            
            let modeJSFile = (changedStyle == .Normal ? fileResource.dayJSFile : fileResource.nightJSFile)
            articleView.evaluateJavaScript(modeJSFile, completionHandler: nil)
            print("go to ModeChangeAction")
            
        case .NoteContentAction:
            print("go to NoteContentAction")
            
        }
    }
    
}

extension ArticleViewController: ArtileTopBarDelegate {
    
    func artileTopBarClickedBackButton(aritleTopBar: ArtileTopBar, backButton: BaseButton) {

        self.navigationController?.popViewControllerAnimated(true)
        
    }
    
    func artileTopBarClickedSurfButton(arlitleTopBar: ArtileTopBar, surfButton: BaseButton) {
        loadLinkPageURLString(feedItem?.link)
        
    }
}

extension ArticleViewController {
   
    private func hideSubviewAnimation() {
        if self.topBar?.alpha == 1 {
            self.topBar?.alpha -= 0.1
            
            UIView.animateWithDuration(0.15, animations: {
                self.topBar?.alpha =  0.0
                self.actionView?.alpha = 0.0
            })
            
        }

    }
    
    private func showSubviewAnimation() {
        
        UIView.animateWithDuration(0.25, animations: {
            self.topBar?.alpha =  1.0
            self.actionView?.alpha = 1.0
        })
    }
}


/*

- (void)screenshot:(UIBarButtonItem *)sender
{
UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];

CGRect rect = [keyWindow bounds];
UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0);

CGContextRef context = UIGraphicsGetCurrentContext();
[keyWindow.layer renderInContext:context];

UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();

[[UIPasteboard generalPasteboard] setImage:image];
}

*/
