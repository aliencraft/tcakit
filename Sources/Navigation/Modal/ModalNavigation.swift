import UIKit
import ComposableArchitecture

/// `ModalNavigation` models state and actions of a modal view presentation.
/// Views can be presented and dismissed.
public struct ModalNavigation<Item: Equatable> {
    public struct State: Equatable {
        private(set) public var item: Item?
        private(set) public var areAnimationsEnabled: Bool
        
        public init(
            item: Item? = nil,
            areAnimationsEnabled: Bool = true
        ) {
            self.item = item
            self.areAnimationsEnabled = areAnimationsEnabled
        }
        
        public mutating func set(_ item: Item?, animated: Bool = true) {
            self.item = item
            self.areAnimationsEnabled = animated
        }

        public mutating func present(_ item: Item, animated: Bool = true) {
            set(item, animated: animated)
        }

        public mutating func dismiss(animated: Bool = true) {
            set(nil, animated: animated)
        }
    }
    
    public enum Action: Equatable {
        case set(Item?, animated: Bool = true)
        case present(Item, animated: Bool = true)
        case dismiss(animated: Bool = true)
    }
    
    public static var reducer: Reducer<State, Action, Void> {
        Reducer { state, action, _ in
            switch action {
            case let .set(item, animated):
                state.set(item, animated: animated)
            case let .present(item, animated):
                state.present(item, animated: animated)
            case let .dismiss(animated):
                state.dismiss(animated: animated)
            }
            return .none
        }
    }
}
