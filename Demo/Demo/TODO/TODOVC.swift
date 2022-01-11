//
//  TODOVC.swift
//  Demo
//
//  Created by hwreal on 2021/10/13.
//

import UIKit

protocol TargetAction {
    func performAction()
}

struct TargetActionWrapper<T: AnyObject, C: UIControl> : TargetAction {
    weak var target: T?
    weak var control: C?
    let action: (T) -> (C?) -> ()
    
    func performAction() -> () {
        if let t = target {
            action(t)(control)
        }
    }
}

enum ControlEvent {
    case touchUpInside
    case valueChanged
    // ...
}

class Control {
    
    var actions:[ControlEvent: TargetAction] = [:]
    
    func setTarget<T: AnyObject>(_ target: T, action: @escaping (T) -> (UIControl?) -> (), controlEvent: ControlEvent) {
        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
    }
    
    func removeTargetForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent] = nil
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent) {
        actions[controlEvent]?.performAction()
    }
}

class MyCls{
    func method(_ num1: Int, _ num2: Int) -> Int{
        return num1 + num2
    }
}


private var actionsKey: Void?

extension UIControl{
   
    var actions:[ControlEvent: TargetAction]{
        get {objc_getAssociatedObject(self, &actionsKey) as? [ControlEvent: TargetAction] ?? [:]}
        set {objc_setAssociatedObject(self, &actionsKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)}
    }
    
    
    func setTarget<T: AnyObject>(_ target: T, action:@escaping (T) -> (UIControl?) -> (), controlEvent: ControlEvent){
//        actions[controlEvent] = TargetActionWrapper(target: target, action: action)
        actions[controlEvent] = TargetActionWrapper(target: target, control: self, action: action)
    }
    
    func performActionForControlEvent(controlEvent: ControlEvent){
        actions[controlEvent]?.performAction()
    }
    
}

class TODOVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let btn = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
        btn.backgroundColor = .cyan
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("AlertTwo", for: .normal)
        view.addSubview(btn)
//        btn.addTarget(<#T##target: Any?##Any?#>, action: <#T##Selector#>, for: <#T##UIControl.Event#>)
       // btn.setTarget(self, action: TODOVC.btnTouched as! (TODOVC) -> (UIControl?) -> () , controlEvent: .touchUpInside)
        
        
        let aa = TODOVC.btnTouched
        
        
        let m = MyCls.method
        let myClassObj = MyCls()
        let mm = m(myClassObj)
        let ret = mm(3,22)
        print(ret)
        
        let m2: (MyCls) -> (Int,Int) -> Int = { obj in
            let method = obj.method
            return method
        }
        
        
        
//        let control = Control()
//        control.setTarget(self, action:TODOVC.tapAction, controlEvent: .touchUpInside)
//        control.performActionForControlEvent(controlEvent: .touchUpInside)
        
        // control.setTarget(<#T##target: T##T#>, action: <#T##(T) -> () -> ()#>, controlEvent: <#T##ControlEvent#>)
        let ac = TODOVC.tapAction
        
        
        let f1 = TODOVC.foo1
        let f2 = TODOVC.foo2
        
        f2(self)()
        foo2()
        
        let f3 = Self.foo2
        
        f3(self as! Self)()
    }
    
    func btnTouched(btn: UIButton){
        
    }
    
    func tapAction() {
        print("tapped!!!")
    }
    
    func foo1(){
        
    }
    
    func foo2(){
        print("foo2 exe")
    }
    
}
