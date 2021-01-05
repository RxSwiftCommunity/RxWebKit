//
//  RxWKUIDelegateEvents+Rx.swift
//  RxWebKit
//
//  Created by Bob Obi on 25.10.17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

#if !RX_NO_MODULE
  import RxCocoa
  import RxSwift
#endif

import WebKit

public extension Reactive where Base: WKWebView {
  typealias JSAlertEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: () -> Void)
  typealias JSConfirmEvent = (webView: WKWebView, message: String, frame: WKFrameInfo, handler: (Bool) -> Void)
  #if os(iOS)
    typealias CommitPreviewEvent = (webView: WKWebView, controller: UIViewController)
  #endif

  /// Reactive wrapper for `navigationDelegate`.
  var uiDelegate: DelegateProxy<WKWebView, WKUIDelegate> {
    return RxWKUIDelegateProxy.proxy(for: base)
  }

  /// Reactive wrapper for `func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Swift.Void)`
  var javaScriptAlertPanel: ControlEvent<JSAlertEvent> {
    typealias __CompletionHandler = @convention(block) () -> Void
    let source: Observable<JSAlertEvent> = uiDelegate
      .methodInvoked(.jsAlert).map { args in
        let view = try castOrThrow(WKWebView.self, args[0])
        let message = try castOrThrow(String.self, args[1])
        let frame = try castOrThrow(WKFrameInfo.self, args[2])
        var closureObject: AnyObject?
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
  var javaScriptConfirmPanel: ControlEvent<JSConfirmEvent> {
    typealias __ConfirmHandler = @convention(block) (Bool) -> Void
    let source: Observable<JSConfirmEvent> = uiDelegate
      .methodInvoked(.jsConfirm).map { args in
        let view = try castOrThrow(WKWebView.self, args[0])
        let message = try castOrThrow(String.self, args[1])
        let frame = try castOrThrow(WKFrameInfo.self, args[2])
        var closureObject: AnyObject?
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

  #if os(iOS)
    /// Reactive wrappper for `func webView(_ webView: WKWebView, commitPreviewingViewController previewingViewController: UIViewController)`
    @available(iOS 10.0, *)
    var commitPreviewing: ControlEvent<CommitPreviewEvent> {
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

private extension Selector {
  static let jsAlert = #selector(WKUIDelegate.webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:))
  static let jsConfirm = #selector(WKUIDelegate.webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:))

  #if os(iOS)
    @available(iOS 10.0, *)
    static let commitPreviewing = #selector(WKUIDelegate.webView(_:commitPreviewingViewController:))
  #endif
}
