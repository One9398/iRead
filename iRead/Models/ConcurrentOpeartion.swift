//
//  ConcurrentOpeartion.swift
//  iRead
//
//  Created by Simon on 16/3/11.
//  Copyright © 2016年 Simon. All rights reserved.
//

import UIKit

class ConcurrentOperation: NSOperation {
    enum State: String {
        case Ready,Executing, Finished
        
        private var keyPath: String {
            return "is" + rawValue
        }
    }
    
    var state = State.Ready {
        willSet {
            willChangeValueForKey(newValue.keyPath)
            willChangeValueForKey(state.keyPath)
        }
        
        didSet {
            didChangeValueForKey(oldValue.keyPath)
            didChangeValueForKey(state.keyPath)
        }
    }
    
    override var asynchronous: Bool {
        return true
        
    }
    
    override var ready: Bool {
        return super.ready && state == .Ready
    }
    
    override var executing: Bool {
        return state == .Executing
    }
    
    override var finished: Bool {
        return state == .Finished
    }
    
    
    override func start() {
        if cancelled {
            state = .Finished
            return
        }
        
        main()
        
    }
    
    override func cancel() {
        state = .Finished
    }
    
}

