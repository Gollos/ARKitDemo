//
//  SCNVector3+Identifier.swift
//  ARKitDemo
//
//  Created by Golos on 1/20/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import SceneKit

extension SCNVector3 {
    var identifier: String {
        return "\(x)\(y)\(z)"
    }
}
