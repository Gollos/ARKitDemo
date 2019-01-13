//
//  AppState.swift
//  ARKitReduxState
//
//  Created by Golos on 1/12/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift

public struct AppState: StateType {
    public let pockemonState: PockemonState
    public let errorState: ErrorState
}

extension AppState {
    static func appReducer(action: Action, state: AppState?) -> AppState {
        return AppState(pockemonState: PockemonState.Reducer.handleAction(action: action, state: state?.pockemonState),
                        errorState: ErrorState.Reducer.handleAction(action: action, state: state?.errorState))
    }
}

public func createStore() -> Store<AppState> {
    return Store<AppState>(reducer: AppState.appReducer, state: nil, middleware: [])
}
