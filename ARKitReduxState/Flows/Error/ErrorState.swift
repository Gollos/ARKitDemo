//
//  ErrorState.swift
//  ARKitReduxState
//
//  Created by Golos on 1/13/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift

public struct ErrorState: StateType {
    public var generalErrorMessage: String?
}

extension ErrorState {
    struct Reducer {
        static func handleAction(action: Action, state: ErrorState?) -> ErrorState {
            var state = state ?? ErrorState(generalErrorMessage: nil)
            
            switch action {
            case let Actions.errorMessage(error):
                state.generalErrorMessage = error
            default:
                state.generalErrorMessage = nil
            }
            return state
        }
    }
    
    enum Actions: Action {
        case errorMessage(String)
    }
}
