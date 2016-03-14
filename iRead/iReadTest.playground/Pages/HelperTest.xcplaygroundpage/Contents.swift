//: [Previous](@previous)

import Foundation

//: [Next](@next)

typealias CancelableBlock = (cancel: Bool) -> Void

func delayTaskExectuing(intervalTime: NSTimeInterval, block: dispatch_block_t) -> CancelableBlock {
    var resultBlock: CancelableBlock?
    
    let cancelableBlock: CancelableBlock = {
        (cancel: Bool) in
        if cancel {
            resultBlock = nil
        } else {
            dispatch_async(dispatch_get_main_queue(), block)
        }
    }

    resultBlock = cancelableBlock
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(intervalTime * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) { () -> Void in
        if let resultBlock = resultBlock {
            resultBlock(cancel: false)
        }
    }
    
    return resultBlock?
    
}

func cancleTaskExecuting(cancelableBlock: CancelableBlock?) {
    cancelableBlock?(cancel: true)
}


