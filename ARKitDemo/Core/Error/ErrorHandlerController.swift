//
//  ErrorHandlerController.swift
//  ARKitDemo
//
//  Created by Golos on 1/13/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import UIKit

protocol ErrorHandlerController {
    func show(error: String?)
}

extension ErrorHandlerController where Self: UIViewController {
    func show(error: String?) {
        guard let error = error else { return }
        
        let alertController = UIAlertController(title: error, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
