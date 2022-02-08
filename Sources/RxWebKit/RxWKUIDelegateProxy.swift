//
//  RxWKUIDelegateProxy.swift
//  RxWebKit
//
//  Created by Bob Obi on 25.10.17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import WebKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

public typealias RxWKUIDelegate = DelegateProxy<WKWebView, WKUIDelegate>

open class RxWKUIDelegateProxy: RxWKUIDelegate, DelegateProxyType, WKUIDelegate {
    
    /// Type of parent object
    /// must be WKWebView!
    public weak private(set) var webView: WKWebView?
    
    /// Init with ParentObject
    public init(parentObject: ParentObject) {
        webView = parentObject
        super.init(parentObject: parentObject, delegateProxy: RxWKUIDelegateProxy.self)
    }
    
    /// Register self to known implementations
    public static func registerKnownImplementations() {
        self.register { parent -> RxWKUIDelegateProxy in
            RxWKUIDelegateProxy(parentObject: parent)
        }
    }
    
    /// Gets the current `WKUIDelegate` on `WKWebView`
    open class func currentDelegate(for object: ParentObject) -> WKUIDelegate? {
        return object.uiDelegate
    }
    
    /// Set the uiDelegate for `WKWebView`
    open class func setCurrentDelegate(_ delegate: WKUIDelegate?, to object: ParentObject) {
        object.uiDelegate = delegate
    }
}
