//
//  AppDelegate.swift
//  Demo
//
//  Created by hwreal on 2021/9/16.
//

import UIKit
//MARK: - Main
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
       // testGCD()
        
//        test()
        testError()
        
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.rootViewController =  UINavigationController(rootViewController: MainVC())
        window?.makeKeyAndVisible()
        return true
    }
    
}

extension AppDelegate{
    
    func testError(){
        let fm = FileManager.default
        
        do {
            try fm.copyItem(atPath: "s", toPath: "s")
        } catch let error as NSError {
            print("e is:",error)
        }
        
    }
    func testBlock(){
        
        var a = 0
        var b = 0
        let closure = { [copya = a] in
            print(copya, a, b)
        }

        a = 10
        b = 10
        closure()
        
        do {
            var car = "yadi"
            let block: (String) -> Void = {[copyCar = car] c in
                print("1drive \(copyCar), \(car), \(c)")
            }
            car = "benz"
            block(car)
        }
        
        do {
            var car = "yadi"
            let block:(String) -> Void = { [car]  c in
                print("2drive \(car), \(c)")
            }
            
            car = "benz"
            block(car)
        }
        
        do{
            var car = "大奔"
            let block = {
                print("3我开\(car)")
            }
            car = "雅迪"
            block()
        }
        
        do{
            class Car {
                var name: String = ""
            }
            let car = Car()
            car.name = "大奔"
            let block = { [car ] in
                print("4我开\(car.name)")
            }
            car.name = "雅迪"
            block()
        }
        
        do{
            class Car {
                var name: String = ""
            }
            var car = Car()
            car.name = "大奔"
            let block = { [car] in
                print("5我开\(car.name)")
            }
            car = Car()
            car.name = "雅迪"
            block()
        }
        
        do{
            class Car {
                var name: String = ""
            }
            var car = Car()
            car.name = "大奔"
            let block = { [ weak car ] in
                print("6我开\(car?.name)")
            }
            car = Car()
            car.name = "雅迪"
            block()
        }
    }
}



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


struct KFWrapper<Base>{
    let base: Base
    init(_ base: Base) {
        self.base = base
    }
}

protocol KFCompatible{}

extension KFCompatible{
    var kf: KFWrapper<Self>{
        get {KFWrapper(self)}
        set {}
    }
}

extension UIImage:KFCompatible{}
extension KFWrapper where Base == UIImage{
    var ss: Int{
        return 1
    }
}

extension UIView: KFCompatible {}
extension KFWrapper where Base: UIView{
    var s1: Int{2}
}

class AA{
    
}

class BB:AA{
    
}

extension AA: KFCompatible {}
extension KFWrapper where Base: AA{
    var v1: Int{2}
}


extension KFWrapper where Base == AA{
    var v2: Int{22}
}


protocol NumProcessor{
    var id: String{ get }
    func process(ori: Int) -> Int
}

extension NumProcessor{
    func append(another: NumProcessor) -> NumProcessor{
        let newId = "\(id)|>\(another.id)"
        
       return GeneralP(id: newId) { ori in
            return another.process(ori: process(ori: ori))
        }
        
    }
}

struct GeneralP: NumProcessor{
    let id: String
    
    let p: (Int) -> Int
    
    func process(ori: Int) -> Int {
        return p(ori)
    }
}

struct AddOneP: NumProcessor{
    let id: String
    
    func process(ori: Int) -> Int {
        return ori + 1
    }
}

struct MulitTwoP: NumProcessor{
    let id: String
    
    func process(ori: Int) -> Int {
        return ori * 2
    }
}

extension DispatchQueue{
    func safeAsync(_ block: @escaping ()->Void ){
        if self == DispatchQueue.main && Thread.isMainThread{
            block()
        }else{
            async { block() }
        }
    }
}




extension AppDelegate{
    func testGCD(){
        
        let sep1 = DispatchSemaphore(value: 0)
        getContent(url: 4) { ret in
            print(ret, Date())
            sep1.signal()
        }
        sep1.wait()
        
        let sep2 = DispatchSemaphore(value: 0)
        getContent(url: 7) { ret in
            print(ret, Date())
            sep2.signal()
        }
        sep2.wait()
        
        sToA {
            
        }
        
    }
    
    func sToA(block:@escaping ()->Void){
        let sep = DispatchSemaphore(value: 0)
        DispatchQueue.global().async {
            block()
            sep.signal()
        }
        sep.wait()
    }
    
    
    func getContent(url: UInt32, done: @escaping (String) -> Void){
        
        DispatchQueue.global().async {
            print("exec start:\(Date()), thread:\(Thread.current)")
            sleep(url)
            print("exec end:\(Date()), thread:\(Thread.current)")
            done("ret_\(url)")
        }
    }
    
    
}

