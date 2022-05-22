import ComposableArchitecture

/// `TabNavigation` models state and actions of a tab-based scheme for navigating multiple child views.
/// The active navigation item can be changed by setting a new item. Mutations to the items array
/// are reflected as well (e.g. changing the tab order).
public struct TabNavigation<Item: Equatable> {
    public struct State: Equatable {
        private(set) public var items: [Item]
        private(set) public var activeItem: Item
        private(set) public var areAnimationsEnabled: Bool
        
        public init(
            items: [Item],
            activeItem: Item,
            areAnimationsEnabled: Bool = true
        ) {
            self.items = items
            self.activeItem = activeItem
            self.areAnimationsEnabled = areAnimationsEnabled
        }
        
        public mutating func setActiveIndex(_ index: Int) {
            guard items.indices.contains(index) else { return }
            activeItem = items[index]
        }
        
        public mutating func setActiveItem(_ item: Item) {
            guard items.contains(item) else { return }
            activeItem = item
        }

        public mutating func setItems(_ newItems: [Item], animated: Bool = true) {
            items = newItems
            areAnimationsEnabled = animated
            if !newItems.contains(activeItem) {
                setActiveIndex(0)
            }
        }
    }
    
    public enum Action: Equatable {
        case setActiveItem(Item)
        case setActiveIndex(Int)
        case setItems([Item], animated: Bool = true)
    }
    
    public static var reducer: Reducer<State, Action, Void> {
        Reducer { state, action, _ in
            switch action {
            case .setActiveItem(let item):
                state.setActiveItem(item)
            case .setActiveIndex(let index):
                state.setActiveIndex(index)
            case let .setItems(items, animated):
                state.setItems(items, animated: animated)
            }
            return .none
        }
    }
}
