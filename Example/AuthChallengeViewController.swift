//
//  AuthChallengeViewController.swift
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
                guard challenge.previousFailureCount == 0 else {
                    handler(URLSession.AuthChallengeDisposition.performDefaultHandling, nil)
                    return
                }
                /*
                 The correct credentials are:
                 
                 user = guest
                 password = guest
                 
                You might want to start with the invalid credentials to get a sense of how this code works
                */
                let credential = URLCredential(user: "bad-user", password: "bad-password", persistence: URLCredential.Persistence.forSession)
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
