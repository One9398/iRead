//
//  SubFeedCell.swift
//  iRead
//
//  Created by Simon on 16/3/28.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class SubFeedCell: FeedBaseTableViewCell {
    

    override func updateContent(feedModel: FeedModel) {
        
        super.updateContent(feedModel)
       
        let feedDate = (feedModel.items![0] as FeedItemModel).pubDate.usePlaceholdStringWhileIsEmpty(feedModel.lastDate)
        
        let styleDate = iReadDateFormatter.sharedDateFormatter.getCustomDateStringFromDateString(feedDate, styleString: "MM-dd / HH:mm")
        
        self.detailTextLabel?.text = styleDate + feedModel.description
    }
    
}
