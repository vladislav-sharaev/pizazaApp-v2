//
//  AppDelegate.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/8/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import GoogleMaps
import GooglePlaces


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GMSServices.provideAPIKey("AIzaSyB1r0hYgEl2OTSdhXIF0TwBaOcbrEFIV1k")
        GMSPlacesClient.provideAPIKey("AIzaSyB1r0hYgEl2OTSdhXIF0TwBaOcbrEFIV1k")
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any])
      -> Bool {
      return GIDSignIn.sharedInstance().handle(url)
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

