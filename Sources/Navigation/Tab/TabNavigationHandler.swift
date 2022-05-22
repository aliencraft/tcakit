import Combine
import ComposableArchitecture
import OrderedCollections
import UIKit

/// The `TabNavigationHandler` listens to state changes and updates the selected view or tab order accordingly.
/// Additionally, it acts as the `UITabBarControllerDelegate` and automatically updates the state
/// when the active tab is changed by the user.
public class TabNavigationHandler<ViewProvider: ViewProviderProtocol>: NSObject, UITabBarControllerDelegate {
    public typealias Item = ViewProvider.Item
    public typealias Tabs = TabNavigation<Item>
    
    private let viewStore: ViewStore<Tabs.State, Tabs.Action>
    private let viewProvider: ViewProvider
    private var viewControllers: OrderedDictionary<Item, UIViewController> = [:]
    private var cancellable: AnyCancellable?
    
    public init(store: Store<Tabs.State, Tabs.Action>, viewProvider: ViewProvider) {
        self.viewStore = ViewStore(store)
        self.viewProvider = viewProvider
    }
    
    public func setup(with tabBarController: UITabBarController) {
        tabBarController.delegate = self
        cancellable = viewStore.publisher.sink { [weak self, weak tabBarController] newState in
            guard let self = self, let tabBarController = tabBarController else { return }
            self.updateTabs(with: newState, for: tabBarController)
        }
    }
    
    private func updateTabs(with newState: Tabs.State, for tabBarController: UITabBarController) {
        let newItems = newState.items
        if newItems != Array(viewControllers.keys) {
            let newViewControllers = newItems.map { item in
                viewControllers[item] ?? viewProvider.viewController(for: item)
            }
            let animated = !viewControllers.isEmpty && newState.areAnimationsEnabled && UIView.areAnimationsEnabled
            tabBarController.setViewControllers(newViewControllers, animated: animated)
            viewControllers = OrderedDictionary(uniqueKeys: newItems, values: newViewControllers)
        }
        if let index = newItems.firstIndex(of: newState.activeItem), index != tabBarController.selectedIndex {
            tabBarController.selectedIndex = index
        }
    }
    
    // MARK: - UITabBarControllerDelegate
    
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let index = tabBarController.viewControllers?.firstIndex(of: viewController) else { return }
        viewStore.send(.setActiveIndex(index))
    }
}
