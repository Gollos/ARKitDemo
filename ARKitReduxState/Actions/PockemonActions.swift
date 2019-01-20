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
    case setLocation(CGPoint)
    case setSelectedPockemon(String)
    case showPockemonsSheet([String])
    case add(String)
    case evolve(String)
    case remove(String)
}

public func setSelectedPockemon(name: String) -> Action {
    return PockemonActions.setSelectedPockemon(name)
}

public func setPockemon(identifier: String) -> Action {
    return PockemonActions.add(identifier)
}

public func showPockemonsSheet() -> Action {
    return PockemonActions.showPockemonsSheet(PockemonType.allCases.compactMap { $0.rawValue })
}

public func tappedLocation(point: CGPoint) -> Store<AppState>.ActionCreator  {
    return { state, store in
        guard let identifier = state.pockemonState.lastIdentifier else {
            return PockemonActions.setLocation(point)
        }
        if state.pockemonState.evolutionInfo.keys.contains(identifier) {
            switch state.pockemonState.evolutionInfo[identifier] {
            case .middle?, .top?:
                return PockemonActions.evolve(identifier)
            case .grand?:
                return PockemonActions.remove(identifier)
            default:
                break
            }
        } else {
            return PockemonActions.add(identifier)
        }
        return nil
    }
}
