//
//  AlertStyleVC.swift
//  Demo
//
//  Created by hwreal on 2021/9/16.
//

import UIKit
import HWUtils



class AlertStyleViewVC: UIViewController {    
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        
      
    }
    
    
    deinit {
        print("\(self) deinit")
    }
}
