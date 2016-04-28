//
//  AboutViewController.swift
//  iRead
//
//  Created by Simon on 16/4/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import LeanCloudFeedbackDynamic

class AboutViewController: BaseChildViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = "关于"
        configureDataSource()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.tableFooterView = UIView()
        view.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlackColor)
        tableView.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlackColor)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    private var group : ProfileGroup?
    
    func configureDataSource() {
        
        let rateItem = ProfileItem(title: "去评个分呗", icon: "") {
            UIApplication.sharedApplication().openURL(NSURL(string:iReadConfigure.rateAppLink)!)
        }
        
        let feedbackItem = ProfileItem(title: "给予反馈", icon: "") {
            [unowned self] in
            
            print("feedback")
            let agent = LCUserFeedbackAgent.sharedInstance()
            
            agent.showConversations(self, title: "意见反馈", contact: "")
        }
        
        let shareItem = ProfileItem(title: "分享应用", icon: "") {
            [unowned self] in
            let link = iReadConfigure.appstoreLink
            let text = "前往AppStore\(link),欢迎下载我阅App表示支持"
            self.showupShareText(text, sharedLink: link)
        }
        
        let aboutGroup  = ProfileGroup(headerTitle: "", footerTitle: "", items: [feedbackItem, shareItem, rateItem])
        group = aboutGroup
    }
    
}

extension AboutViewController : SharableViewController {}

extension AboutViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return group!.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(UITableViewCell.self))
        cell?.accessoryType = .DisclosureIndicator
        cell?.textLabel?.text = group?.items[indexPath.row].title
        cell?.textLabel?.font = iReadFont.regualWithSize(14)
        cell?.textLabel?.textColor = iReadColor.themeDarkGrayColor
        cell?.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeLightBlackColor)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = group?.items[indexPath.row]
        item?.selectedAction?()
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
    }
    
}
