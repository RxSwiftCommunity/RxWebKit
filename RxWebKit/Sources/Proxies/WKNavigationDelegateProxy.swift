//
//  WKNavigationDelegateProxy.swift
//  RxWebKit
//
//  Created by Mateusz Zając on 21.08.2017.
//  Copyright © 2017 MokuMokuCloud. All rights reserved.
//

import Foundation
import WebKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

fileprivate let defaultNavigationDelegate = WKDefaultNavigationDelegate()

fileprivate final class WKDefaultNavigationDelegate: NSObject, WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(.performDefaultHandling, nil)
    }
}


public class WKNavigationDelegateProxy: DelegateProxy, WKNavigationDelegate, DelegateProxyType {
    private weak var _requiredMethodsDelegate: WKNavigationDelegate? = defaultNavigationDelegate
    
    public static func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let webView: WKWebView = object as! WKWebView
        return webView.navigationDelegate
    }
    
    public static func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let webView: WKWebView = object as! WKWebView
        webView.navigationDelegate = delegate as? WKNavigationDelegate
    }
    
    public override static func createProxyForObject(_ object: AnyObject) -> AnyObject {
        let webView: WKWebView = object as! WKWebView
        return webView.createWKNavigationDelegateProxy()
    }
    
    public override func setForwardToDelegate(_ delegate: AnyObject?, retainDelegate: Bool) {
        let requiredNavigationDelegate: WKNavigationDelegate? = delegate as? WKNavigationDelegate
        _requiredMethodsDelegate = requiredNavigationDelegate ?? defaultNavigationDelegate
        super.setForwardToDelegate(delegate, retainDelegate: retainDelegate)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        return (_requiredMethodsDelegate ?? defaultNavigationDelegate).webView!(webView, decidePolicyFor: navigationAction, decisionHandler: decisionHandler)
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        return (_requiredMethodsDelegate ?? defaultNavigationDelegate).webView!(webView, decidePolicyFor: navigationResponse, decisionHandler: decisionHandler)
    }
    
    public func webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        return (_requiredMethodsDelegate ?? defaultNavigationDelegate).webView!(webView, didReceive: challenge, completionHandler: completionHandler)
    }
}
