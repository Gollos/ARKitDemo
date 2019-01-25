//
//  PockemonActions.swift
//  ARKitReduxState
//
//  Created by Golos on 1/20/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift
import SceneKit

enum PockemonActions: Action {
    case setSelectedPockemon(String)
    case showPockemonsSheet([String])
    case add(CGPoint, String?)
    case evolve(String)
    case remove(String)
}

public func setSelectedPockemon(name: String) -> Action {
    return PockemonActions.setSelectedPockemon(name)
}

public func showPockemonsSheet() -> Action {
    return PockemonActions.showPockemonsSheet(PockemonType.allCases.compactMap { $0.rawValue })
}

public func tappedLocation(point: CGPoint, identifier: String?) -> Store<AppState>.ActionCreator  {
    return { state, store in
        guard let id = identifier,
            state.pockemonState.evolutionInfo[id] != nil else {
            return PockemonActions.add(point, identifier)
        }
        switch state.pockemonState.evolutionInfo[id] {
        case .middle?, .top?:
            return PockemonActions.evolve(id)
        case .grand?:
            return PockemonActions.remove(id)
        default:
            return nil
        }
    }
}
