import Combine
import ComposableArchitecture
import OrderedCollections
import UIKit

/// The `StackNavigationHandler` listens to state changes and updates the UINavigationController accordingly.
/// It also supports automatic state updates for popping items via the leading-edge swipe gesture
/// or the long press back-button menu.
public class StackNavigationHandler<ViewProvider: ViewProviderProtocol>: NSObject, UINavigationControllerDelegate {
    public typealias Item = ViewProvider.Item
    public typealias Stack = StackNavigation<Item>
    
    private let viewStore: ViewStore<Stack.State, Stack.Action>
    private let viewProvider: ViewProvider
    private var viewControllers: OrderedDictionary<Item, UIViewController> = [:]
    private var cancellable: AnyCancellable?
    
    public init(store: Store<Stack.State, Stack.Action>, viewProvider: ViewProvider) {
        self.viewStore = ViewStore(store)
        self.viewProvider = viewProvider
    }
    
    public func setup(with navigationController: UINavigationController) {
        navigationController.delegate = self
        cancellable = viewStore.publisher.sink { [weak self, weak navigationController] state in
            guard let self = self, let navigationController = navigationController else { return }
            self.updateStack(with: state, for: navigationController)
        }
    }
    
    private func updateStack(with newState: Stack.State, for navigationController: UINavigationController) {
        let newItems = newState.items
        guard newItems != Array(viewControllers.keys) else { return }
        let newViewControllers = newItems.map { item in
            viewControllers[item] ?? viewProvider.viewController(for: item)
        }
        let animated = !viewControllers.isEmpty && newState.areAnimationsEnabled && UIView.areAnimationsEnabled
        navigationController.setViewControllers(newViewControllers, animated: animated)
        viewControllers = OrderedDictionary(uniqueKeys: newItems, values: newViewControllers)
    }
    
    // MARK: - UINavigationControllerDelegate
    
    public func navigationController(
        _ navigationController: UINavigationController,
        didShow viewController: UIViewController,
        animated: Bool
    ) {
        guard
            let transition = navigationController.transitionCoordinator,
            let fromViewController = transition.viewController(forKey: .from),
            let toViewController = transition.viewController(forKey: .to),
            let fromIndex = viewControllers.values.firstIndex(of: fromViewController),
            let toIndex = viewControllers.values.firstIndex(of: toViewController),
            toIndex < fromIndex
        else {
            return
        }
        viewStore.send(.popItems(count: fromIndex - toIndex, animated: animated))
    }
}
