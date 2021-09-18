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

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
   
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let f = Foo()
        f.exe(a: "hello") {
            print("ccc")
        }
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController =  UINavigationController(rootViewController: MainVC())
        window?.makeKeyAndVisible()
        return true
    }

}

