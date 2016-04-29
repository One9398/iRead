//
//  FeedListController.swift
//  iRead
//
//  Created by Simon on 16/3/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import Material
import MonkeyKing

class FeedListController: UIViewController {

    var feedModel: FeedModel!
    var readCount: Int {
        return articles.filter({$0.isRead == false}).count
    }

    lazy var articles = [Article]()
    private var subTitleLab : UILabel!
    private var collectionView = BaseCollectionView()
    private var feedResource = FeedResource.sharedResource

    // MARK: - View Life Cycle ♻️
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForNavigationBar()
        prepareForView()
        prepareForCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tabBarController?.tabBar.hidden = false
        if self.navigationController!.navigationBarHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        subTitleLab.text = "\(readCount)篇可阅"
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        collectionView.frame = view.bounds
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func popCurrentViewController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UI Preparation 📱
    
    private func prepareForNavigationBar() {
        print(self.navigationItem.titleView)
        self.navigationController?.navigationBar.tintColor = iReadColor.themeLightWhiteColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : iReadColor.themeLightWhiteColor]
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(assetsIdentifier: .icon_baritem_back), style: .Plain, target: self, action: #selector(FeedListController.popCurrentViewController))
        title = feedModel.title

        let subTitleLabel = UILabel()
        subTitleLabel.text = "\(readCount)篇可阅"
        subTitleLab = subTitleLabel
        subTitleLabel.font = iReadFont.lightWithSize(12)
        subTitleLabel.textColor = iReadColor.themeLightWhiteColor
        subTitleLabel.textAlignment = .Right
        subTitleLabel.frame = iReadConstant.SubtitleLabel.frame
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: subTitleLabel)
    }
    
    private func prepareForCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.spacingPreset = .Spacing2
        collectionView.contentInsetPreset = .Square3
        collectionView.showsVerticalScrollIndicator = false
        collectionView.registerClass(BaseCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(BaseCollectionViewCell.self ))
        
        view.addSubview(collectionView)
    }
    
    private func prepareForView() {
        
        view.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeWhiteColor, nightColor: iReadColor.themeLightBlackColor)
    }

    // MARK: - Configure Date 
    func configureContent(model: FeedModel) {
        feedModel = model
        articles = model.items
    }
    
}

// MARK: - Collection View DataSource & Delegate

extension FeedListController: MaterialCollectionViewDataSource, MaterialCollectionViewDelegate {
    
    func items() -> Array<MaterialDataSourceItem> {
        var items = [MaterialDataSourceItem]()
        for i in 0..<articles.count {
            let item = MaterialDataSourceItem(data: articles[i], width: 150, height: 120)
            items.append(item)
        }
        
        return items
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return articles.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
        let cell: BaseCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(BaseCollectionViewCell.self), forIndexPath: indexPath) as! BaseCollectionViewCell
        cell.actionDelegate = self
        cell.updateContent(articles[indexPath.item])
        
        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let item = articles[indexPath.row]
        let cell =  collectionView.cellForItemAtIndexPath(indexPath) as! BaseCollectionViewCell
        
        if !item.isRead {
            iReadUserDefaults.updateReadCounts()
            item.readDate = iReadDateFormatter.sharedDateFormatter.getCurrentDateString("MM月dd日,HH点mm分")
            feedResource.updateReadStateArticle(item)
            delayTaskExectuing(0.5, block: {
                cell.updateArticleReadState(item)
            })
        }
        
        let articleVC = ArticleViewController(title: title, feedItem: item, feedModel: feedModel)
        
        self.navigationController?.pushViewController(articleVC, animated: true)
        
    }
}

protocol SharableViewController {
       func showupShareText(text: String, sharedLink: String)
}

extension SharableViewController where Self:UIViewController {
    func showupShareText(text: String, sharedLink: String) {
        
        let thumbnail = UIImage(assetsIdentifier: .icon_sharedLogo)
        thumbnail.drawInRect(CGRectMake(0, 0, 100, 100))
        
        let info = MonkeyKing.Info(
            title: "来自我阅",
            description: text,
            thumbnail: thumbnail,
            media: .URL(NSURL(string: sharedLink)!)
        )
        
        let sessionMessage = MonkeyKing.Message.WeChat(.Session(info: info))
        let weChatSessionActivity = WeChatActivity(
            type: .Session,
            message: sessionMessage,
            finish: { success in
                print("share Profile to WeChat Session success: \(success)")
            }
        )
        
        let timelineMessage = MonkeyKing.Message.WeChat(.Timeline(info: info))
        let weChatTimelineActivity = WeChatActivity(
            type: .Timeline,
            message: timelineMessage,
            finish: { success in
                print("share Profile to WeChat Timeline success: \(success)")
            }
        )
        
        let activityViewController = UIActivityViewController(activityItems: [text, thumbnail], applicationActivities: [weChatSessionActivity, weChatTimelineActivity])
        
        activityViewController.completionWithItemsHandler = {
            (type: String?, completed: Bool, retrunedItems: [AnyObject]?, error: NSError? ) in
            print(completed)
            print(type)
            print(error)
            if error != nil {
                self.noticeTop("分享错误,稍后再试吧", autoClear: true, autoClearTime: 1)
            } else if completed {
                self.noticeTop("分享成功", autoClear: true, autoClearTime: 1)
            } else {
                self.noticeTop("分享取消", autoClear: true, autoClearTime: 1)
            }
            
        }
        
        if !iReadHelp.currentDeviceIsPhone() {
            activityViewController.modalPresentationStyle = .PageSheet
            activityViewController.popoverPresentationController?.sourceView = self.view
            activityViewController.popoverPresentationController?.sourceRect = CGRectMake(self.view.center.x,10,20,40)
            activityViewController.popoverPresentationController?.permittedArrowDirections = .Any
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
        
    }
    
}

extension FeedListController: SharableViewController {}

extension FeedListController: BaseCollectionViewCellProtocol {
    
    func baseCollectionViewCellSharedActionDidHandle(cell: BaseCollectionViewCell, item: Article) {
        
        let text = "\(item.title)  作者:\(item.author)\n 来自我阅的资讯分享链接\(item.link)\n"
        showupShareText(text, sharedLink: item.link)
        
    }
    
    func baseCollectionViewCellReadActionDidHandle(cell: BaseCollectionViewCell, item: Article) {
        if !iReadUserDefaults.isLogined {
            presentLoginViewControllerWhenNoUser()
        } else {
            
            if !item.isToread {
                self.noticeTop("该内容已标记为待读", autoClear: true, autoClearTime: 1)
                item.addDate = iReadDateFormatter.sharedDateFormatter.getCurrentDateString("MM月dd日,HH点mm分")
            } else {
                item.addDate = ""
            }
            
            feedResource.updateToreadStateArticle(item)
            
        }
        
    }
}
