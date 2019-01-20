//
//  PockemonReducer.swift
//  ARKitReduxState
//
//  Created by Golos on 1/20/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift

func pockemonReducer(action: Action, state: PockemonState?) -> PockemonState {
    var state = state ?? PockemonState(lastLocation: nil, lastIdentifier: nil, selectedType: nil, pockemonSheetTypes: [], evolutionInfo: [:])
    state.pockemonSheetTypes = []
    
    switch action {
    case let PockemonActions.add(identifier):
        state.evolutionInfo[identifier] = .middle
        state.lastIdentifier = identifier
        
    case let PockemonActions.evolve(identifier):
        state.evolutionInfo[identifier] = state.evolutionInfo[identifier]?.next
        state.lastIdentifier = identifier
        
    case let PockemonActions.remove(identifier):
        state.evolutionInfo.removeValue(forKey: identifier)
        state.lastIdentifier = identifier
        
    case let PockemonActions.showPockemonsSheet(types):
        state.pockemonSheetTypes = types
        
    case let PockemonActions.setSelectedPockemon(name):
        state.selectedType = PockemonType(rawValue: name)
        
    case let PockemonActions.setLocation(point):
        state.lastLocation = point
        
    default:
        break
    }
    return state
}
