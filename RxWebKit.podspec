Pod::Spec.new do |s|
  s.name         = "RxWebKit"
  s.version      = "0.3.5"
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
  s.author       = { "mokumoku" => "da1lawmoku2@gmail.com" }
  s.source       = { :git => "https://github.com/RxSwiftCommunity/RxWebKit.git", :tag => s.version.to_s }
  s.source_files  = "RxWebKit/Sources/**/*.swift"

  s.ios.deployment_target = '8.0'

  s.dependency 'RxSwift', '~> 4.0.0-beta.0'
  s.dependency 'RxCocoa', '~> 4.0.0-beta.0'
end
