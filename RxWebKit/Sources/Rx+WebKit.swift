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
    /**
     Reactive wrapper for `title` property
     */
    public var title: Observable<String?> {
        return self.observe(String.self, "title")
    }

    /**
     Reactive wrapper for `loading` property.
     */
    public var loading: Observable<Bool> {
        return self.observe(Bool.self, "loading")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `estimatedProgress` property.
     */
    public var estimatedProgress: Observable<Double> {
        return self.observe(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }

    /**
     Reactive wrapper for `url` property.
     */
    public var url: Observable<URL?> {
        return self.observe(URL.self, "URL")
    }


    /**
     Reactive wrapper for `canGoBack` property.
     */
    public var canGoBack: Observable<Bool> {
        return self.observe(Bool.self, "canGoBack")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `canGoForward` property.
     */
    public var canGoForward: Observable<Bool> {
        return self.observe(Bool.self, "canGoForward")
            .map { $0 ?? false }
    }
}
