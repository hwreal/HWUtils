//
//  TimerVC.swift
//  Demo
//
//  Created by hwreal on 2021/9/18.
//

import UIKit

class TimerVC: UIViewController {
    
   weak var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

//        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerRun(_:)), userInfo: nil, repeats: true)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[weak self] timer in
            self?.timerRun(timer)
        })
        
    }
    
    @objc func timerRun(_ timer:Timer){
        print("run..")
    }

    deinit {
        print("\(self) deinit")
    }
}
