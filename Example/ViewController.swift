//
//  ViewController.swift
//  Example
//
//  Created by Daichi Ichihara on 2016/02/06.
//  Copyright © 2016年 MokuMokuCloud. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var backButton: UIBarButtonItem!
    @IBOutlet weak var forwardButton: UIBarButtonItem!

    var wkWebView = WKWebView()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(wkWebView)
        let request = URLRequest(url: URL(string: "https://github.com/ReactiveX/RxSwift")!)
        wkWebView.load(request)

        observeReadOnlyProperties(wkWebView: wkWebView)
        observeToolBarButtonItems()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let originY = UIApplication.shared.statusBarFrame.maxY
        wkWebView.frame = CGRect(
            x: 0,
            y: originY,
            width: self.view.bounds.width,
            height: toolBar.frame.minY - originY
        )
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

        wkWebView.rx.isLoading
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
