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
    }
}
