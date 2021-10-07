//
//  AlertTwo.swift
//  Demo
//
//  Created by hwreal on 2021/9/18.
//

import UIKit
import HWUtils

class AlertTwo: UIView, AlertStyleViewProtocol{
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBAction func confirmBtnClicked(_ sender: UIButton) {
        clickAction(0)
    }
    deinit {
        print("\(self) deinit")
    }
}
