//
//  UserViewController.swift
//  iRead
//
//  Created by Simon on 16/4/21.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class UserViewController: BaseChildViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        resignCurrrentResponser()
    }
    
    func resignCurrrentResponser() {
        view.endEditing(true)
    }
    
}
