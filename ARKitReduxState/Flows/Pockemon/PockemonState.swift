//
//  PockemonState.swift
//  ARKitReduxState
//
//  Created by Golos on 1/13/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift

public enum PockemonType: String, CaseIterable {
    case bulbasaur = "Bulbasaur"
    case squirtle = "Squirtle"
}

public struct PockemonState: StateType {
    public var pockemonType: PockemonType?
}

extension PockemonState {
    
    struct Reducer {
        static func handleAction(action: Action, state: PockemonState?) -> PockemonState {
            var state = state ?? PockemonState(pockemonType: nil)
            
            switch action {
            case let Actions.setPockemon(type):
                state.pockemonType = type
            default:
                state.pockemonType = nil
            }
            return state
        }
    }
    
    enum Actions: Action {
        case setPockemon(PockemonType)
    }
    
    public enum ActionCreators {
        public static func didTapOnPockemon(name: String?) -> Store<AppState>.ActionCreator {
            return { state, store in
                guard let name = name,
                    let type = PockemonType(rawValue: name) else { return nil }
                
                return Actions.setPockemon(type)
            }
        }
    }
}
