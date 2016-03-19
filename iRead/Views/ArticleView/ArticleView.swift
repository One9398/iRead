//
//  ArticleView.swift
//  iRead
//
//  Created by Simon on 16/3/18.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import DTFoundation

class ArticleView: DTAttributedTextContentView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        DTAttributedTextContentView.setLayerClass(DTTiledLayerWithoutFade.self)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
    


    

}
