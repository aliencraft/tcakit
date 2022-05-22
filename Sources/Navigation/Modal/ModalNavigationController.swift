import ComposableArchitecture
import UIKit

/// A convenience container view controller intended to decouple the content and modal presented views.
/// This way the content view can be reused in multiple contexts without tying the content view's
/// implementation and the navigation logic together.
public class ModalNavigationController<ViewProvider: ViewProviderProtocol>: UIViewController {
    public typealias Modal = ModalNavigation<ViewProvider.Item>
    
    private let navigationHandler: ModalNavigationHandler<ViewProvider>
    
    public convenience init(
        contentViewController: UIViewController,
        store: Store<Modal.State, Modal.Action>,
        viewProvider: ViewProvider
    ) {
        self.init(
            contentViewController: contentViewController,
            navigationHandler: ModalNavigationHandler(store: store, viewProvider: viewProvider)
        )
    }

    public init(
        contentViewController: UIViewController,
        navigationHandler: ModalNavigationHandler<ViewProvider>
    ) {
        self.navigationHandler = navigationHandler
        super.init(nibName: nil, bundle: nil)
        addContent(contentViewController)
        navigationHandler.setup(with: self)
    }
    
    public required init?(coder: NSCoder) { nil }
    
    private func addContent(_ viewController: UIViewController) {
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: viewController.view.topAnchor),
            view.leftAnchor.constraint(equalTo: viewController.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: viewController.view.rightAnchor),
            view.bottomAnchor.constraint(equalTo: viewController.view.bottomAnchor),
        ])
        didMove(toParent: viewController)
    }
}
