import Combine
import ComposableArchitecture
import UIKit

/// The `ModalNavigationHandler` listens to state changes and presents the provided views accordingly.
/// Additionally, it acts as the `UIAdaptivePresentationControllerDelegate` and automatically updates the state
/// for pull-to-dismiss gestures for views presented as a sheet.
public class ModalNavigationHandler<ViewProvider: ViewProviderProtocol>:
    NSObject, UIAdaptivePresentationControllerDelegate
{
    public typealias Item = ViewProvider.Item
    public typealias Modal = ModalNavigation<Item>
    
    private let viewStore: ViewStore<Modal.State, Modal.Action>
    private let viewProvider: ViewProvider
    private var presentedItem: Item?
    private var presentedViewController: UIViewController?
    private var cancellable: AnyCancellable?
    
    public init(store: Store<Modal.State, Modal.Action>, viewProvider: ViewProvider) {
        self.viewStore = ViewStore(store)
        self.viewProvider = viewProvider
    }
    
    public func setup(with presentingViewController: UIViewController) {
        cancellable = viewStore.publisher.sink { [weak self, weak presentingViewController] newState in
            guard let self = self, let presentingViewController = presentingViewController else { return }
            self.updateModal(with: newState, for: presentingViewController)
        }
    }
    
    private func updateModal(with newState: Modal.State, for presentingViewController: UIViewController) {
        let newItem = newState.item
        guard newItem != presentedItem else { return }

        let animated = newState.areAnimationsEnabled && UIView.areAnimationsEnabled
        
        if presentedItem != nil {
            // Prevent dismissal of unrelated view controller
            if presentingViewController.presentedViewController == presentedViewController {
                presentingViewController.dismiss(animated: animated)
            }
            presentedItem = nil
            presentedViewController = nil
        }
        
        if let newItem = newItem {
            let newViewController = viewProvider.viewController(for: newItem)
            if !(newViewController is UIAlertController) {
                // UIAlertController won't allow changes to the delegate (app crashes).
                // Use UIAlertAction extension to update modal navigation state
                // when UIAlertController dismisses itself.
                newViewController.presentationController?.delegate = self
            }
            presentingViewController.present(newViewController, animated: animated)
            presentedItem = newItem
            presentedViewController = newViewController
        }
    }
    
    // MARK: - UIAdaptivePresentationControllerDelegate
    
    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        viewStore.send(.dismiss())
    }
}
