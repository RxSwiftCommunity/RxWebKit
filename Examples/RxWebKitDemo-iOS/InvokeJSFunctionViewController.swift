//
//  InvokeJSFunctionViewController.swift
//  Example
//
//  Created by Jesse Hao on 2019/4/1.
//  Copyright © 2019 RxSwift Community. All rights reserved.
//

import RxCocoa
import RxSwift
import RxWebKit
import UIKit
import WebKit

private let html = """
<!DOCTYPE html>
<html>
<head>
<title>Invoke Javascript function</title>
</head>
<body>

<h1>Invoke Javascript function</h1>
<h1>Just Press 'Invoke' at top right corner.</h1>
<h1>After that, pay attention to your console.</h1>

<script>
function presentAlert() {
    return "🎊🎊🎊Hey! you just invoke me🎉🎉🎉"
}
</script>

</body>
</html>

"""

class InvokeJSFunctionViewController: UIViewController {
  let bag = DisposeBag()
  let webview = WKWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(webview)
    navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Invoke", style: .plain, target: nil, action: nil)
    navigationItem.rightBarButtonItem?.rx.tap.bind { [weak self] in
      guard let self = self else { return }
      self.webview.rx.evaluateJavaScript("presentAlert()").observe(on: MainScheduler.asyncInstance).subscribe { event in
        if case let .next(body) = event, let message = body as? String {
          print(message)
        }
      }.disposed(by: self.bag)
    }.disposed(by: bag)
    webview.loadHTMLString(html, baseURL: nil)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let originY = UIApplication.shared.statusBarFrame.maxY
    webview.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
  }
}
