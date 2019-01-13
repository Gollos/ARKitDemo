//
//  Lens.swift
//  ARKitDemo
//
//  Created by Golos on 1/13/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import Foundation
import ARKitReduxState

protocol Lens {
    associatedtype ResultState
    static func lens(_ state: AppState) -> ResultState
    static func filter(old: ResultState, new: ResultState) -> Bool
}

extension Lens {
    static func filter(old: ResultState, new: ResultState) -> Bool {
        return false
    }
}
