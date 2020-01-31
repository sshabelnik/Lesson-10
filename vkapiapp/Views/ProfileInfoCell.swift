//
//  ProfileInfoCell.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 30.01.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import UIKit

class ProfileInfoCell: UITableViewCell{

    weak var reloadDataDelegate: ReloadDataDelegate!
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var ageAndCityLabel: UILabel!
    @IBOutlet weak var editButton: UIButton!
    
    func setupCell (for profileInfo: ProfileInfoModel) {
        
        avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2
        editButton.layer.cornerRadius = editButton.frame.height / 2
        
        let profileInfoModel = profileInfo.response.first!
        
        userNameLabel.text = profileInfoModel.first_name + " " + profileInfoModel.last_name
        
        let age = "\(Helper.getAgeFromBirthDate(birthDate: profileInfoModel.bdate))"
        ageAndCityLabel.text = "\(age) лет" + ", " + (profileInfoModel.city?.title ?? "")
        
        let imageURL = profileInfoModel.photo_200
        
        NetworkManager.shared.getImage(by: imageURL) { (image, error) in
            
            if let image = image {
                DispatchQueue.main.async {
                
                    self.avatarImageView.image = image
                    
                    self.reloadDataDelegate.reloadData()
                }
            }
        }
    }
}
