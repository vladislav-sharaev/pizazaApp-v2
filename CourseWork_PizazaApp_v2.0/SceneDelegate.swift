//
//  SceneDelegate.swift
//  CourseWork_PizazaApp_v2.0
//
//  Created by Vladislav Sharaev on 9/8/20.
//  Copyright © 2020 Vladislav Sharaev. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        if let topController = window?.visibleViewController() {
            Reachability.showNoneConnectionVC(on: topController)
        }
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

