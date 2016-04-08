//
//  FavoriteFeedsController.swift
//  iRead
//
//  Created by Simon on 16/3/25.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class FavoriteFeedsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


        prepareForView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UI Preparation 📱
    private func prepareForView() {
        view.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeWhiteColor, nightColor: iReadColor.themeLightBlackColor)
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
