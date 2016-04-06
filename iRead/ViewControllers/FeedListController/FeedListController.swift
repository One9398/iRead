//
//  FeedListController.swift
//  iRead
//
//  Created by Simon on 16/3/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material
class FeedListController: UIViewController {

    var feedModel: FeedModel?
    var feedItems: [FeedItemModel]?
    private var collectionView = BaseCollectionView()

    // MARK: - View Life Cycle ♻️
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        prepareForNavigationBar()
        prepareForTabBar()
        prepareForView()
        prepareForCollectionView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.navigationController!.navigationBarHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
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
    
    // MARK: - UI Preparation 📱
    
    private func prepareForNavigationBar() {
        print(self.navigationItem.titleView)
        self.navigationController?.navigationBar.tintColor = iReadColor.themeLightWhiteColor
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : iReadColor.themeLightWhiteColor]

    }
    
    private func prepareForTabBar() {
        hidesBottomBarWhenPushed = true;

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
        feedItems = feedModel?.items
        title = model.title
    }
    
}


// MARK: - Collection View DataSource & Delegate

extension FeedListController: MaterialCollectionViewDataSource, MaterialCollectionViewDelegate {
    
    func items() -> Array<MaterialDataSourceItem> {
        var items = [MaterialDataSourceItem]()
        guard let feedItems = feedItems else {
            fatalError("Data source wrong")
        }
        for i in 0..<feedItems.count {
            let item = MaterialDataSourceItem(data: feedItems[i], width: 150, height: 120)
            items.append(item)
        }
        
        return items
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        guard let count = feedItems?.count else {
            return 0
        }
        
        return count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
      
        let cell: BaseCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(NSStringFromClass(BaseCollectionViewCell.self), forIndexPath: indexPath) as! BaseCollectionViewCell
        cell.actionDelegate = self
        cell.updateContent(feedItems?[indexPath.item])
        
        return cell
    }
    

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let item = feedItems![indexPath.row]
        let cell =  collectionView.cellForItemAtIndexPath(indexPath) as! BaseCollectionViewCell
        if !item.isRead {
            
            delayTaskExectuing(0.5, block: {
                cell.updateArticleReadState(item)
            })
        }
        
        let articleVC = ArticleViewController(title: title, feedItem: item, feedModel: feedModel!)
        
        self.navigationController?.pushViewController(articleVC, animated: true)
        
    }
}


extension FeedListController: BaseCollectionViewCellProtocol {
    func baseCollectionViewCellSharedActionDidHandle(cell: BaseCollectionViewCell, item: FeedItemModel?) {
        print("share the \(item)")
    }
    
    func baseCollectionViewCellReadActionDidHandle(cell: BaseCollectionViewCell, item: FeedItemModel?) {
        print("unread the \(item?.title)")
    }
}
