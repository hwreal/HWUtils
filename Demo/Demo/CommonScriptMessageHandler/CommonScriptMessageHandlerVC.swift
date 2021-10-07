//
//  CommonScriptMessageHandlerVC.swift
//  Demo
//
//  Created by hwreal on 2021/10/1.
//

import UIKit
import WebKit
import HWUtils

class CommonScriptMessageHandlerVC: UIViewController {
    
    lazy var webView: WKWebView =  {
        let contentC = WKUserContentController()
        
        contentC.addUserScript(CommonScriptMessageHandler.commonUserScript)
        
        let wkConfi = WKWebViewConfiguration()
        wkConfi.userContentController = contentC;
        
        let frame = CGRect(x: 0, y: 0, width: 1300, height: 500)
        let webView = WKWebView(frame: frame, configuration: wkConfi)
        webView.uiDelegate = self
        webView.configuration.userContentController.add(CommonScriptMessageHandler(webView: webView), name: CommonScriptMessageHandlerName)
        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        
        view.addSubview(webView)
        let localHtmlStr = try! String(contentsOfFile: Bundle.main.path(forResource: "main", ofType: "html")!)
        webView.loadHTMLString(localHtmlStr, baseURL: nil)

    }
    

}


extension CommonScriptMessageHandlerVC: WKUIDelegate {
    
    func webView(_ webView: WKWebView,
                 runJavaScriptAlertPanelWithMessage message: String,
                 initiatedByFrame frame: WKFrameInfo,
                 completionHandler: @escaping () -> Void) {
        let alert = UIAlertController.init(title: "alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "确定", style: .default, handler: { (_ acton:UIAlertAction) in
            completionHandler()
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
}
