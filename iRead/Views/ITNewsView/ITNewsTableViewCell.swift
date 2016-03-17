//
//  ITNewsTableViewCell.swift
//  iRead
//
//  Created by Simon on 16/3/14.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material
import Kingfisher

class ITNewsTableViewCell: MaterialTableViewCell {
    
    var feedModel: FeedModel = FeedModel()
    
    convenience init(feedModel: FeedModel) {

        self.init(style: .Subtitle, reuseIdentifier: NSStringFromClass(ITNewsTableViewCell.self))
        self.feedModel = feedModel
        
//        prepareForCell()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style:.Subtitle, reuseIdentifier: reuseIdentifier)
        prepareForCell()

        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func updateContent(feedModel: FeedModel) {
        self.feedModel = feedModel
        self.textLabel?.text = feedModel.title
        self.detailTextLabel?.text = feedModel.description

        if feedModel.imagURL != "" {
            imageView?.kf_setImageWithURL(NSURL(string: feedModel.imagURL)!, placeholderImage: UIImage(named: "icon_placehold_logo2"), optionsInfo: [.Transition(ImageTransition.Fade(0.5))], completionHandler: { (image: Image?, error: NSError?, cacheType: CacheType, imageURL: NSURL?) -> () in
                
                self.imageView?.image = image?.resize(toWidth: 32)
                
            })
            
        } else {
            imageView?.image = UIImage(named: "icon_placehold_logo2")?.resize(toWidth: 32)
        }
    }

    
    // MARK: - UI Preparation 📱

    private func prepareForCell() {
        self.selectionStyle = .None
        self.textLabel?.font = iReadFont.regual
        self.textLabel?.textColor = iReadColor.themeBlackColor
        self.detailTextLabel?.font = iReadFont.lightWithSize(14)
        self.detailTextLabel?.textColor = iReadColor.themeDarkGrayColor
        self.imageView?.layer.cornerRadius = 16
    }
}
