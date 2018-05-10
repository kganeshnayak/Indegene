//
//  AppDelegate.swift
//  iDocs
//
//  Created by IOS Developer on 08/05/18.
//  Copyright © 2018 IOS Developer. All rights reserved.
//

import UIKit
import CoreData

typealias ServiceResponse = (Any?) -> Void

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var backgroundCompletionHandler: (() -> Void)? = nil


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        backgroundCompletionHandler = completionHandler
    }
}

