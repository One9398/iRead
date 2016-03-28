//
//  ActionView.swift
//  iRead
//
//  Created by Simon on 16/3/22.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit
import Material

enum ActionType: Int {
    case ShareContentAction = 101
    case NoteContentAction = 102
    case ModeChangeAction = 103
    case StoreContentAction = 104
}

protocol ActionViewDelegate: NSObjectProtocol {
    func acitonViewDidClickAcitonButton(acitonBtn: FabButton, actionType: ActionType)

}

class ActionView: MenuView {

    weak var actionDelegate: ActionViewDelegate?
    private var menuButton: FabButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        prepareMenuView()
        
    }

    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
        prepareMenuView()
    }

    func prepareMenuView() {
        
        let image: UIImage? = UIImage(named: "icon_menu")?.imageWithRenderingMode(.AlwaysTemplate)
        let menuBtn: FabButton = FabButton()
        menuBtn.depth = .Depth3
        menuBtn.borderColor = iReadColor.themeBlackColor
        menuBtn.pulseColor = nil
        menuBtn.tintColor = iReadColor.themeModelTinColor(dayColor: iReadColor.themeLightBlueColor, nightColor: iReadColor.themeLightWhiteColor)
        menuBtn.backgroundColor = iReadColor.themeModelBackgroundColor(dayColor: iReadColor.themeLightWhiteColor, nightColor: iReadColor.themeBlackColor)
        
        menuBtn.setImage(image, forState: .Normal)
        menuBtn.setImage(image, forState: .Highlighted)
        menuBtn.addTarget(self, action: "handleMenu", forControlEvents: .TouchUpInside)
        self.menuButton = menuBtn
        self.addSubview(menuBtn)

        let shareBtn = prepareForAcitonButton("icon_share", actionState: .ShareContentAction)
        let noteBtn = prepareForAcitonButton("icon_note", actionState: .NoteContentAction)
        let modeBtn = prepareForAcitonButton("icon_dark", actionState: .ModeChangeAction)
        let storeBtn = prepareForAcitonButton("icon_liked_normal", actionState: .StoreContentAction)

        self.menu.direction = .Up
        self.menu.baseViewSize = CGSizeMake(iReadConstant.MenuView.width, iReadConstant.MenuView.height)
        self.menu.views = [menuBtn, modeBtn, noteBtn, shareBtn, storeBtn]
    }
    
    func prepareForAcitonButton(imageName: String, actionState: ActionType) -> FabButton {
        let image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysTemplate)
        let btn2: FabButton = FabButton()
        btn2.depth = .Depth2
        btn2.pulseColor = nil
        
        if actionState == .ModeChangeAction && iReadTheme.isNightMode() {
            changeStateButton(btn2)
        } else {
            btn2.tintColor = iReadColor.themeLightBlueColor
            btn2.backgroundColor = iReadColor.themeWhiteColor
        }

        btn2.borderColor = iReadColor.themeWhiteColor
        btn2.borderWidth = 1
        btn2.tag = actionState.rawValue
        
        btn2.setImage(image, forState: .Normal)
        btn2.setImage(image, forState: .Highlighted)
        btn2.addTarget(self, action: "handleEventButton:", forControlEvents: .TouchUpInside)
        self.addSubview(btn2)
        
        return btn2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
        self.snp_makeConstraints(closure: {
            make in
            make.size.equalTo(CGSizeMake(iReadConstant.MenuView.width,  iReadConstant.MenuView.height))
            make.trailing.equalTo(-1 * iReadConstant.MenuView.menuInset)
            make.bottom.equalTo(-1 * iReadConstant.MenuView.menuInset)
        })

    }

}


extension ActionView {
    
    func changeStateButton(button: FabButton) {

        button.selected = !button.selected
        
        button.tintColor = button.selected ? iReadColor.themeLightWhiteColor : iReadColor.themeLightBlueColor
        button.backgroundColor = button.selected ? iReadColor.themeLightBlueColor : iReadColor.themeLightWhiteColor
    }
    
    func changeMenuButton(button: FabButton) {
        self.menuButton?.tintColor = button.selected ? iReadColor.themeLightWhiteColor : iReadColor.themeLightBlueColor
        self.menuButton?.backgroundColor = button.selected ? iReadColor.themeBlackColor : iReadColor.themeWhiteColor
    }
    
    internal func handleMenu() {
        if menu.opened {
            menu.close()
            (menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation: 0))
        } else {
            menu.open() { (v: UIView) in
                (v as? MaterialButton)?.pulse()
            }
            
            (menu.views?.first as? MaterialButton)?.animate(MaterialAnimation.rotate(rotation:0))
        }
    }
    
    func handleEventButton(button: FabButton) {

        if let actionType = ActionType(rawValue: button.tag) {
            switch actionType {
            case .ModeChangeAction:
                changeStateButton(button)
                changeMenuButton(button)
            case .StoreContentAction:
                changeStateButton(button)
            case .NoteContentAction:
                print("note it ")
            case .ShareContentAction:
                print("share it")
            }
            actionDelegate?.acitonViewDidClickAcitonButton(button, actionType: actionType)
            handleMenu()
            
        }

    }
   
}
