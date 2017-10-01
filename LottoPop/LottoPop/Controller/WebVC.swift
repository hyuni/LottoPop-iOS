//
//  WebVC.swift
//  LottoPop
//
//  Created by 구홍석 on 2017. 8. 27..
//  Copyright © 2017년 구홍석. All rights reserved.
//

import UIKit
import WebKit

class WebVC: UIViewController {
    // MARK: Outlet
    @IBOutlet weak var webView: UIWebView!
    
    // MARK: Variable
    var urlStr: String? = nil
    internal var indicator: UIActivityIndicatorView? = nil
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.indicator = UiUtil.makeActivityIndicator(parentView: self.view)
        if let urlStr = self.urlStr, let url = URL(string: urlStr) {
            self.webView.delegate = self
            self.webView.loadRequest(URLRequest(url: url))
        }
    }
}

// MARK: - WKWebView
extension WebVC: UIWebViewDelegate {
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.indicator?.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        self.indicator?.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        self.indicator?.stopAnimating()
    }
}
