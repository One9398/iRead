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
    
    let initialDataSource: [FeedItem] = {
        return FeedResource.sharedResource.items
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCardView()
        prepareTableView()
        
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
        
        cardView.detailView = tableView
        
        let refreshButton = BaseButton(normalImg: "icon_refresh_normal", highlightImg: "icon_refresh_highlight", target: self, action: "refreshButtonClicked:")
        cardView.leftButtons = [refreshButton]

        let plusButton = BaseButton(normalImg: "icon_add_normal", highlightImg: "icon_add_highlight", target: self, action: "plusButtonClicked:")
        cardView.rightButtons = [plusButton]
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardView)
        
        MaterialLayout.alignToParent(view, child: cardView, left: 20, right: 20, top: 20, bottom: 64)
        
    }
    
    private func prepareTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ITNewsTableViewCell.self, forCellReuseIdentifier: "ITNewsTableViewCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .None
        
    }
    
    func plusButtonClicked(sender: NSObject) {
        print(__FUNCTION__)
    }
    
    func refreshButtonClicked(sender: NSObject) {
        print(__FUNCTION__)
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        view.layoutIfNeeded()
        print("rotation bug need to fix")
        
    }

}

extension ITNewsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return initialDataSource.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let item = initialDataSource[indexPath.row]
        let cell = ITNewsTableViewCell(viewModel: nil)
        
        cell.textLabel?.text = item.feedType.rawValue
        cell.detailTextLabel?.text = item.feedURL
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
}
