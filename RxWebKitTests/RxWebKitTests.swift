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
        var disposeBag: DisposeBag!
        var sut: WKWebView!
        
        beforeEach {
            scheduler = TestScheduler(initialClock: 0)
            disposeBag = DisposeBag()
            sut = WKWebView(frame: CGRect.zero)
        }
        
        afterEach {
            scheduler = nil
            disposeBag = nil
            sut = nil
        }
    }
}
