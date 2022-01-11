//
//  CommonScriptMessageHandler.swift
//  wkwebviewTest
//
//  Created by hwreal on 2021/9/21.
//

import Foundation
import UIKit
import WebKit

public let CommonScriptMessageHandlerName = "CommonScriptMessageHandler"

public class CommonScriptMessageHandler: NSObject, WKScriptMessageHandler{
    weak var webView: WKWebView!
    
    public init(webView: WKWebView) {
        self.webView = webView
    }
    
    public static var commonUserScript:WKUserScript{
        
        let userJSStr = try! String(contentsOfFile: Bundle(for: self).path(forResource: "CommonUserScript", ofType: "js")!)
        let commonUserScript = WKUserScript(source: userJSStr, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        return commonUserScript
    }
    
    //MARK: - WKScriptMessageHandler
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print("\(self) receive message: \(message.name)\nbody:\(message.body)")
        //message = {'func':funcName,'params':params,'failureCallBackID':failureCallBackID};

        guard let bodyDic = message.body as? [String: Any],
              let action = bodyDic["func"] as? String else{
            return
        }
        
        guard let param = bodyDic["params"] as? [String: Any] else { return }
        
        guard let aaaa = Action(rawValue: action) else {return}
        let orderType = aaaa.orderType
        let order = orderType.init(param: param)
        print(order)
        let exeRet = order?.exec()
        
        
        if let ret = exeRet,
           let successCallBackID = bodyDic["successCallBackID"] as? String{
            
            let jsString = "CommonEventHandler.callBack('\(successCallBackID)','\(ret)');"
            
            self.webView.evaluateJavaScript(jsString, completionHandler: { (data:Any?, error:Error?) in
                #if DEBUG
                print("CommonEventHandler.callBack:\ndata: error%@\n error: %@\n",data as Any,error as Any)
                #endif
            })
        }
    }
    
    deinit {
        print("\(self) deinit")
    }
}

public protocol Order: Codable {
    //init(param: [String: Any])
    func exec() -> String?
}

public extension Order{
    init?(param: [String: Any]){
        let decoder = JSONDecoder()
        guard let paramData = try? JSONSerialization.data(withJSONObject: param, options: .prettyPrinted),
        let order = try? decoder.decode(Self.self, from: paramData)
        else {
            return nil
        }
        self = order
    }
}

enum Action: String{
    case getNativeInfo
    case getUDID
}

extension Action{
    var orderType: Order.Type{
        switch self {
        
        case .getNativeInfo:
            return GetNativeInfo.self
        case .getUDID:
            return GetUDID.self
        }
    }
}


struct GetNativeInfo: Order{
    func exec() -> String? {
        return "abccc"
    }
    
    var name: String
}

struct GetUDID: Order {
    func exec() -> String? {
        return "udid250"
    }
    
    
}
