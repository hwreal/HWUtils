//
//  AlertStyleVC.swift
//  Demo
//
//  Created by hwreal on 2021/9/16.
//

import UIKit
import HWUtils

class Toy {
    let name: String
    init(name: String) {
        self.name = name
    }
}
extension Toy{
    func play(){
        print("\(name)... play")
    }
}

extension Toy: Comparable{
    static func < (lhs: Toy, rhs: Toy) -> Bool {
        lhs.name > rhs.name
    }
    
    static func == (lhs: Toy, rhs: Toy) -> Bool {
        lhs.name == rhs.name
    }
    
    
}

class Pet { var toy: Toy? }
class Child { var pet: Pet? }


class AlertStyleViewVC: UIViewController {
    
    func aaa(){
        print("aaa")
    }
    
    var bb:()->Void = {}

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let t1 = Toy(name: "bb")
        let t2 = Toy(name: "bb")
        
        var tarr = [t1,t2]
        tarr.sort()
        
        if t1 == t2 {
            print("11")
        }
        
        if t1 === t2 {
            print("22")
        }
//        let child = Child()
//        let name = child.pet?.toy?.name
//        print("child toy name:\(name)")
//
//        let playClosure = { (child: Child) -> () in child.pet?.toy?.play()}
        
//        bb = { [weak self] in
//            self?.aaa()
//        }
        
        
        var jo: Toy? = Toy(name: "ss")
        jo?.play()
        jo = nil
        jo?.play()

    
        
        
        view.backgroundColor = .white
        
        do {
            let btn = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
            btn.backgroundColor = .cyan
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle("AlertOne", for: .normal)
            view.addSubview(btn)
            
            btn.addAction { _ in
                let alert = Bundle.main.loadNib(AlertOne.self)!
                alert.messageLabel.text = "one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one,one"
                alert.show(tapOutsideDismiss: true) { index in
                    print(index)
                }
            }
            
        }
        
        
        do {
            let btn = UIButton(frame: CGRect(x: 100, y: 200, width: 100, height: 50))
            btn.backgroundColor = .cyan
            btn.setTitleColor(.black, for: .normal)
            btn.setTitle("AlertTwo", for: .normal)
            view.addSubview(btn)
            
            btn.addAction { _ in
                let alert = Bundle.main.loadNib(AlertTwo.self)!
                alert.titleLabel.text = "HaHa"
                alert.messageLabel.text = "two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two,two"
                alert.show { index in
                    print(index)
                }
            }
            
        }
        
        let sv = CXGSignView(frame: CGRect(x: 30, y: 30, width: 300, height: 300))
       // view.addSubview(sv)
        
      
    }
    
    
    deinit {
        print("\(self) deinit")
    }
}
