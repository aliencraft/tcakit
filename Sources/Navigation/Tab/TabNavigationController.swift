import ComposableArchitecture
import UIKit

/// A convenience UITabBarController implementation containing a `TabNavigationHandler`.
public class TabNavigationController<ViewProvider: ViewProviderProtocol>: UITabBarController {
    public typealias Tabs = TabNavigation<ViewProvider.Item>
    
    private let navigationHandler: TabNavigationHandler<ViewProvider>
    
    public init(navigationHandler: TabNavigationHandler<ViewProvider>) {
        self.navigationHandler = navigationHandler
        super.init(nibName: nil, bundle: nil)
        navigationHandler.setup(with: self)
    }

    public convenience init(store: Store<Tabs.State, Tabs.Action>, viewProvider: ViewProvider) {
        self.init(navigationHandler: TabNavigationHandler(store: store, viewProvider: viewProvider))
    }
    
    public required init?(coder: NSCoder) { nil }
}
