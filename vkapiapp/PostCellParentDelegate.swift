//
//  PostCellParentDelegate.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 01.02.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import Foundation

protocol PostCellParentDelegate: AnyObject {
    
    //Сделал так, потому что при запросе постов со стены пользователя у каждого поста указаны только ID
    //Но в UserPosts.Response.Profiles или .Groups есть вся инфа о всех пользователях / группах упоминающихся на стене
    
    ///Получение имени пользователя по ID из UserPosts.Response.Profiles или UserPosts.Response.Groups
    func getUserName(by id: Int) -> String
    
    ///Получение картинки по ID из UserPosts.Response.Profiles или UserPosts.Response.Groups
    func getProfileImageURL(by id: Int) -> String
}
