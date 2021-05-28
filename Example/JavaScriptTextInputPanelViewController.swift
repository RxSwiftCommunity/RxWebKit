//
//  JavaScriptTextInputPanelViewController.swift
//  Example
//
//  Created by TTOzzi on 2021/05/29.
//  Copyright © 2021 RxSwift Community. All rights reserved.
//

import UIKit
import WebKit
import RxWebKit
import RxSwift
import RxCocoa

class JavaScriptTextInputPanelViewController: UIViewController {

    let bag = DisposeBag()
    let wkWebView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(wkWebView)
        wkWebView.load(URLRequest(url: URL(string: "https://www.w3schools.com/jsref/tryit.asp?filename=tryjsref_prompt")!))
        
        wkWebView.rx
            .javaScriptTextInputPanel
            .debug("javaScriptTextInputPanel")
            .subscribe(onNext: { [weak self] webView, prompt, defaultText, frame, handler in
                guard let self = self else { return }
                let alert = UIAlertController(title: "JavaScriptTextInput", message: prompt, preferredStyle: .alert)
                alert.addTextField { textField in
                    textField.text = defaultText
                }
                alert.addAction(
                    UIAlertAction(title: "Confirm", style: .default, handler: { _ in
                        let text = alert.textFields?.first?.text
                        handler(text)
                    })
                )
                alert.addAction(
                    UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                        handler(nil)
                    })
                )
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
