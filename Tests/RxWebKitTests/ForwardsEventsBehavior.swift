import Foundation
import Nimble
import Quick
import RxCocoa
import RxSwift
import RxTest
@testable import RxWebKit
import WebKit

struct ForwardsEventsBehaviorContext {
  let sut: WKWebView
  let scheduler: TestScheduler
  let selector: Selector
  let invoked: () -> Void

  init(_ sut: WKWebView, _ scheduler: TestScheduler, _ selector: Selector, invoked: @escaping (() -> Void)) {
    self.sut = sut
    self.scheduler = scheduler
    self.selector = selector
    self.invoked = invoked
  }
}

class ForwardsEventsBehavior: Quick.Behavior<ForwardsEventsBehaviorContext> {
  override class func spec(_ context: @escaping () -> ForwardsEventsBehaviorContext) {
    var sut: WKWebView!
    var scheduler: TestScheduler!
    var selector: Selector!
    var invoked: (() -> Void)!

    beforeEach {
      let cxt = context()
      sut = cxt.sut
      scheduler = cxt.scheduler
      selector = cxt.selector
      invoked = cxt.invoked
    }

    afterEach {
      sut = nil
      scheduler = nil
      selector = nil
    }

    describe("b") {
      it("sentMessage") {
        SharingScheduler.mock(scheduler: scheduler) {
          let sentMessage = scheduler.record(source: sut.rx.delegate.sentMessage(selector))
          invoked()
          scheduler.start()
          expect(sentMessage.events.count).to(equal(1))
        }
      }

      it("methodInvoke") {
        SharingScheduler.mock(scheduler: scheduler) {
          let methodInvoked = scheduler.record(source: sut.rx.delegate.methodInvoked(selector))
          invoked()
          scheduler.start()
          expect(methodInvoked.events.count).to(equal(1))
        }
      }
    }
  }
}
