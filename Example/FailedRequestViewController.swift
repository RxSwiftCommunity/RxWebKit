//
//  FailedRequestViewController.swift
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

class FailedRequestViewController: UIViewController {
    
    let bag = DisposeBag()
    let wkWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(wkWebView)
        wkWebView.load(URLRequest(url: URL(string: "https://thiswebsiteisnotexisting.com")!))
        
        wkWebView.rx
            .didFailProvisionalNavigation
            .observeOn(MainScheduler.instance)
            .debug("didFailProvisionalNavigation")
            .subscribe(onNext: { [weak self] webView, navigation, error in
                guard let self = self else { return }
                let alert = UIAlertController(title: "FailProvisionalNavigation", message: error.localizedDescription, preferredStyle: .alert)
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
