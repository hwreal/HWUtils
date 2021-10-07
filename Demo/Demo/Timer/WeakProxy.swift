//
//  WeakProxy.swift
//  Demo
//
//  Created by hwreal on 2021/9/18.
//

import UIKit

class WeakProxy: NSProxy {
    weak var target: AnyObject?
//    init(_ target: AnyObject) {
//        self.target = target
//
//    }
    class func initw(_ target: AnyObject) -> WeakProxy{
        let proxy = WeakProxy.alloc()
        proxy.target = target
        
        return proxy
    }
    
}
