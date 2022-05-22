import ComposableArchitecture
import UIKit

public extension UIViewController {
    func withModal<ViewProvider: ViewProviderProtocol>(
        store: Store<ModalNavigation<ViewProvider.Item>.State, ModalNavigation<ViewProvider.Item>.Action>,
        viewProvider: ViewProvider
    ) -> ModalNavigationController<ViewProvider> {
        ModalNavigationController(contentViewController: self, store: store, viewProvider: viewProvider)
    }
}
