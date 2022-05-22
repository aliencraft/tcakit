import Combine
import ComposableArchitecture
import UIKit

open class StoreViewController<State: Equatable, Action>: UIViewController {
    public let store: Store<State, Action>
    public lazy var viewStore = ViewStore(store)
    public var cancellables: Set<AnyCancellable> = []

    public init(store: Store<State, Action>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required public init?(coder: NSCoder) { nil }
}
