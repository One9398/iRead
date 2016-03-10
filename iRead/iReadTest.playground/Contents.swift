//: Playground - noun: a place where people can play

import UIKit

let superView = UIView(frame:CGRectMake(0, 0, 200, 200))
superView.backgroundColor = UIColor.whiteColor()

let frame = CGRectMake(0, 0, 200, 100)
let view = UIView(frame: frame)

superView.addSubview(view)

view.backgroundColor = UIColor(red: 66/255.0, green: 190/255.0, blue: 252/255.0, alpha: 1.0)
view.layer.shadowColor = UIColor(red: 31/255.0, green: 31/255.0, blue: 31/255.0, alpha: 1.0).CGColor

view.layer.shadowOffset = CGSizeMake(0, 3)
view.layer.shadowRadius = 2
view.layer.shadowOpacity = 0.3
superView