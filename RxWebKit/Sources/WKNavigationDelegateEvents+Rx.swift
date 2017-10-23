//
//  WKNavigationDelegateEvents+Rx.swift
//  RxWebKit
//
//  Created by Bob Obi on 23.10.17.
//  Copyright © 2017 MokuMokuCloud. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

import WebKit

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }
    return returnValue
}

extension Reactive where Base: WKWebView {
    /// WKNavigationEvent emits a tuple that contains both
    /// WKWebView + WKNavigation
    public typealias WKNavigationEvent = (webView: WKWebView, navigation: WKNavigation)
    
    /// WKNavigationFailedEvent emits a tuple that contains both
    /// WKWebView + WKNavigation + Swift.Error
    public typealias WKNavigationFailEvent = (webView: WKWebView, navigation: WKNavigation, error: Error)
    
    private func navigationEventWith(_ arg: [Any]) throws -> WKNavigationEvent {
        let view = try castOrThrow(WKWebView.self, arg[0])
        let nav = try castOrThrow(WKNavigation.self, arg[1])
        return (view, nav)
    }
    
    private func navigationFailEventWith(_ arg: [Any]) throws -> WKNavigationFailEvent {
        let view = try castOrThrow(WKWebView.self, arg[0])
        let nav = try castOrThrow(WKNavigation.self, arg[1])
        let error = try castOrThrow(Swift.Error.self, arg[2])
        return (view, nav, error)
    }
    
    /// Reactive wrapper for `navigationDelegate`.
    public var delegate: DelegateProxy<WKWebView, WKNavigationDelegate> {
        return RxWKNavigationDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didCommit navigation: WKNavigation!)`.
    public var didCommitNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didCommit:)))
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)`.
    public var didStartProvisionalNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:)))
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)`
    public var didFinishNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didFinish:)))
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webViewWebContentProcessDidTerminate(_ webView: WKWebView)`.
    /// *** available from ios 9.0 ***
    @available(iOS 9.0, *)
    public var didTerminate: ControlEvent<WKWebView> {
        let source: Observable<WKWebView> = delegate
            .methodInvoked(#selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:)))
            .map { try castOrThrow(WKWebView.self, $0[0]) }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)`.
    public var didReceiveServerRedirectForProvisionalNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:)))
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)`.
    public var didFailNavigation: ControlEvent<WKNavigationFailEvent> {
        let source: Observable<WKNavigationFailEvent> = delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didFail:withError:)))
            .map(navigationFailEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)`.
    public var didFailProvisionalNavigation: ControlEvent<WKNavigationFailEvent> {
        let source: Observable<WKNavigationFailEvent> = delegate
            .methodInvoked(#selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:)))
            .map(navigationFailEventWith)
        return ControlEvent(events: source)
    }
}


