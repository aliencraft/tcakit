import Combine
import ComposableArchitecture
import UIKit

public final class IfLetNavigationController<State, Action>: UINavigationController {
    private let store: Store<State?, Action>
    private let ifDestination: (Store<State, Action>) -> UIViewController
    private let elseDestination: () -> UIViewController
    private let onDismiss: (() -> Void)?

    private var cancellables: Set<AnyCancellable> = []

    public init(
        store: Store<State?, Action>,
        then ifDestination: @escaping (Store<State, Action>) -> UIViewController,
        else elseDestination: @escaping () -> UIViewController = ActivityIndicatorViewController.init,
        onDismiss: (() -> Void)? = nil
    ) {
        self.store = store
        self.ifDestination = ifDestination
        self.elseDestination = elseDestination
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { nil }

    public override func viewDidLoad() {
        super.viewDidLoad()
        store.ifLet(
            then: { [unowned self] store in
                setViewControllers([ifDestination(store)], animated: false)
            },
            else: { [unowned self] in
                setViewControllers([elseDestination()], animated: false)
            }
        )
        .store(in: &cancellables)
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            onDismiss?()
        }
    }
}
