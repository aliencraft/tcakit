import Combine
import ComposableArchitecture
import UIKit

public final class IfLetViewController<State, Action>: UIViewController {
    private let store: Store<State?, Action>
    private let ifDestination: (Store<State, Action>) -> UIViewController
    private let elseDestination: () -> UIViewController
    private let onDismiss: (() -> Void)?

    private var ifLetCancellable: Cancellable?
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
        ifLetCancellable = store.ifLet(
            then: { [unowned self] store in setChild(ifDestination(store)) },
            else: { [unowned self] in setChild(elseDestination()) }
        )
    }

    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
         if isMovingFromParent {
             onDismiss?()
         }
    }

    private func setChild(_ child: UIViewController) {
        clear()
        add(child)
    }

    private func clear() {
        cancellables.removeAll()
        if let child = children.last {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }

    private func add(_ child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.topAnchor.constraint(equalTo: view.topAnchor),
            child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        child.didMove(toParent: self)

        child.publisher(for: \.title)
            .sink { [unowned self] in title = $0 }
            .store(in: &cancellables)

        child.navigationItem.publisher(for: \.title)
            .assign(to: \.title, on: navigationItem)
            .store(in: &cancellables)

        child.navigationItem.publisher(for: \.leftBarButtonItem)
            .assign(to: \.leftBarButtonItem, on: navigationItem)
            .store(in: &cancellables)

        child.navigationItem.publisher(for: \.leftBarButtonItems)
            .assign(to: \.leftBarButtonItems, on: navigationItem)
            .store(in: &cancellables)

        child.navigationItem.publisher(for: \.rightBarButtonItem)
            .assign(to: \.rightBarButtonItem, on: navigationItem)
            .store(in: &cancellables)

        child.navigationItem.publisher(for: \.rightBarButtonItems)
            .assign(to: \.rightBarButtonItems, on: navigationItem)
            .store(in: &cancellables)
    }
}
