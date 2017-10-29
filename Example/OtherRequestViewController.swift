//
//  OtherRequestViewController.swift
//  Example
//
//  Created by Bob Godwin Obi on 10/25/17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

class OtherRequestViewController: UIViewController {
    
    let bag = DisposeBag()
    let wkWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(wkWebView)
        wkWebView.load(URLRequest(url: URL(string: "https://github.com/ReactiveX/RxSwift")!))
        
        wkWebView.rx
            .didFinishNavigation
            .debug("didFinishNavigation")
            .subscribe(onNext: {_ in })
            .disposed(by: bag)
        
        if #available(iOS 9.0, *) {
            wkWebView.rx
                .didTerminate
                .debug("didTerminate")
                .subscribe(onNext: {_ in })
                .disposed(by: bag)
        }
        
        wkWebView.rx
            .didCommitNavigation
            .debug("didCommitNavigation")
            .subscribe(onNext: {_ in })
            .disposed(by: bag)
        
        wkWebView.rx
            .didStartProvisionalNavigation
            .debug("didStartProvisionalNavigation")
            .subscribe(onNext: {_ in})
            .disposed(by: bag)
        
        if #available(iOS 10.0, *) {
            wkWebView.rx
                .commitPreviewing
                .debug("commitPreviewing")
                .subscribe(onNext:{_ in})
                .disposed(by: bag)
        }
        
        wkWebView.rx
            .decidePolicyNavigationResponse
            .debug("decidePolicyNavigationResponse")
            .subscribe(onNext: {(_, _, handler) in
                handler(.allow)
            })
            .disposed(by: bag)
        
        wkWebView.rx
            .decidePolicyNavigationAction
            .debug("decidePolicyNavigationAction")
            .subscribe(onNext: {(_, _, handler) in
                handler(.allow)
            })
            .disposed(by: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let originY = UIApplication.shared.statusBarFrame.maxY
        wkWebView.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
    }
}

