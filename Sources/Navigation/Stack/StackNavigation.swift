import ComposableArchitecture

/// `StackNavigation` models state and actions of a stack-based scheme for navigating hierarchical content.
/// Views can be pushed on the stack or popped from the stack. Even mutations to the whole stack can be performed.
public struct StackNavigation<Item: Equatable> {
    public struct State: Equatable {
        private(set) public var items: [Item]
        private(set) public var areAnimationsEnabled: Bool
        
        public var topItem: Item? { items.last }
        
        public init(items: [Item], areAnimationsEnabled: Bool = true) {
            self.items = items
            self.areAnimationsEnabled = areAnimationsEnabled
        }
        
        public mutating func push(_ newItem: Item, animated: Bool = true) {
            items += [newItem]
            areAnimationsEnabled = animated
        }

        public mutating func push(_ newItems: [Item], animated: Bool = true) {
            items += newItems
            areAnimationsEnabled = animated
        }

        public mutating func pop(count: Int = 1, animated: Bool = true) {
            guard count <= items.count else { return }
            items.removeLast(count)
            areAnimationsEnabled = animated
        }

        public mutating func popToRoot(animated: Bool = true) {
            pop(count: items.count - 1, animated: animated)
        }

        public mutating func setItems(_ newItems: [Item], animated: Bool = true) {
            items = newItems
            areAnimationsEnabled = animated
        }
    }
    
    public enum Action: Equatable {
        case pushItem(Item, animated: Bool = true)
        case pushItems([Item], animated: Bool = true)
        case popItem(animated: Bool = true)
        case popItems(count: Int, animated: Bool = true)
        case popToRoot(animated: Bool = true)
        case setItems([Item], animated: Bool = true)
    }
    
    public static var reducer: Reducer<State, Action, Void> {
        Reducer { state, action, _ in
            switch action {
            case let .pushItem(item, animated):
                state.push(item, animated: animated)
            case let .pushItems(items, animated):
                state.push(items, animated: animated)
            case let .popItem(animated):
                state.pop(animated: animated)
            case let .popItems(count, animated):
                state.pop(count: count, animated: animated)
            case let .popToRoot(animated):
                state.popToRoot(animated: animated)
            case let .setItems(items, animated):
                state.setItems(items, animated: animated)
            }
            return .none
        }
    }
}
