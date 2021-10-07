//
//  AlertOne.swift
//  Demo
//
//  Created by hwreal on 2021/9/16.
//

import UIKit
import HWUtils

class AlertOne: UIView, AlertStyleViewProtocol {
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func cancelClick(_ sender: Any) {
        clickAction(0)
    }

    @IBAction func confirmClick(_ sender: Any) {
        clickAction(1)
    }
    
    deinit {
        print("\(self) deinit")
    }
}
