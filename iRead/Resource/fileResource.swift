//
//  fileResource.swift
//  iRead
//
//  Created by Simon on 16/4/8.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation

struct FileResource {
    
    static let sharedResource = FileResource()
    
    init() {
        
    }
   
    lazy var imgAdjustJSFile : String = {
        let file = try! NSString(contentsOfURL: (NSBundle.mainBundle().URLForResource("imgAdjust", withExtension: "js"))!, encoding: NSUTF8StringEncoding)
        return file as String
    }()
    
   
    lazy var dayJSFile : String = {
        let file = try! NSString(contentsOfURL: (NSBundle.mainBundle().URLForResource("day", withExtension: "js"))!, encoding: NSUTF8StringEncoding)
        return file as String
    }()
    
    lazy var nightJSFile : String = {
        let file = try! NSString(contentsOfURL: (NSBundle.mainBundle().URLForResource("night", withExtension: "js"))!, encoding: NSUTF8StringEncoding)
        return file as String
    }()
    
   
    lazy var imgFetchJSFile : String = {
        let file = try! NSString(contentsOfURL: (NSBundle.mainBundle().URLForResource("fetchImages", withExtension: "js"))!, encoding: NSUTF8StringEncoding)
        return file as String
    }()
    
    lazy var styleJSFile : String = {
        let file = try! NSString(contentsOfURL: (NSBundle.mainBundle().URLForResource("style", withExtension: "js"))!, encoding: NSUTF8StringEncoding)
        return file as String
    }()
}