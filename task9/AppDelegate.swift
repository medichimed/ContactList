//
//  AppDelegate.swift
//  task9
//
//  Created by Oksana Kotilevska on 12/30/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
//        if ProcessInfo.processInfo.arguments.contains("-keepScreenOnKey") {
//                UserDefaults.standard.removeObject(forKey: "contactStorage")
//        }
//       UserDefaults.standard.removeObject(forKey: "contactStorage")
        #if DEBUG
        if CommandLine.arguments.contains("enable-testing") {
           UserDefaults.standard.removeObject(forKey: "contactStorage")
        }else if CommandLine.arguments.contains("enable-testingEditPage"){
            UserDefaults.standard.removeObject(forKey: "contactStorage")
            setUserBase()
        }
        #endif

        return true
    }

    func setUserBase(){
           var defaults = UserDefaults.standard.array(forKey: "contactStorage") as? [[String: Any]] ?? []
        defaults.append(["contactId": "first", "firstName": "Hunter Stockton", "secondName": "Thompson", "email": "GenerationOfSwine@mail.ru"])
           defaults.append(["contactId": "second","firstName": "Charles Michael", "secondName": "Palahniuk", "email": "SnuffLullaby@gmail.com"])
           defaults.append(["contactId": "third","firstName": "Joseph", "secondName": "Heller", "email": "catch-22@mail.ru"])
           UserDefaults.standard.set(defaults, forKey: "contactStorage")
       }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

