//
//  ViewControllerModel.swift
//  ARKitDemo
//
//  Created by Golos on 1/13/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import Foundation

protocol ViewControllerModel { }

protocol HasError {
    var error: String? { get }
}

protocol ViewControllerModelSupport {
    associatedtype ModelType: ViewControllerModel
    
    var model: ModelType! { get set }
    func render(_ model: ModelType)
}

extension ViewControllerModelSupport {
    func render(_ model: ModelType) {}
}
