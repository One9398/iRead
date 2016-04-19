//
//  ProfileViewController.swift
//  iRead
//
//  Created by Simon on 16/4/13.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class ProfileViewController: BaseTopViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var profileView: ProfileView = {
        let view = UINib(nibName: "ProfileView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ProfileView
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        prepareForTableView()
        prepareForProfileView()
        
        configureDataSource()
        
        titleLabel.text = "个人"
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        updateProfileContent()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    private var groups = [ProfileGroup]()
    
    func configureDataSource() {
        
        let historyItem = ProfileItem(title: "历史浏览", icon: "icon_profile_history") {
            [unowned self] in
            // presentHistoryViewController
            let historyVC = HistoryViewController()
            self.navigationController?.pushViewController(historyVC, animated: true)
            
        }
       
        let preferenceGroup = ProfileGroup(headerTitle: "", footerTitle: "", items: [historyItem])
        groups.append(preferenceGroup)
        
        var readModeItem = ProfileItem(title: "无图阅读", icon: "icon_profile_pic", showSwitch: true, switchAction: {
            isOn in
            print(isOn)
            
            iReadUserDefaults.updateReadMode()
            self.noticeTop("无图阅读模式已\(isOn ? "打开" : "关闭")", autoClear: true, autoClearTime: 1)
            
        })
        
        readModeItem.isOn = iReadUserDefaults.isReadModeOn
        
        var themeModeItem = ProfileItem(title: "自动夜间模式", icon: "icon_profile_autonight", showSwitch: true, switchAction: {
             [unowned self] isOn in
            
            print(isOn)
            iReadUserDefaults.updateThemeMode()
            self.noticeTop("自动夜间模式已\(isOn ? "打开" : "关闭")", autoClear: true, autoClearTime: 1)
            // while false : close mode
            // while true : open mode
            
        })
        themeModeItem.isOn = iReadUserDefaults.isThemeModeOn        
        
        let switchGroup = ProfileGroup(headerTitle: "无图阅读更省流量", footerTitle: "打开后根据当地时间自动切换主题模式", items: [readModeItem, themeModeItem])
        groups.append(switchGroup)
       
        let aboutItem = ProfileItem(title: "关于", icon: "icon_profile_about", selectedAction: {
            [unowned self] in
            // present AboutViewController
            self.performSegueWithIdentifier("AboutViewController", sender: nil)
        })
        
        let OtherGroup = ProfileGroup(headerTitle: "", footerTitle: "", items: [aboutItem, ])
        groups.append(OtherGroup)
        
    }

    private func prepareForTableView() {
        tableView.registerClass(ProfileSettingCell.self, forCellReuseIdentifier: NSStringFromClass(ProfileSettingCell.self))
        tableView.backgroundColor = iReadColor.defaultBackgroundColor
        tableView.tableFooterView = UIView()
        tableView.tableHeaderView = profileView
        tableView.separatorStyle = .None
        
    }
    
    private func prepareForProfileView() {
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileView.snp_makeConstraints(closure: {
            make in
            make.height.equalTo(iReadConstant.ProfileView.height)
            make.width.equalTo(self.tableView)
            make.leading.trailing.equalTo(self.tableView)
        })
        
    }
    
    private func updateProfileContent() {

        profileView.updateProfile(
            totalReadCounts: iReadUserDefaults.totalReadCountsString(),
            readTimes: iReadUserDefaults.totalReadTimesString(),
            imageURLString: iReadUserDefaults.avaterIconURLString()
        )
    }
    
}

extension ProfileViewController : UITableViewDelegate, UITableViewDataSource {

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return groups.count

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return groups[section].items.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return iReadConstant.ProfileTabel.ProfileCellHeight
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let profileItem = groups[indexPath.section].items[indexPath.row]
        
//        let cell = tableView.dequeueReusableCellWithIdentifier(NSStringFromClass(ProfileSettingCell.self)) as! ProfileSettingCell
//        cell.configureCellContent(profileItem: profileItem)
        let cell = ProfileSettingCell(profileItem: profileItem)
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let profileItem = groups[indexPath.section].items[indexPath.row]
        profileItem.selectedAction?()
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return iReadConstant.ProfileView.bottomMargin
        }
        
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groups[section].headerTitle
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return groups[section].footerTitle
    }

}

