//
//  AuthChallengeViewController.swift
//  Example
//
//  Created by Bob Obi on 25.10.17.
//  Copyright © 2017 MokuMokuCloud. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

class AuthChallengeViewController: UIViewController {

    let bag = DisposeBag()
    let wkWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(wkWebView)
        wkWebView.load(URLRequest(url: URL(string: "https://jigsaw.w3.org/HTTP/Basic/")!))
        
        wkWebView.rx
            .didReceiveChallenge
            .debug("didReceiveChallenge")
            .subscribe(onNext: {(webView, challenge, handler) in
                let credential = URLCredential(user: "guest-bad-user", password: "guest-bad-password", persistence: URLCredential.Persistence.forSession)
                challenge.sender?.use(credential, for: challenge)
                handler(URLSession.AuthChallengeDisposition.useCredential, credential)
            })
            .disposed(by: bag)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let originY = UIApplication.shared.statusBarFrame.maxY
        wkWebView.frame = CGRect(x: 0, y: originY, width: view.bounds.width, height: view.bounds.height)
    }

}
