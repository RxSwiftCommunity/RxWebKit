
import Foundation
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import WebKit
@testable import RxWebKit

struct ForwardsEventsBehaviorContext {
    let sut: WKWebView
    let scheduler: TestScheduler
    let selector: Selector
    let invoked: (() -> ())
    
    init(_ sut: WKWebView, _ scheduler: TestScheduler, _ selector: Selector, invoked: @escaping(() -> ())) {
        self.sut = sut
        self.scheduler = scheduler
        self.selector = selector
        self.invoked = invoked
    }
}
