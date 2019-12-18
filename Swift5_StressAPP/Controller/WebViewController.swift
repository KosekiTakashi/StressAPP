//
//  WebViewController.swift
//  Swift5_StressAPP
//
//  Created by 小関隆司 on 2019/12/18.
//  Copyright © 2019 kosekitakashi. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    
    var webView: WKWebView!
    var urlString = ""

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self as? WKUIDelegate
        view = webView
        
        var myURL : URL
        if urlString == ""{
            myURL = URL(string:"https://www.google.com")!
        }else{
            myURL = URL(string:urlString)!
        }
        
        let myRequest = URLRequest(url: myURL)
        webView.load(myRequest)
    }
    
    
}
