//
//  BaseChildViewController.swift
//  iRead
//
//  Created by Simon on 16/4/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class BaseChildViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(assetsIdentifier: .icon_baritem_back), style: .Plain, target: self, action: "popCurrentViewController")
    }
    func popCurrentViewController() {
        self.navigationController?.popViewControllerAnimated(true)
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
