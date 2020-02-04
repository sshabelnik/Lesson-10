//
//  UserWallTableViewController.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 30.01.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import UIKit

class UserWallTableViewController: UITableViewController {

    var profileInfo: ProfileInfoModel!
    
    var posts: [Post] = []
    var profiles: [Profile] = []
    var groups: [Groupe] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCells()
        title = profileInfo.response.first!.first_name
        fetchPosts()
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        
        UserDefaultsManager.shared.removeLastUser()

        let userPageStoryBoard = UIStoryboard(name: "Authorization", bundle: nil)
        let userPageViewController = userPageStoryBoard.instantiateInitialViewController() as! LoginViewController
        
        UIApplication.setRootView(userPageViewController)
            
    }
    
    func setupCells() {
        let profileInfoCellNib = UINib(nibName: "ProfileInfoTableViewCell", bundle: nil)
        tableView.register(profileInfoCellNib, forCellReuseIdentifier: "profileInfoCell")
        
        let postCellNib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(postCellNib, forCellReuseIdentifier: "postCell")
        
    }
    
    func fetchPosts() {
        
        NetworkManager.shared.getUserPostsResponse { userPostsResponse, error in

            if let userPostsResponse = userPostsResponse {
                
                DispatchQueue.main.async {
                    self.posts = userPostsResponse.items
                    if let profiles = userPostsResponse.profiles {
                        self.profiles = profiles
                    }
                    if let groups = userPostsResponse.groups {
                        self.groups = groups
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 1
        } else{
            return posts.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileInfoCell") as! ProfileInfoTableViewCell
            cell.reloadDataDelegate = self
            cell.setupCell(for: profileInfo)
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "postCell") as! PostTableViewCell
            cell.reloadDataDelegate = self
            cell.postCellParentDelegate = self
            cell.setup(for: posts[0])
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            return 200
        } else{
            return 420
        }
    }
}

extension UserWallTableViewController:  ReloadDataDelegate{
    func reloadData() {
        
        tableView.reloadData()
    }
}

extension UserWallTableViewController: PostCellParentDelegate {
    
    func getProfileImageURL(by id: Int) -> String {
        if id > 0 {
            
            if let profile = profiles.first(where: { $0.id == id }) {
                
                let imageURL = profile.photo_100
                return imageURL
                
            } else {
                
                let imageURL = profileInfo.response.first!.photo_200
                return imageURL
            }
            
        } else {
            
            guard let group = groups.first(where: { $0.id == id }) else { fatalError() }
            let imageURL = group.photo_100
            return imageURL
        }
    }
    
    func getUserName(by id: Int) -> String {
        
        if id > 0 {
            
            //Если id принадлежит пользователю
            
            guard let profile = profiles.first(where: { $0.id == id }) else {
                
                //В таком случае автором поста являемся мы сами
                let first_name = profileInfo.response.first!.first_name
                let second_name = profileInfo.response.first!.last_name
                return first_name + " " + second_name
            }
            return profile.first_name
            
        } else {
            
            //Если id принадлежит группе
            
            guard let group = groups.first(where: { $0.id == id }) else {
                return "Error"
            }
            return group.name
        }
    }
}
