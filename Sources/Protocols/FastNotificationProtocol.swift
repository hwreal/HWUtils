//
//  FastNotificationAble.swift
//  HWUtils
//
//  Created by hwreal on 2021/9/16.
//

import Foundation

public typealias NotificationHandler = (Notification) -> ()

public class NotificationProxy {
    
    var notificationName: String
    var handler: NotificationHandler
    
    init(notiName: String, handler: @escaping NotificationHandler) {
        self.notificationName = notiName
        self.handler = handler
        
        NotificationCenter.default.addObserver(self, selector: #selector(reciveNotification(_:)), name: NSNotification.Name(notificationName), object: nil)
    }
    
    @objc func reciveNotification(_ noti: Notification){
        handler(noti)
    }
    
    deinit {
        print("\(self) deint, remove noti:\(notificationName)")
        NotificationCenter.default.removeObserver(self)
    }
}

public protocol FastNotificationProtocol {}

private var notificationProxysKey:Void?

public extension FastNotificationProtocol {
    
    var notificationProxys: [NotificationProxy]{
        get{ objc_getAssociatedObject(self, &notificationProxysKey) as? [NotificationProxy] ?? [] }
        set{ objc_setAssociatedObject(self, &notificationProxysKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
    
    func addNotification(notificationName: String, handler: @escaping NotificationHandler){
        var tmpSelf = self
        let curNotiNames = tmpSelf.notificationProxys.map { $0.notificationName}
        if !curNotiNames.contains(notificationName) {
            tmpSelf.notificationProxys += [NotificationProxy(notiName: notificationName, handler: handler)]
        }
    }
    
    func removeNotification(notificationName: String){
        var tmpSelf = self
        tmpSelf.notificationProxys.removeAll { $0.notificationName == notificationName}
    }
    
    func postNotification(notificationName: String, object: Any? = nil, userInfo:[AnyHashable:Any]? = nil){
        NotificationCenter.default.post(name: NSNotification.Name(notificationName), object: object, userInfo: userInfo)
    }
}
