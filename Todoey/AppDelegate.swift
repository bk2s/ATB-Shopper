//
//  AppDelegate.swift
//  deleteMe
//
//  Created by  Stepanok Ivan on 01.08.2021.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      
        
        
        do {
            _ = try Realm()
        } catch {
            print(error)
        }
        
        
        return true
    }
}

