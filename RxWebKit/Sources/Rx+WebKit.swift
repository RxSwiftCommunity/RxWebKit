//
//  Rx+WebKit.swift
//  RxWebKit
//
//  Created by Daichi Ichihara on 2016/02/06.
//  Copyright © 2016年 RxSwift Community. All rights reserved.
//

import Foundation
import WebKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

extension Reactive where Base: WKWebView {
    /**
     Reactive wrapper for `title` property
     */
    public var title: Observable<String?> {
        return self.observeWeakly(String.self, "title")
    }

    /**
     Reactive wrapper for `loading` property.
     */
    public var loading: Observable<Bool> {
        return self.observeWeakly(Bool.self, "loading")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `estimatedProgress` property.
     */
    public var estimatedProgress: Observable<Double> {
        return self.observeWeakly(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }

    /**
     Reactive wrapper for `url` property.
     */
    public var url: Observable<URL?> {
        return self.observeWeakly(URL.self, "URL")
    }


    /**
     Reactive wrapper for `canGoBack` property.
     */
    public var canGoBack: Observable<Bool> {
        return self.observeWeakly(Bool.self, "canGoBack")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `canGoForward` property.
     */
    public var canGoForward: Observable<Bool> {
        return self.observeWeakly(Bool.self, "canGoForward")
            .map { $0 ?? false }
    }
}
