import Foundation
import Quick
import Nimble
import RxSwift
import RxCocoa
import RxTest
import WebKit
@testable import RxWebKit

struct HasEventsBehaviorContext<T> {
    let scheduler: TestScheduler
    let observable: Observable<T>
    init(_ scheduler: TestScheduler, _ observable: Observable<T>) {
        self.scheduler = scheduler
        self.observable = observable
    }
}


extension TestScheduler {
    /// Builds testable observer for s specific observable sequence, binds it's results and sets up disposal.
    /// parameter source: Observable sequence to observe.
    /// returns: Observer that records all events for observable sequence.
    func record<O: ObservableConvertibleType>(source: O) -> TestableObserver<O.Element> {
        let observer = self.createObserver(O.Element.self)
        let disposable = source.asObservable().bind(to: observer)
        self.scheduleAt(100000) {
            disposable.dispose()
        }
        return observer
    }
}
