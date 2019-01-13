//
//  PockemonLens.swift
//  ARKitDemo
//
//  Created by Golos on 1/13/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import Foundation
import ARKitReduxState

struct PockemonLens: Lens {
    static func lens(_ state: AppState) -> (pockemonType: PockemonType?, error: String?) {
        return (state.pockemonState.pockemonType, state.errorState.generalErrorMessage)
    }
    
    static func filter(old: (pockemonType: PockemonType?, error: String?), new: (pockemonType: PockemonType?, error: String?)) -> Bool {
        return old.pockemonType == new.pockemonType && new.error == nil
    }
}
