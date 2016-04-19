//
//  AboutViewController.swift
//  iRead
//
//  Created by Simon on 16/4/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class AboutViewController: BaseChildViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = "关于"
        configureDataSource()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: NSStringFromClass(UITableViewCell.self))
        tableView.tableFooterView = UIView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    private var group : ProfileGroup?
    
    func configureDataSource() {
        
        let rateItem = ProfileItem(title: "去评个分呗", icon: "") {
            print("去评个分呗 ")
        }
        
        let feedbackItem = ProfileItem(title: "给予反馈", icon: "") {
            print("feedback")
        }
        
        let shareItem = ProfileItem(title: "分享应用", icon: "") {
            print("share")
        }
        
        let aboutGroup  = ProfileGroup(headerTitle: "", footerTitle: "", items: [feedbackItem, shareItem, rateItem])
        group = aboutGroup
    }
    
}

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
        
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let item = group?.items[indexPath.row]
        item?.selectedAction?()
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.setSelected(false, animated: true)
        
    }
    
}
