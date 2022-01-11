//
//  Promise.swift
//  Demo
//
//  Created by hwreal on 2021/10/24.
//

import Foundation

enum Status<Value>{
    case pending
    case fulfilled(Value)
    case rejected(Error)
}

class Promise<Value>{
    
    var status: Status<Value> = .pending
    
    var failCallback: (Error) -> Void = {_ in }
    
    let work:(@escaping (Value)->Void, @escaping (Error)->Void ) -> Void
    
    init(_ work:@escaping (_ success:@escaping (Value)->Void, _ failure:@escaping (Error)->Void ) -> Void) {
        self.work = work
    }
    
    func flatMap<NewValue>(_ transform:@escaping (Value) -> Promise<NewValue>) -> Promise<NewValue>{
        return Promise<NewValue>.init { success, failure in
            self.then { v in
                let newPromise = transform(v)
                newPromise.then(success).catch(failure)
            }.catch(failure)
        }
    }
    
    @discardableResult
    func then(_ success:@escaping (Value) -> Void) -> Self{
        work { v in
            self.status = .fulfilled(v)
            success(v)
        } _: { e in
            self.status = .rejected(e)
            self.failCallback(e)
        }
        
        return self
    }
    
    @discardableResult
    func `catch`(_ failure:@escaping (Error) -> Void) -> Self{
        self.failCallback = failure
        return self
    }
    
    var value: Value?{
        if case .fulfilled(let v) = status{
            return v
        }else{
            return nil
        }
    }
    
    var error: Error?{
        if case .rejected(let e) = status{
            return e
        }else{
            return nil
        }
    }
    
    deinit{
        print("\(self) deinit")
    }
}

struct E: LocalizedError{
    var errorDescription: String?
}

func testFlatmap(){
    let p1 = Promise<Int>.init { success, failure in
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            success(100)
            //failure(E(errorDescription: "p1 err"))
        }
    }
    
    let p2 = p1.flatMap { i in
        return Promise<String>.init { success, failure in
            DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
                success("_\(i)_")
                //failure(E(errorDescription: "p2 err"))
            }
        }
    }
    
    print("p1: value:",p1.value," err:",p1.error)
    print("p2: value:",p2.value," err:",p2.error)
    
    p2.then { ret in
        print("ret:\(ret)")
    }.catch { e in
        print("err:\(e)")
    }
    
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
        print("p1: value:",p1.value," err:",p1.error)
        print("p2: value:",p2.value," err:",p2.error)
    }
    
}

func test(){
    let p = Promise<String>.init { success, failure in
        DispatchQueue.global().async {
            print("work start:\(Thread.current)")
            sleep(1)
            print("work end:\(Thread.current)")
            success("abc")
            //failure(E(errorDescription: "err1"))
        }
    }
    
    p.then { s in
        print(s)
    }.catch { e in
        print(e)
    }
    
    //print(p.value)
    //print(p.error)
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
        print(p.value)
        print(p.error)
    }
}
