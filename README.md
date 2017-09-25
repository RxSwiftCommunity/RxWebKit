# RxWebKit

RxWebKit is a [RxSwift](https://github.com/ReactiveX/RxSwift) wrapper for `WebKit`.

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Version](https://img.shields.io/cocoapods/v/RxWebKit.svg?style=flat)](http://cocoapods.org/pods/RxWebKit)
[![License](https://img.shields.io/cocoapods/l/RxWebKit.svg?style=flat)](http://cocoapods.org/pods/RxWebKit)
[![Platform](https://img.shields.io/cocoapods/p/RxWebKit.svg?style=flat)](http://cocoapods.org/pods/RxWebKit)

## Example Usages

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

## Installation

### CocoaPods

Add to `Podfile`:

```
pod 'RxWebKit'
```

### Carthage

Add to `Cartfile`:

```
github "RxSwiftCommunity/RxWebKit"
```

Run `carthage update --platform iOS`

Add run script build phase `/usr/local/bin/carthage copy-frameworks` with input files being:

```
$(SRCROOT)/carthage/Build/iOS/RxWebKit.framework
```

## Requirements

RxWebKit requires Swift 4.0 and dedicated versions of RxSwift 4.0.0-beta.0

## License

MIT
