//
//  BaseViewController.swift
//  iRead
//
//  Created by Simon on 16/4/13.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class BaseViewController: SegueViewController {

    var titleLabel: UILabel =  {
        let titleLabel = UILabel()
        titleLabel.font = iReadFont.boldWithSize(18)
        titleLabel.text = "标题"
        titleLabel.sizeToFit()
        titleLabel.textColor = iReadColor.themeWhiteColor
        titleLabel.textAlignment = .Center
        return titleLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        prepareNavigationBar()
        
    }
    
    func prepareNavigationBar() {
        navigationItem.titleView = titleLabel
        navigationController?.navigationBar.setBackgroundImage(UIImage(named: iReadTheme.isNightMode() ? "navigationbar_nightbg_recommand" : "navigationbar_bg_recommand"), forBarMetrics: .Default)
        navigationController!.navigationBar.shadowImage = UIImage()
        

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
