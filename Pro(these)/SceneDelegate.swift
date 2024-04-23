//
//  SceneDelegate.swift
//  Pro-these-
//
//  Created by Frederik Kohler on 16.10.23.
//

import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Optional: Custom initialization when the scene connects
        guard let _ = (scene as? UIWindowScene) else { return }
    
        for activity in connectionOptions.userActivities {
            self.scene(scene, continue: activity)
        }
    }
    
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
       guard userActivity.interaction?.intent is StartProthesenTimerIntent else { return }
       #if DEBUG
       print("Siri Intent user info: \(String(describing: userActivity.userInfo))")
       #endif
   }
}
