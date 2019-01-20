//
//  AppDelegate.swift
//  ARKitDemo
//
//  Created by Golos on 1/12/19.
//  Copyright © 2019 ITC. All rights reserved.
//

import UIKit
import ARKitReduxState
import ReSwift

var mainStore: Store<AppState>! {
    return (UIApplication.shared.delegate as? AppDelegate)?.store
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    fileprivate var store: Store<AppState>!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        store = createStore()
        
        window = UIWindow()
        window?.rootViewController = ARViewController()
        window?.makeKeyAndVisible()
        
        return true
    }
}
