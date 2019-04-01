//
//  ObservingJSEventViewController.swift
//  Example
//
//  Created by Jesse Hao on 2019/4/1.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

fileprivate let html = """
<!DOCTYPE html>
<meta content="width=device-width,user-scalable=no" name="viewport">

<html>
<body>

<p>Click the button to display a confirm box.</p>

<button onclick="sendScriptMessage()">Send!</button>

<p id="demo"></p>

<script>
function sendScriptMessage() {
    window.webkit.messageHandlers.RxWebKitScriptMessageHandler.postMessage('Hello RxWebKit')
}
</script>

</body>
</html>
"""

class ObservingJSEventViewController : UIViewController {
    let bag = DisposeBag()
    let webview = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview.configuration.userContentController.rx.scriptMessage(forName: "RxWebKitScriptMessageHandler").bind { [weak self] scriptMessage in
            guard let message = scriptMessage.body as? String else { return }
            let alert = UIAlertController(title: "JS Event Observed", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            self?.present(alert, animated: true)
        }.disposed(by: self.bag)
        webview.loadHTMLString(html, baseURL: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let originY = UIApplication.shared.statusBarFrame.maxY
        webview.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
    }
}
