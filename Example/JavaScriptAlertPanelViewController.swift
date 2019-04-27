//
//  JavaScriptAlertPanelViewController.swift
//  Example
//
//  Created by Bob Obi on 25.10.17.
//  Copyright © 2017 RxSwift Community. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

class JavaScriptAlertPanelViewController: UIViewController {
    
    let bag = DisposeBag()
    let wkWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(wkWebView)
        wkWebView.load(URLRequest(url: URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_alert")!))
        
        wkWebView.rx
            .javaScriptAlertPanel
            .debug("javaScriptAlertPanel")
            .subscribe(onNext: { [weak self] webView, message, frame, handler in
                guard let self = self else { return }
                let alert = UIAlertController(title: "JavaScriptAlertPanel", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                handler()
            })
            .disposed(by: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let originY = UIApplication.shared.statusBarFrame.maxY
        wkWebView.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
    }
}
