//
//  PockemonState.swift
//  ARKitReduxState
//
//  Created by Golos on 1/20/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import ReSwift

public enum PockemonType: String, CaseIterable {
    case bulbasaur = "Bulbasaur"
    case squirtle = "Squirtle"
}

public enum PockemonEvolution: Int {
    case none
    case middle
    case top
    case grand
    
    var next: PockemonEvolution {
        return PockemonEvolution(rawValue: rawValue + 1) ?? .none
    }
}

public struct PockemonState: StateType {
    public var lastLocation: CGPoint?
    public var lastIdentifier: String?
    public var selectedType: PockemonType?
    public var pockemonSheetTypes: [String]
    public var evolutionInfo: [String: PockemonEvolution]
}
