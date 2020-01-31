//
//  ViewController.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 29.01.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func buttonPressed(_ sender: Any) {
        guard let login = loginTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        NetworkManager.shared.getAccessToken(login: login, password: password) { accessTokenModel in
            
            if let accessTokenModel = accessTokenModel {
                let userId = accessTokenModel.user_id
                
                NetworkManager.shared.getProfileInfo(userID: "\(userId)") { (profileInfo) in
                    
                    if let profileInfo = profileInfo {
                        
                        UserDefaultsManager.shared.saveUser(login: login, password: password)
                        
                        DispatchQueue.main.async {
                            
                            self.performSegue(withIdentifier: "AuthorizationSegue", sender: profileInfo)
                        }
                    }
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AuthorizationSegue" {
            let destinationViewController = segue.destination as! UserWallTableViewController
            let profileInfo = sender as! ProfileInfoModel
            destinationViewController.profileInfo = profileInfo
        }
    }
}


