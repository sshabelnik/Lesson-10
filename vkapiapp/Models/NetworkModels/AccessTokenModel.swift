//
//  AccessTokenModel.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 29.01.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import Foundation

struct AccessTokenModel: Codable {
    let access_token: String
    let user_id:  Int
}
