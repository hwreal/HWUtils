//
//  AlertStyleViewProtocol.swift
//  HWUtils
//
//  Created by hwreal on 2021/9/16.
//

import Foundation
import UIKit

public typealias ButtonIndex = Int

public protocol AlertStyleViewProtocol {}

private var clickActionKey: Void?
private var showedKey: Void?
private var overlayViewKey: Void?
private var overlayAlphaKey: Void?
private var tapOutsideDismissKey: Void?

extension AlertStyleViewProtocol where Self: UIView{
    
    public func show(overlayAlpha: CGFloat = 0.6,
                     tapOutsideDismiss:Bool = false,
                     clickAction:@escaping (ButtonIndex)->Void){
        
        guard let parentView = UIApplication.shared.keyWindow else {return}
        guard !showed else {return}
        
        showed = true
        
        self.clickAction = {[unowned self] btnIdx in
            self.hide()
            clickAction(btnIdx)
        }
        
        self.overlayAlpha = overlayAlpha
        self.tapOutsideDismiss = tapOutsideDismiss
        
        parentView.addSubview(overlayView)
        parentView.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: parentView, attribute: .centerX, multiplier: 1, constant: 0))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: parentView, attribute: .centerY, multiplier: 1, constant: -50))
        parentView.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: parentView, attribute: .width, multiplier: 1, constant: -40))
        
        
        overlayView.alpha = 0
        alpha = 0
        transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animate(withDuration: 0.2) {
            self.overlayView.alpha = 1
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    
    fileprivate func hide(){
        self.showed = false
        UIView.animate(withDuration: 0.1) {
            self.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
            self.alpha = 0
            self.overlayView.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
            self.overlayView.removeFromSuperview()
        }
        
    }
    
    var showed: Bool{
        get{ objc_getAssociatedObject(self, &showedKey) as? Bool ?? false }
        set{ objc_setAssociatedObject(self, &showedKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    var tapOutsideDismiss: Bool{
        get{ objc_getAssociatedObject(self, &tapOutsideDismissKey) as? Bool ?? false }
        set{ objc_setAssociatedObject(self, &tapOutsideDismissKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
    public var clickAction:(ButtonIndex)->Void{
        get{ objc_getAssociatedObject(self, &clickActionKey) as? (ButtonIndex)->Void ?? {_ in} }
        set{ objc_setAssociatedObject(self, &clickActionKey, newValue, .OBJC_ASSOCIATION_COPY_NONATOMIC) }
    }
    
    public var overlayView: UIView{
        if let overlayView = objc_getAssociatedObject(self, &overlayViewKey) as? UIView{
            return overlayView
        }else{
            let overlayView = UIView(frame: UIScreen.main.bounds)
            overlayView.backgroundColor = UIColor.black.withAlphaComponent(overlayAlpha)
            overlayView.isUserInteractionEnabled = true
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapOverlayView(_:)))
            overlayView.addGestureRecognizer(tap)
            objc_setAssociatedObject(self, &overlayViewKey, overlayView, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return overlayView
        }
    }
    
    var overlayAlpha: CGFloat {
        get{ objc_getAssociatedObject(self, &overlayAlphaKey) as? CGFloat ?? 0.6 }
        set{ objc_setAssociatedObject(self, &overlayAlphaKey, newValue, .OBJC_ASSOCIATION_ASSIGN) }
    }
    
}

fileprivate extension UIView{
    @objc func tapOverlayView(_ tap: UITapGestureRecognizer){
        guard let selfView = self as? AlertStyleViewProtocol & UIView else {return}
        if selfView.tapOutsideDismiss {
            selfView.hide()
        }
    }
}

