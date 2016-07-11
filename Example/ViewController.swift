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
        let originY = UIApplication.shared().statusBarFrame.maxY
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
        wkWebView.rx_title
            .shareReplay(1)
            .subscribeNext {
                print("title: \($0)")
            }
            .addDisposableTo(disposeBag)

        wkWebView.rx_url
            .shareReplay(1)
            .subscribeNext {
                print("URL: \($0)")
            }
            .addDisposableTo(disposeBag)

        wkWebView.rx_estimatedProgress
            .shareReplay(1)
            .subscribeNext {
                print("estimatedProgress: \($0)")
            }
            .addDisposableTo(disposeBag)

        wkWebView.rx_loading
            .shareReplay(1)
            .subscribeNext {
                print("loading: \($0)")
            }
            .addDisposableTo(disposeBag)

        wkWebView.rx_canGoBack
            .shareReplay(1)
            .subscribeNext { [weak self] in
                self?.backButton.isEnabled = $0
            }
            .addDisposableTo(disposeBag)

        wkWebView.rx_canGoForward
            .shareReplay(1)
            .subscribeNext { [weak self] in
                self?.forwardButton.isEnabled = $0
            }
            .addDisposableTo(disposeBag)
    }
    
    private func observeToolBarButtonItems() {
        backButton.rx_tap
            .shareReplay(1)
            .subscribeNext { [weak self] in
                _ = self?.wkWebView.goBack()
            }
            .addDisposableTo(disposeBag)

        forwardButton.rx_tap
            .shareReplay(1)
            .subscribeNext { [weak self] in
                _ = self?.wkWebView.goForward()
            }
            .addDisposableTo(disposeBag)
    }

}
