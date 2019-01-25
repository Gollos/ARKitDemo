//
//  PockemonReducer.swift
//  ARKitReduxState
//
//  Created by Golos on 1/20/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift

func pockemonReducer(action: Action, state: PockemonState?) -> PockemonState {
    var state = state ?? PockemonState(lastLocation: nil,
                                       lastIdentififer: nil,
                                       selectedType: nil,
                                       pockemonSheetTypes: [],
                                       evolutionInfo: [:])
    state.pockemonSheetTypes = []
    
    switch action {
    case let PockemonActions.add(point, identifier):
        state.lastLocation = point
        state.lastIdentififer = identifier
        
        guard let identifier = identifier else { return state }
        state.evolutionInfo[identifier] = .middle

    case let PockemonActions.evolve(identifier):
        state.evolutionInfo[identifier] = state.evolutionInfo[identifier]?.next
        state.lastIdentififer = identifier
        
    case let PockemonActions.remove(identifier):
        state.evolutionInfo.removeValue(forKey: identifier)
        state.lastIdentififer = identifier
        
    case let PockemonActions.showPockemonsSheet(types):
        state.pockemonSheetTypes = types
        
    case let PockemonActions.setSelectedPockemon(name):
        state.selectedType = PockemonType(rawValue: name)
        
    default:
        break
    }
    return state
}
