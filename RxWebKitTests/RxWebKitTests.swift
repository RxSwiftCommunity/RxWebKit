import WebKit
import Quick
import Nimble
import RxSwift
import RxTest
@testable import RxWebKit

class RxWebKitTests: QuickSpec {
    override func spec() {
        var scheduler: TestScheduler!
        var sut: WKWebView!
        let html = """
                <!DOCTYPE html>
                <html>
                <head>
                <title>RxWebKit</title>
                </head>
                <body>

                <h1>This is a Heading</h1>
                <p>This is a paragraph.</p>

                </body>
                </html>
        """
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            sut = WKWebView(frame: CGRect.zero)
        }
        
        afterEach {
            scheduler = nil
            sut = nil
        }
        
        itBehavesLike(HasEventsBehavior<String?>.self) {
            HasEventsBehaviorContext(scheduler, sut.rx.title, "")
        }
        
        itBehavesLike(HasEventsBehavior<Bool>.self) {
            sut.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
            return HasEventsBehaviorContext(scheduler, sut.rx.loading, true)
        }
        
        itBehavesLike(HasEventsBehavior<Bool>.self) {
            HasEventsBehaviorContext(scheduler, sut.rx.loading, false)
        }
        
        itBehavesLike(HasEventsBehavior<Double>.self) {
            HasEventsBehaviorContext(scheduler, sut.rx.estimatedProgress, 0.0)
        }
        
        itBehavesLike(HasEventsBehavior<Double>.self) {
            sut.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
            return HasEventsBehaviorContext(scheduler, sut.rx.estimatedProgress, 0.1)
        }
        
        itBehavesLike(HasEventsBehavior<Bool>.self) {
            HasEventsBehaviorContext(scheduler, sut.rx.canGoBack, false)
        }
        
        itBehavesLike(HasEventsBehavior<Bool>.self) {
            HasEventsBehaviorContext(scheduler, sut.rx.canGoForward, false)
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .didTerminate) {
                sut.navigationDelegate?.webViewWebContentProcessDidTerminate?(sut)
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .didCommitNavigation) {
                let navigation = sut.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                sut.navigationDelegate?.webView?(sut, didCommit: navigation)
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .didFinishNavigation) {
                let navigation = sut.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                sut.navigationDelegate?.webView?(sut, didFinish: navigation)
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .didReceiveServerRedirectForProvisionalNavigation) {
                let navigation = sut.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                sut.navigationDelegate?.webView?(sut, didReceiveServerRedirectForProvisionalNavigation: navigation)
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .didFailNavigation) {
                let navigation = sut.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                sut.navigationDelegate?.webView?(sut, didFail: navigation, withError: TestError.didFailNavigation)
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .didFailProvisionalNavigation) {
                let navigation = sut.loadHTMLString(html, baseURL: Bundle.main.resourceURL)
                sut.navigationDelegate?.webView?(sut, didFailProvisionalNavigation: navigation, withError: TestError.didFailProvisionalNavigation)
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .didReceiveChallenge) {
                let protectionSpace = URLProtectionSpace(host: "fake", port: 8443, protocol: nil, realm: nil, authenticationMethod: nil)
                let credential = URLCredential(user: "bad-user", password: "bad-password", persistence: URLCredential.Persistence.forSession)
                let sender = MockURLAuthenticationChallengeSender()
                
                let challenge = URLAuthenticationChallenge(protectionSpace: protectionSpace, proposedCredential: credential, previousFailureCount: 0, failureResponse:nil, error: TestError.didReceiveChallenge, sender: sender)
                
                sut.navigationDelegate?.webView?(sut, didReceive: challenge, completionHandler: { (_, _) in })
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .decidePolicyNavigationAction) {
                let delegate:WKNavigationDelegate? = sut.navigationDelegate
                delegate?.webView?(sut, decidePolicyFor: WKNavigationAction(), decisionHandler: { (_) in })
            }
        }
        
        itBehavesLike(ForwardsEventsBehavior.self) {
            ForwardsEventsBehaviorContext(sut, scheduler, .decidePolicyNavigationResponse) {
                let delegate:WKNavigationDelegate? = sut.navigationDelegate
                delegate?.webView?(sut, decidePolicyFor: WKNavigationResponse(), decisionHandler: { (_) in })
            }
        }
    }
}

enum TestError: Error {
    case didFailNavigation
    case didFailProvisionalNavigation
    case didReceiveChallenge
}

@objc class MockURLAuthenticationChallengeSender: NSObject, URLAuthenticationChallengeSender {
    override func `self`() -> Self {
        return self
    }
    
    override init() {}
    func use(_ credential: URLCredential, for challenge: URLAuthenticationChallenge) { }
    
    func continueWithoutCredential(for challenge: URLAuthenticationChallenge) {}
    
    func cancel(_ challenge: URLAuthenticationChallenge) { }
}
