//
//  SignView.swift
//  Demo
//
//  Created by hwreal on 2021/10/12.
//

import Foundation
import UIKit

class CXGSignView: UIView {

    var path: UIBezierPath?
    var pathArray: [UIBezierPath] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.gray
        setupSubviews()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    func setupSubviews() {

        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGestureRecognizerAction(_:)))
        self.addGestureRecognizer(panGestureRecognizer)

    }

    @objc func panGestureRecognizerAction(_ sender: UIPanGestureRecognizer) {
        // 获取当前点
        let currentPoint = sender.location(in: self)

        if sender.state == .began {
            self.path = UIBezierPath()
            path?.lineWidth = 2
            path?.move(to: currentPoint)
            pathArray.append(path!)
        }else if sender.state == .changed {
            path?.addLine(to: currentPoint)
        }
        self.setNeedsDisplay()
    }

    // 根据 UIBezierPath 重新绘制
    override func draw(_ rect: CGRect) {

        for path in pathArray {
            // 签名颜色
            UIColor.black.set()
            path.stroke()
        }
    }

    // 清空
    func clearSign() {
        pathArray.removeAll()
        self.setNeedsDisplay()
    }

    // 撤销
    func undoSign() {
        guard pathArray.count > 0 else {
        return
    }
    pathArray.removeLast()
        self.setNeedsDisplay()
    }

    /// 签名转化为图片
    func saveSignToImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.main.scale)
        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        self.layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

