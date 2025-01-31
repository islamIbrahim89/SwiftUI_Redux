//
//  Store.swift
//  SwiftUI_Redux
//
//  Created by Islam Moussa on 9/14/20.
//

import Foundation

typealias Dispatcher = (Action) -> Void

typealias Reducer<State: ReduxState> = (_ state: State, _ action: Action) -> State
typealias Middleware<StoreState: ReduxState> = (StoreState, Action, @escaping Dispatcher) -> Void

protocol ReduxState { }

struct AppState: ReduxState {
    var authState = AuthState()
}

// MARK: - Redux Actions
protocol Action { }

// MARK: - Store
class AppStore: ObservableObject {
    @Published var state: AppState
    var reducer: Reducer<AppState>
    var middlewares: [Middleware<AppState>]
    
    init(reducer: @escaping Reducer<AppState>, state: AppState, middlewares: [Middleware<AppState>] = []) {
        self.reducer = reducer
        self.state = state
        self.middlewares = middlewares
    }
    
    func dispatch(action: Action) {
        DispatchQueue.main.async {
            self.state = self.reducer(self.state, action)
        }
        
        middlewares.forEach { middleware in
            middleware(state, action, dispatch)
        }
    }
}
