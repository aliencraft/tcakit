import ComposableArchitecture
import UIKit

public extension UIAlertAction {
    /// Create and return an action with the specified title and action.
    /// This convenience initializer sends the provided action to the view store and updates the modal navigation
    /// state (sends `.dismiss`). This is necessary because `UIAlertController` dismisses itself automatically.
    convenience init<State: Equatable, Action, Item: Hashable>(
        title: String?,
        style: UIAlertAction.Style,
        store: Store<State, Action>,
        action: Action? = nil,
        navigationAction: @escaping (ModalNavigation<Item>.Action) -> Action
    ) {
        self.init(title: title, style: style) { _ in
            let statelessNavigationStore = store.scope(
                state: { _ in () },
                action: navigationAction
            )
            ViewStore(statelessNavigationStore).send(.dismiss())
            if let action = action {
                ViewStore(store).send(action)
            }
        }
    }
}
