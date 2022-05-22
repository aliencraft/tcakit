import ComposableArchitecture

extension Reducer {
    public func pullback<GlobalState, GlobalAction>(
        state toLocalState: WritableKeyPath<GlobalState, State>,
        action toLocalAction: CasePath<GlobalAction, Action>
    ) -> Reducer<GlobalState, GlobalAction, Environment> {
        pullback(
            state: toLocalState,
            action: toLocalAction,
            environment: { $0 }
        )
    }

    public func pullback<GlobalState, GlobalAction>(
        state toLocalState: CasePath<GlobalState, State>,
        action toLocalAction: CasePath<GlobalAction, Action>,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Reducer<GlobalState, GlobalAction, Environment> {
        pullback(
            state: toLocalState,
            action: toLocalAction,
            environment: { $0 },
            file: file,
            line: line
        )
    }

    public func forEach<GlobalState, GlobalAction, ID>(
        state toLocalState: WritableKeyPath<GlobalState, IdentifiedArray<ID, State>>,
        action toLocalAction: CasePath<GlobalAction, (ID, Action)>,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Reducer<GlobalState, GlobalAction, Environment> {
        forEach(
            state: toLocalState,
            action: toLocalAction,
            environment: { $0 },
            file: file,
            line: line
        )
    }
}
