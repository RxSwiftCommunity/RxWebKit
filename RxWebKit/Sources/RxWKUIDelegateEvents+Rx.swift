//
//  RxWKUIDelegateEvents+Rx.swift
//  RxWebKit
//
//  Created by Bob Obi on 25.10.17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

import WebKit

extension Reactive where Base: WKWebView {
    public typealias JSAlertEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: () -> ())
    public typealias JSConfirmEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: (Bool) -> ())
    public typealias JSTextInputEvent = (webView: WKWebView, prompt: String, defaultText: String?, frame: WKFrameInfo, handler: (String?) -> ())
    #if os(iOS)
        public typealias CommitPreviewEvent = (webView: WKWebView, controller: UIViewController)
    #endif
    
    /// Reactive wrapper for `navigationDelegate`.
    public var uiDelegate: DelegateProxy<WKWebView, WKUIDelegate> {
        return RxWKUIDelegateProxy.proxy(for: base)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void)`
    public var javaScriptAlertPanel: ControlEvent<JSAlertEvent> {
        typealias __CompletionHandler = @convention(block) () -> ()
        let source:Observable<JSAlertEvent> = uiDelegate
            .methodInvoked(.jsAlert).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let message = try castOrThrow(String.self, args[1])
                let frame = try castOrThrow(WKFrameInfo.self, args[2])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[3] as AnyObject
                }
                let __completionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__completionBlockPtr, to: __CompletionHandler.self)
                return (view, message, frame, handler)
        }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Swift.Void)`
    public var javaScriptConfirmPanel: ControlEvent<JSConfirmEvent> {
        typealias __ConfirmHandler = @convention(block) (Bool) -> ()
        let source:Observable<JSConfirmEvent> = uiDelegate
            .methodInvoked(.jsConfirm).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let message = try castOrThrow(String.self, args[1])
                let frame = try castOrThrow(WKFrameInfo.self, args[2])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[3] as AnyObject
                }
                let __confirmBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__confirmBlockPtr, to: __ConfirmHandler.self)
                return (view, message, frame, handler)
        }
        
        return ControlEvent(events: source)
    }
    
    /// Reactive wrapper for `func webView(_ webView: WKWebView, runJavaScriptTextInputPanelWithPrompt prompt: String, defaultText: String?, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (String?) -> Swift.Void)`
    public var javaScriptTextInputPanel: ControlEvent<JSTextInputEvent> {
        typealias __CompletionHandler = @convention(block) (String?) -> ()
        let source:Observable<JSTextInputEvent> = uiDelegate
            .methodInvoked(.jsTextInput).map { args in
                let view = try castOrThrow(WKWebView.self, args[0])
                let prompt = try castOrThrow(String.self, args[1])
                let defaultText = try castOrThrow(String?.self, args[2])
                let frame = try castOrThrow(WKFrameInfo.self, args[3])
                var closureObject: AnyObject? = nil
                var mutableArgs = args
                mutableArgs.withUnsafeMutableBufferPointer { ptr in
                    closureObject = ptr[4] as AnyObject
                }
                let __completionBlockPtr = UnsafeRawPointer(Unmanaged<AnyObject>.passUnretained(closureObject as AnyObject).toOpaque())
                let handler = unsafeBitCast(__completionBlockPtr, to: __CompletionHandler.self)
                return (view, prompt, defaultText, frame, handler)
        }
        
        return ControlEvent(events: source)
    }
    
    #if os(iOS)
        /// Reactive wrappper for `func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController)`
        @available(iOS 10.0, *)
        public var commitPreviewing: ControlEvent<CommitPreviewEvent> {
            let source: Observable<CommitPreviewEvent> = uiDelegate
                .methodInvoked(.commitPreviewing)
                .map { args in
                    let view = try castOrThrow(WKWebView.self, args[0])
                    let controller = try castOrThrow(UIViewController.self, args[1])
                    return (view, controller)
                }

            return ControlEvent(events: source)
        }
    #endif
}

fileprivate extension Selector {
    static let jsAlert = #selector(WKUIDelegate.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:))
    static let jsConfirm = #selector(WKUIDelegate.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:))
    static let jsTextInput = #selector(WKUIDelegate.webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:))
    
    #if os(iOS)
        @available(iOS 10.0, *)
        static let commitPreviewing = #selector(WKUIDelegate.webView(_:commitPreviewingViewController:))
    #endif
}
