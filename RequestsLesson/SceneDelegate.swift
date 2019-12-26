//
//  SceneDelegate.swift
//  RequestsLesson
//
//  Created by Ильдар Залялов on 13.12.2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var dataManager: DataManager = DataManagerImpl.shared
    var networkManager: NetworkManager = NetworkManagerImpl.shared
    
    let authenticatedControllerId = "authorizedViewController"
    let loginControllerId = "loginViewController"
    
    /// the correct initial viewcontroller is decided inside of this method
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.windowScene = windowScene
        
        dataManager.getCurrentUser() { [weak self] user in
            
            guard let self = self else { return }
            
            if let user = user {
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialVC = storyboard.instantiateViewController(identifier: self.authenticatedControllerId) as! UINavigationController
                
                self.networkManager.token = user.token!
                
                if let wallVC = initialVC.viewControllers.first as? WallViewController {
                    wallVC.configure(with: user)
                }
                                
                self.window?.rootViewController = initialVC
            }
            else {
                
                let initialVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: self.loginControllerId)
                self.window?.rootViewController = initialVC
            }
            
            self.window?.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {

    }

    func sceneDidBecomeActive(_ scene: UIScene) {

    }

    func sceneWillResignActive(_ scene: UIScene) {

    }

    func sceneWillEnterForeground(_ scene: UIScene) {

    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        
    }
}

