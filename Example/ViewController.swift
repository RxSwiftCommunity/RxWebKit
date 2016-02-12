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

    var wkWebView = WKWebView()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(wkWebView)
        let request = NSURLRequest(URL: NSURL(string: "https://github.com/ReactiveX/RxSwift")!)
        wkWebView.loadRequest(request)
        
        observeReadOnlyProperties(wkWebView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        wkWebView.frame = self.view.bounds
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
        
        wkWebView.rx_URL
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
    }

}

