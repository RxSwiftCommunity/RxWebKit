//
//  Rx+WebKit.swift
//  RxWebKit
//
//  Created by Daichi Ichihara on 2016/02/06.
//  Copyright © 2016年 RxSwift Community. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import WebKit

public extension Reactive where Base: WKWebView {
  /**
   Reactive wrapper for `title` property
   */
  var title: Observable<String?> {
    return observeWeakly(String.self, "title")
  }

  /**
   Reactive wrapper for `loading` property.
   */
  var loading: Observable<Bool> {
    return observeWeakly(Bool.self, "loading")
      .map { $0 ?? false }
  }

  /**
   Reactive wrapper for `estimatedProgress` property.
   */
  var estimatedProgress: Observable<Double> {
    return observeWeakly(Double.self, "estimatedProgress")
      .map { $0 ?? 0.0 }
  }

  /**
   Reactive wrapper for `url` property.
   */
  var url: Observable<URL?> {
    return observeWeakly(URL.self, "URL")
  }

  /**
   Reactive wrapper for `canGoBack` property.
   */
  var canGoBack: Observable<Bool> {
    return observeWeakly(Bool.self, "canGoBack")
      .map { $0 ?? false }
  }

  /**
   Reactive wrapper for `canGoForward` property.
   */
  var canGoForward: Observable<Bool> {
    return observeWeakly(Bool.self, "canGoForward")
      .map { $0 ?? false }
  }

  /// Reactive wrapper for `evaluateJavaScript(_:completionHandler:)` method.
  ///
  /// - Parameter javaScriptString: The JavaScript string to evaluate.
  /// - Returns: Observable sequence of result of the script evaluation.
  func evaluateJavaScript(_ javaScriptString: String) -> Observable<Any?> {
    return Observable.create { [weak base] observer in
      base?.evaluateJavaScript(javaScriptString) { value, error in
        if let error = error {
          observer.onError(error)
        } else {
          observer.onNext(value)
          observer.onCompleted()
        }
      }
      return Disposables.create()
    }
  }
}
