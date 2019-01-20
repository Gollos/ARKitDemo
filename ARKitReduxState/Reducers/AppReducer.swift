//
//  AppReducer.swift
//  ARKitReduxState
//
//  Created by Golos on 1/20/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(pockemonState: pockemonReducer(action: action, state: state?.pockemonState))
}
