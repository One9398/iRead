//
//  ITNewsTableViewCell.swift
//  iRead
//
//  Created by Simon on 16/3/14.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

class ITNewsTableViewCell: MaterialTableViewCell {
    
    var viewModel:ITNewsTableViewCellViewModel?
    
    convenience init(viewModel: ITNewsTableViewCellViewModel?) {

        self.init(style: .Subtitle, reuseIdentifier: NSStringFromClass(ITNewsTableViewCell.self))
        self.viewModel = viewModel
        
        prepareForCell()
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        prepareForCell()        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func updateContentWithViewModel(vm: ITNewsTableViewCellViewModel) {
        
    }
    
    // MARK: - UI Preparation 📱

    private func prepareForCell() {
        self.selectionStyle = .None
        self.textLabel?.font = iReadFont.regual
        self.textLabel?.textColor = iReadColor.themeBlackColor
        self.detailTextLabel?.font = iReadFont.lightWithSize(14)
        self.detailTextLabel?.textColor = iReadColor.themeDarkGrayColor
        self.imageView?.layer.cornerRadius = 20
    }
}
