//
//  ProfileView.swift
//  iRead
//
//  Created by Simon on 16/4/15.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Kingfisher
class ProfileView: UIView {

    @IBOutlet weak var nickImageView: UIImageView!
    @IBOutlet weak var countsLabel: UILabel!
    @IBOutlet weak var readtimesLabel: UILabel!
    @IBOutlet weak var countsDataLabel: UILabel!
    @IBOutlet weak var timesDataLabel: UILabel!

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    
    override func awakeFromNib() {
        super.awakeFromNib()
   
        readtimesLabel.textColor = iReadColor.themeDarkGrayColor
        countsLabel.textColor = iReadColor.themeDarkGrayColor
        countsDataLabel.textColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlackColor, nightColor: iReadColor.themeGrayColor)
        timesDataLabel.textColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlackColor, nightColor: iReadColor.themeGrayColor)
        
        backgroundColor = iReadColor.defaultBackgroundColor
        nickImageView.clipsToBounds = true
        nickImageView.layer.cornerRadius = 50
        
    }
    
    func updateProfile(totalReadCounts readCounts: String, readTimes: String, imageURLString: String) {
        countsDataLabel.text = readCounts
        timesDataLabel.text = readTimes
        print(imageURLString)
        nickImageView.kf_setImageWithURL(NSURL(string: imageURLString)!, placeholderImage: UIImage(assetsIdentifier: .launch_logo), optionsInfo: [.Transition(ImageTransition.Fade(0.3))], completionHandler: { (image: Image?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) -> () in
            print("error: \(error?.localizedDescription)")
        })

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

}
