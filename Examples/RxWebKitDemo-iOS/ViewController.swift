//
//  ViewController.swift
//  Example
//
//  Created by Daichi Ichihara on 2016/02/06.
//  Copyright © 2016年 RxSwift Community. All rights reserved.
//

import RxCocoa
import RxSwift
import RxWebKit
import UIKit
import WebKit

class ViewController: UIViewController {
  @IBOutlet var toolBar: UIToolbar!
  @IBOutlet var backButton: UIBarButtonItem!
  @IBOutlet var forwardButton: UIBarButtonItem!

  var wkWebView = WKWebView()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(wkWebView)
    let request = URLRequest(url: URL(string: "https://github.com/ReactiveX/RxSwift")!)
    wkWebView.load(request)

    observeReadOnlyProperties(wkWebView: wkWebView)
    observeToolBarButtonItems()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    let originY = UIApplication.shared.statusBarFrame.maxY
    wkWebView.frame = CGRect(x: 0,
                             y: originY,
                             width: view.bounds.width,
                             height: toolBar.frame.minY - originY)
  }

  private func observeReadOnlyProperties(wkWebView: WKWebView) {
    wkWebView.rx.title
      .share(replay: 1)
      .subscribe(onNext: {
        print("title: \(String(describing: $0))")
      })
      .disposed(by: disposeBag)

    wkWebView.rx.url
      .share(replay: 1)
      .subscribe(onNext: {
        print("URL: \(String(describing: $0))")
      })
      .disposed(by: disposeBag)

    wkWebView.rx.estimatedProgress
      .share(replay: 1)
      .subscribe(onNext: {
        print("estimatedProgress: \($0)")
      })
      .disposed(by: disposeBag)

    wkWebView.rx.loading
      .share(replay: 1)
      .subscribe(onNext: {
        print("loading: \($0)")
      })
      .disposed(by: disposeBag)

    wkWebView.rx.canGoBack
      .share(replay: 1)
      .subscribe(onNext: { [weak self] in
        self?.backButton.isEnabled = $0
      })
      .disposed(by: disposeBag)

    wkWebView.rx.canGoForward
      .share(replay: 1)
      .subscribe(onNext: { [weak self] in
        self?.forwardButton.isEnabled = $0
      })
      .disposed(by: disposeBag)
  }

  private func observeToolBarButtonItems() {
    backButton.rx.tap
      .share(replay: 1)
      .subscribe(onNext: { [weak self] in
        _ = self?.wkWebView.goBack()
      })
      .disposed(by: disposeBag)

    forwardButton.rx.tap
      .share(replay: 1)
      .subscribe(onNext: { [weak self] in
        _ = self?.wkWebView.goForward()
      })
      .disposed(by: disposeBag)
  }
}
