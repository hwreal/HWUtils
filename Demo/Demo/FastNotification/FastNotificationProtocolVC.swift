//
//  FastNotificationProtocolVC.swift
//  Demo
//
//  Created by hwreal on 2021/9/16.
//

import UIKit
import HWUtils

class FastNotificationProtocolVC: UIViewController,FastNotificationProtocol {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        addNotification(notificationName: "abc") { noti in
            print("1 \(noti.name.rawValue)")
        }
        
        addNotification(notificationName: "abc") { noti in
            print("2 \(noti.name.rawValue)")
        }
        
        addNotification(notificationName: "def") { noti in
            print("\(noti.name.rawValue)")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.postNotification(notificationName: "abc")
            self.postNotification(notificationName: "def")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.removeNotification(notificationName: "def")
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.postNotification(notificationName: "abc")
            self.postNotification(notificationName: "def")
        }
        
        // Do any additional setup after loading the view.
    }
    
    deinit {
        print("\(self) deinit")
    }

}
