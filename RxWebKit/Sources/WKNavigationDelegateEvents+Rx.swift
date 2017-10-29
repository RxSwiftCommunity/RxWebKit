//
//  WKNavigationDelegateEvents+Rx.swift
//  RxWebKit
//
//  Created by Bob Obi on 23.10.17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
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
    
    /// ChallengeHandler this is exposed to the user on subscription
    public typealias ChallengeHandler = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
    /// WKNavigationChallengeEvent emits a tuple event of WKWebView + challenge + ChallengeHandler
    public typealias WKNavigationChallengeEvent = (webView: WKWebView, challenge: URLAuthenticationChallenge, handler: ChallengeHandler)
    
    /// DecisionHandler this is the block exposed to the user on subscription
    public typealias DecisionHandler = (WKNavigationResponsePolicy) -> Void
    /// WKNavigationResponsePolicyEvent emits a tuple event of  WKWebView + WKNavigationResponse + DecisionHandler
    public typealias WKNavigationResponsePolicyEvent = ( webView: WKWebView, reponse: WKNavigationResponse, handler: DecisionHandler)
    /// ActionHandler this is the block exposed to the user on subscription
    public typealias ActionHandler = (WKNavigationActionPolicy) -> Void
    /// WKNavigationActionPolicyEvent emits a tuple event of  WKWebView + WKNavigationAction + ActionHandler
    public typealias WKNavigationActionPolicyEvent = ( webView: WKWebView, action: WKNavigationAction, handler: ActionHandler)

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
            .methodInvoked(.didCommitNavigation)
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!)`.
    public var didStartProvisionalNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(.didStartProvisionalNavigation)
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFinish navigation: WKNavigation!)`
    public var didFinishNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(.didFinishNavigation)
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webViewWebContentProcessDidTerminate(_ webView: WKWebView)`.
    /// *** available from ios 9.0 ***
    @available(iOS 9.0, *)
    public var didTerminate: ControlEvent<WKWebView> {
        let source: Observable<WKWebView> = delegate
            .methodInvoked(.didTerminate)
            .map { try castOrThrow(WKWebView.self, $0[0]) }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!)`.
    public var didReceiveServerRedirectForProvisionalNavigation: ControlEvent<WKNavigationEvent> {
        let source: Observable<WKNavigationEvent> = delegate
            .methodInvoked(.didReceiveServerRedirectForProvisionalNavigation)
            .map(navigationEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error)`.
    public var didFailNavigation: ControlEvent<WKNavigationFailEvent> {
        let source: Observable<WKNavigationFailEvent> = delegate
            .methodInvoked(.didFailNavigation)
            .map(navigationFailEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error)`.
    public var didFailProvisionalNavigation: ControlEvent<WKNavigationFailEvent> {
        let source: Observable<WKNavigationFailEvent> = delegate
            .methodInvoked(.didFailProvisionalNavigation)
            .map(navigationFailEventWith)
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for delegate method `webView(_ webView: WKWebView, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void)`
    public var didReceiveChallenge: ControlEvent<WKNavigationChallengeEvent> {
        /// __ChallengeHandler is same as ChallengeHandler
        /// They are interchangeable, __ChallengeHandler is for internal use.
        // ChallengeHandler is exposed to the user on subscription.
        typealias __ChallengeHandler =  @convention(block) (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
        /*! @abstract Invoked when the web view needs to respond to an authentication challenge.
         @param webView The web view that received the authentication challenge.
         @param challenge The authentication challenge.
         @param completionHandler The completion handler you must invoke to respond to the challenge. The
         disposition argument is one of the constants of the enumerated type
         NSURLSessionAuthChallengeDisposition. When disposition is NSURLSessionAuthChallengeUseCredential,
         the credential argument is the credential to use, or nil to indicate continuing without a
         credential.
         @discussion If you do not implement this method, the web view will respond to the authentication challenge with the NSURLSessionAuthChallengeRejectProtectionSpace disposition.
         */
        let source: Observable<WKNavigationChallengeEvent> = delegate
            .sentMessage(.didReceiveChallenge)
            .map { arg in
                let view = try castOrThrow(WKWebView.self, arg[0])
                let challenge = try castOrThrow(URLAuthenticationChallenge.self, arg[1])
                /**
                 This is a holy grail part for more information please read the following articles.
                 1: http://codejaxy.com/q/332345/ios-objective-c-memory-management-automatic-ref-counting-objective-c-blocks-understand-one-edge-case-of-block-memory-management-in-objc
                 2: http://www.galloway.me.uk/2012/10/a-look-inside-blocks-episode-2/
                 3: get know how [__NSStackBlock__ + UnsafeRawPointer + unsafeBitCast] works under the hood
                 */
                var closureObject: AnyObject? = nil
                var mutableArg = arg
                mutableArg.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[2] as AnyObject
                }
                let __challengeBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__challengeBlockPtr, to: __ChallengeHandler.self)
                return (view, challenge, handler)
        }
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Swift.Void)`
    public var decidePolicyNavigationResponse: ControlEvent<WKNavigationResponsePolicyEvent> {
        typealias __DecisionHandler = @convention(block) (WKNavigationResponsePolicy) -> ()
        let source:Observable<WKNavigationResponsePolicyEvent> = delegate
            .methodInvoked(.decidePolicyNavigationResponse).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let response = try castOrThrow(WKNavigationResponse.self, args[1])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[2] as AnyObject
                }
                let __decisionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__decisionBlockPtr, to: __DecisionHandler.self)
                return (view, response, handler)
        }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Swift.Void)`
    public var decidePolicyNavigationAction: ControlEvent<WKNavigationActionPolicyEvent> {
        typealias __ActionHandler = @convention(block) (WKNavigationActionPolicy) -> ()
        let source:Observable<WKNavigationActionPolicyEvent> = delegate
            .methodInvoked(.decidePolicyNavigationAction).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let action = try castOrThrow(WKNavigationAction.self, args[1])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[2] as AnyObject
                }
                let __actionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__actionBlockPtr, to: __ActionHandler.self)
                return (view, action, handler)
        }
        
        return ControlEvent(events: source)
    }
}

fileprivate extension Selector {
    static let didCommitNavigation = #selector(WKNavigationDelegate.webView(_:didCommit:))
    static let didStartProvisionalNavigation = #selector(WKNavigationDelegate.webView(_:didStartProvisionalNavigation:))
    static let didFinishNavigation = #selector(WKNavigationDelegate.webView(_:didFinish:))
    static let didReceiveServerRedirectForProvisionalNavigation = #selector(WKNavigationDelegate.webView(_:didReceiveServerRedirectForProvisionalNavigation:))
    static let didFailNavigation = #selector(WKNavigationDelegate.webView(_:didFail:withError:))
    static let didFailProvisionalNavigation = #selector(WKNavigationDelegate.webView(_:didFailProvisionalNavigation:withError:))
    static let didReceiveChallenge = #selector(WKNavigationDelegate.webView(_:didReceive:completionHandler:))
    @available(iOS 9.0, *)
    static let didTerminate = #selector(WKNavigationDelegate.webViewWebContentProcessDidTerminate(_:))
    static let decidePolicyNavigationResponse = #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView, WKNavigationResponse, @escaping(WKNavigationResponsePolicy) -> Void) -> Void)?)
    static let decidePolicyNavigationAction = #selector(WKNavigationDelegate.webView(_:decidePolicyFor:decisionHandler:) as ((WKNavigationDelegate) -> (WKWebView, WKNavigationAction, @escaping(WKNavigationActionPolicy) -> Void) -> Void)?)
}


