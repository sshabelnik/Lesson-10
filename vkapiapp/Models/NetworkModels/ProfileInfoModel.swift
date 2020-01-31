//
//  ProfileInfoModel.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 30.01.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import Foundation

struct ProfileInfoModel: Codable {
    
    var response: [ProfileInfoResponse]
}

struct ProfileInfoResponse: Codable {
    
    var id: Int
    var photo_200: String
    var first_name: String
    var last_name: String
    var sex: Int
    var bdate: String
    var online: Int
    var city: City?
}

struct Country: Codable {
    
    var id: Int
    var title: String
}

struct City: Codable {
    
    var id: Int
    var title: String
}
