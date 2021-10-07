//
//  AppDelegate.swift
//  Demo
//
//  Created by hwreal on 2021/9/16.
//

import UIKit

class Foo {
    var bb:()->Void = { }
    func exe(a: String, b: @escaping ()->Void){
        bb = b
        bb()
    }
}

class WTGCDTimer: NSObject {
    
    static var codeTimer: DispatchSourceTimer?
    
    class func start(timeInterval: TimeInterval = 1
                     , totolTimeInterval: TimeInterval = Double(MAXFLOAT),
                     animation: @escaping (_ isFinish: Bool)->()){
        
        var timeCount = totolTimeInterval
        
        WTGCDTimer.codeTimer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        
        WTGCDTimer.codeTimer?.schedule(deadline: .now(), repeating: timeInterval)
        
        var isFinish = false
        
        WTGCDTimer.codeTimer?.setEventHandler(handler: {
            
            timeCount = timeCount - timeInterval
            
            if timeCount == 0 {
                WTGCDTimer.codeTimer?.cancel()
                isFinish = true
            }
            
            DispatchQueue.main.async {
                animation(isFinish)
            }
        })
        
        WTGCDTimer.codeTimer?.resume()
    }
    
    class func stop() {
        WTGCDTimer.codeTimer?.cancel()
    }
    
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        WTGCDTimer.start { r in
//            print("gcd timer ..")
//        }
//        
//        let f = Foo()
//        f.exe(a: "hello") {
//            print("ccc")
//        }
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController =  UINavigationController(rootViewController: MainVC())
        window?.makeKeyAndVisible()
        return true
    }
    
}

