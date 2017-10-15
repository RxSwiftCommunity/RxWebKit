//
//  Rx+WebKit.swift
//  RxWebKit
//
//  Created by Daichi Ichihara on 2016/02/06.
//  Copyright © 2016年 MokuMokuCloud. All rights reserved.
//

import Foundation
import WebKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

extension Reactive where Base: WKWebView {

    /// Reactive wrapper for `title` property
    public var title: Observable<String?> {
        return self.observe(String.self, "title")
    }

    /// Reactive wrapper for `loading` property.
    public var isLoading: Observable<Bool> {
        return self.observe(Bool.self, "loading")
            .map { $0 ?? false }
    }

    /// Reactive wrapper for `estimatedProgress` property.
    public var estimatedProgress: Observable<Double> {
        return self.observe(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }

    /// Reactive wrapper for `url` property.
    public var url: Observable<URL?> {
        return self.observe(URL.self, "URL")
    }

    /// Reactive wrapper for `canGoBack` property.
    public var canGoBack: Observable<Bool> {
        return self.observe(Bool.self, "canGoBack")
            .map { $0 ?? false }
    }

    /// Reactive wrapper for `canGoForward` property.
    public var canGoForward: Observable<Bool> {
        return self.observe(Bool.self, "canGoForward")
            .map { $0 ?? false }
    }
}

class RxWKNavigationDelegateProxy: DelegateProxy<WKWebView, WKNavigationDelegate>,
                                    DelegateProxyType,
                                    WKNavigationDelegate {
    /// Typed parent object.
    public weak private(set) var webView: WKWebView?

    /// - parameter tabBar: Parent object for delegate proxy.
    public init(webView: ParentObject) {
        self.webView = webView
        super.init(parentObject: webView, delegateProxy: RxWKNavigationDelegateProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxWKNavigationDelegateProxy(webView: $0) }
    }

    static func currentDelegate(for object: WKWebView) -> WKNavigationDelegate? {
        return object.navigationDelegate
    }

    static func setCurrentDelegate(_ delegate: WKNavigationDelegate?, to object: WKWebView) {
        object.navigationDelegate = delegate
    }
}

extension Reactive where Base: WKWebView {

    public var delegate: DelegateProxy<WKWebView, WKNavigationDelegate> {
        return RxWKNavigationDelegateProxy.proxy(for: base)
    }

    public var didCommitNavigation: Observable<(WKWebView, WKNavigation?)> {
        return delegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:didCommit:)))
            .map { params in
                let webView = try castOrThrow(WKWebView.self, params[0])
                let navigation = params[1] as? WKNavigation
                return (webView, navigation)
        }
    }

    public var didFailNavigation: Observable<(WKWebView, WKNavigation?, Error)> {
        return delegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:didFail:withError:)))
            .map { params in
                let webView = try castOrThrow(WKWebView.self, params[0])
                let navigation = params[1] as? WKNavigation
                let error = try castOrThrow(Error.self, params[2])
                return (webView, navigation, error)
        }
    }

    public var didFailProvisionalNavigation: Observable<(WKWebView, WKNavigation?, Error)> {
        return delegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:)))
            .map { params in
                let webView = try castOrThrow(WKWebView.self, params[0])
                let navigation = params[1] as? WKNavigation
                let error = try castOrThrow(Error.self, params[2])
                return (webView, navigation, error)
        }
    }

    public var didFinishNavigation: Observable<(WKWebView, WKNavigation?)> {
        return delegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:didFinish:)))
            .map { params in
                let webView = try castOrThrow(WKWebView.self, params[0])
                let navigation = params[1] as? WKNavigation
                return (webView, navigation)
        }
    }

    //swiftlint:disable identifier_name
    public var didReceiveServerRedirectForProvisionalNavigation: Observable<(WKWebView, WKNavigation?)> {
        return delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:)))
            .map { params in
                let webView = try castOrThrow(WKWebView.self, params[0])
                let navigation = params[1] as? WKNavigation
                return (webView, navigation)
        }
    }

    public var didStartProvisionalNavigation: Observable<(WKWebView, WKNavigation?)> {
        return delegate.methodInvoked(#selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:)))
            .map { params in
                let webView = try castOrThrow(WKWebView.self, params[0])
                let navigation = params[1] as? WKNavigation
                return (webView, navigation)
        }
    }

    @available(iOS 9.0, *)
    public var webContentProcessDidTerminate: Observable<WKWebView> {
        return delegate.methodInvoked(#selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:)))
            .map { params in
                let webView = try castOrThrow(WKWebView.self, params[0])
                return webView
        }
    }
}

private func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}
