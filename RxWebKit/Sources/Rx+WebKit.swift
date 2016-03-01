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

extension WKWebView {
    /**
     Reactive wrapper for `title` property
     */
    public var rx_title: Observable<String?> {
        return self.rx_observe(String.self, "title")
    }

    /**
     Reactive wrapper for `loading` property.
    */
    public var rx_loading: Observable<Bool> {
        return self.rx_observe(Bool.self, "loading")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `estimatedProgress` property.
    */
    public var rx_estimatedProgress: Observable<Double> {
        return self.rx_observe(Double.self, "estimatedProgress")
            .map { $0 ?? 0.0 }
    }

    /**
     Reactive wrapper for `URL` property.
    */
    public var rx_URL: Observable<NSURL?> {
        return self.rx_observe(NSURL.self, "URL")
    }

    /**
     Reactive wrapper for `canGoBack` property.
    */
    public var rx_canGoBack: Observable<Bool> {
        return self.rx_observe(Bool.self, "canGoBack")
            .map { $0 ?? false }
    }

    /**
     Reactive wrapper for `canGoForward` property.
    */
    public var rx_canGoForward: Observable<Bool> {
        return self.rx_observe(Bool.self, "canGoForward")
            .map { $0 ?? false }
    }
}
