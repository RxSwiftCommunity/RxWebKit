//
//  RedirectViewController.swift
//  Example
//
//  Created by Bob Godwin Obi on 10/25/17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import RxCocoa
import RxSwift
import RxWebKit
import UIKit
import WebKit

class RedirectViewController: UIViewController {
  let bag = DisposeBag()
  let wkWebView = WKWebView()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(wkWebView)
    wkWebView.load(URLRequest(url: URL(string: "http://www.webconfs.com/http-header-check.php")!))

    wkWebView.rx
      .didReceiveServerRedirectForProvisionalNavigation
      .observe(on: MainScheduler.instance)
      .debug("didReceiveServerRedirectForProvisionalNavigation")
      .subscribe(onNext: { [weak self] _, _ in
        guard let self = self else { return }
        let alert = UIAlertController(title: "Redirect Navigation", message: "you have bene redirected", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
      })
      .disposed(by: bag)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let originY = UIApplication.shared.statusBarFrame.maxY
    wkWebView.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
  }
}
