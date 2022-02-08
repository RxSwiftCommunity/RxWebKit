Pod::Spec.new do |s|
  s.name         = "RxWebKit"
  s.version      = "2.0.1"
  s.summary      = "RxWebKit is a RxSwift wrapper for WebKit."
  s.description  = <<-DESC
  RxWebKit is a RxSwift wrapper for `WebKit`.

  ```swift
  // MARK: Setup WKWebView

  let webView = WKWebView(frame: self.view.bounds)
  self.view.addSubview(webView)


  // MARK: Observing properties

  webView.rx.title
      .subscribe(onNext: {
          print("title: \($0)")
      })
      .disposed(by: disposeBag)

  webView.rx.url
      .subscribe(onNext: {
          print("URL: \($0)")
      })
      .disposed(by: disposeBag)
  ```
  DESC

  s.homepage     = "https://github.com/RxSwiftCommunity/RxWebKit"
  s.license      = "MIT"
  s.authors       = { "mokumoku" => "da1lawmoku2@gmail.com",
                      "RxSwift Community" => "community@rxswift.org"
                    }
  s.source       = { :git => "https://github.com/RxSwiftCommunity/RxWebKit.git", :tag => s.version.to_s }
  s.source_files  = "Sources/RxWebKit/**/*.{swift}"
  s.exclude_files = "Sources/RxWebKit/**/*.{plist}"
  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.13'
  s.swift_version = '5.0'
  s.dependency 'RxSwift', '~> 6.0'
  s.dependency 'RxCocoa', '~> 6.0'
end
