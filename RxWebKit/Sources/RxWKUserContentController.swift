//
//  RxWKUserContentController.swift
//  RxWebKit
//
//  Created by Jesse Hao on 2019/3/30.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import WebKit
#if !RX_NO_MODULE
    import RxSwift
    import RxCocoa
#endif

extension WKUserContentController {
    fileprivate class MessageHandler : NSObject, WKScriptMessageHandler {
        typealias MessageReceiveHandler = (WKScriptMessage) -> Void
        private var messageReceiveHandler:MessageReceiveHandler?
        
        func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            self.messageReceiveHandler?(message)
        }
        
        func onReceive(_ handler:@escaping MessageReceiveHandler) {
            self.messageReceiveHandler = handler
        }
    }
}

public extension Reactive where Base : WKUserContentController {
    /// Observable sequence of script message.
    ///
    /// - Parameter name: The name of the message handler
    /// - Returns: Observable sequence of script message.
    func scriptMessage(forName name:String) -> ControlEvent<WKScriptMessage> {
        return ControlEvent(events: Observable.create { [weak base] observer in
            let handler = WKUserContentController.MessageHandler()
            base?.add(handler, name: name)
            handler.onReceive {
                observer.onNext($0)
            }
            return Disposables.create {
                base?.removeScriptMessageHandler(forName: name)
            }
        })
    }
}
