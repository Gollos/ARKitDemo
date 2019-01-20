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
}

public func createStore() -> Store<AppState> {
    return Store<AppState>(reducer: appReducer, state: nil)
}
