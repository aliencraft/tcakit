import ComposableArchitecture
import UIKit

/// A convenience UINavigationController implementation containing a `StackNavigationHandler`.
open class StackNavigationController<ViewProvider: ViewProviderProtocol>: UINavigationController {
    public typealias Stack = StackNavigation<ViewProvider.Item>

    private let navigationHandler: StackNavigationHandler<ViewProvider>
    
    public init(navigationHandler: StackNavigationHandler<ViewProvider>) {
        self.navigationHandler = navigationHandler
        super.init(nibName: nil, bundle: nil)
        navigationHandler.setup(with: self)
    }

    public convenience init(store: Store<Stack.State, Stack.Action>, viewProvider: ViewProvider) {
        self.init(navigationHandler: StackNavigationHandler(store: store, viewProvider: viewProvider))
    }

    public required init?(coder: NSCoder) { nil }
}
