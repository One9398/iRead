//
//  iReadNetwork.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import Foundation
import Alamofire

typealias FailureHandler = (error: NSError?, message: String? ) -> Void

func fetchXMLDataFromURLString(urlString: String, failureHandle: FailureHandler, completion: (data: NSData?) -> Void) {
    
    Alamofire.request(.GET, urlString, parameters: nil)
        .response { request, response, data, error in
            
            if let error = error {
                failureHandle(error: error, message: "网络获取失败")
            } else {
                completion(data: data)
            }
    }

}