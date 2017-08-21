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

public class WKNavigationDelegateProxy: DelegateProxy, WKNavigationDelegate, DelegateProxyType {
    public class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
        let webView: WKWebView = object as! WKWebView
        return webView.navigationDelegate
    }
    
    public class func setCurrentDelegate(_ delegate: AnyObject?, toObject object: AnyObject) {
        let webView: WKWebView = object as! WKWebView
        webView.navigationDelegate = delegate as? WKNavigationDelegate
    }
}
