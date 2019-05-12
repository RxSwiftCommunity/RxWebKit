import UIKit
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
        
    }
}
