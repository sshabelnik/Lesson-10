//
//  SceneDelegate.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 29.01.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        if let lastUserData = UserDefaultsManager.shared.getLastUser() {
            
            let login = lastUserData.0
            let password = lastUserData.1
            NetworkManager.shared.getAccessToken(login: login, password: password) { authResponseModel in
                
                if let authResponseModel = authResponseModel {
                    
                    let userID = String(authResponseModel.user_id)
                    NetworkManager.shared.getProfileInfo(userID: userID) { profileInfo in
                        
                        if let profileInfo = profileInfo {
                            
                            DispatchQueue.main.async {
                                
                                let userPageStoryBoard = UIStoryboard(name: "UserWall", bundle: nil)
                                let navController = userPageStoryBoard.instantiateInitialViewController() as! UINavigationController
                                let userPageVC = navController.viewControllers.first! as! UserWallTableViewController
                                userPageVC.profileInfo = profileInfo
                                
                                UIApplication.setRootView(navController)
                            }
                        }
                    }
                }
            }
        } else{
            
            let loginStoryboard = UIStoryboard(name: "Authorization", bundle: nil)
            let authorizationVC = loginStoryboard.instantiateInitialViewController() as! LoginViewController
            
            window?.rootViewController = authorizationVC
        }
    }
}

