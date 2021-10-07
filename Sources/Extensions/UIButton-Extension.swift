//
//  UIButton-Extension.swift
//  HWUtils
//
//  Created by hwreal on 2021/9/17.
//

import Foundation
import UIKit

//public extension UIControl{
//    
//    /// Add button an action by block
//    /// - Parameters:
//    ///   - action: action block
//    ///   - controlEvents: control envent, default touchUpInside
//    func addAction(_ action:@escaping (UIControl)->(),for controlEvents: UIControl.Event = .touchUpInside){
//        self.action = action
//        self.addTarget(self, action: #selector(btnTouched(_:)), for: controlEvents)
//    }
//    
//    private struct AssociatedKey {static var actionKey: String = ""}
//
//    var action:(UIControl)->(){
//        get{objc_getAssociatedObject(self, &AssociatedKey.actionKey) as? ((UIControl)->()) ?? {_ in}}
//        set{objc_setAssociatedObject(self, &AssociatedKey.actionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC)}
//    }
//    
//    @objc func btnTouched(_ control:UIControl){
//        action(control)
//    }
//}

public class ControlProxy{
    var controlEvent: UIControl.Event
    var action:(UIControl)->()
    
    init(action:@escaping (UIControl)->(),for event: UIControl.Event) {
        self.action = action
        self.controlEvent = event
    }
    
     @objc func actionExe(_ control: UIControl){
        action(control)
    }
    
    deinit {
        print("ControlProxy deinit")
    }
}


public protocol BlockAtion {}

private var controlProxysKey: Void?

extension BlockAtion where Self: UIControl{
    
    /// Add button an action by block
    /// - Parameters:
    ///   - action: action block
    ///   - controlEvents: control envent, default touchUpInside
    public func addAction(_ action:@escaping (UIControl)->(),for controlEvents: UIControl.Event = .touchUpInside){
        let curCtlEvents = controlProxys.map{$0.controlEvent}
        if !curCtlEvents.contains(controlEvents) {
            let proxy = ControlProxy(action: action, for: controlEvents)
            self.addTarget(proxy, action: #selector(ControlProxy.actionExe(_:)), for: controlEvents)
            controlProxys += [proxy]
        }
    }
    
    public var controlProxys:[ControlProxy]{
        get{objc_getAssociatedObject(self, &controlProxysKey) as? [ControlProxy] ?? []}
        set{objc_setAssociatedObject(self, &controlProxysKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
}


extension UIControl: BlockAtion{}
