//
//  PostTableViewCell.swift
//  vkapiapp
//
//  Created by Сергей Шабельник on 31.01.2020.
//  Copyright © 2020 Сергей Шабельник. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    
    weak var postCellParentDelegate:  PostCellParentDelegate!
    weak var reloadDataDelegate: ReloadDataDelegate!

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextLabel: UILabel!
    
    func setupUI(){
        
        userImageView.layer.cornerRadius = userImageView.frame.height / 2
    }
    
    func setup(for post: Post){
        setupUI()
        setupBasePostInfo(for: post)
    
        if let attachments = post.attachments{
            setupAttachment(for: attachments)
        }
    }
    
    func setupBasePostInfo(for post: Post) {
        
        senderLabel.text = postCellParentDelegate.getUserName(by: post.owner_id)
        dateLabel.text = String(post.date) //Пока что в формате unixtime
        postTextLabel.text = post.text
        
        let imageURL = postCellParentDelegate.getProfileImageURL(by: post.owner_id)
        DispatchQueue.global().async {
            
            NetworkManager.shared.getImage(by: imageURL) { image, error in
                
                if let image = image {
                    
                    DispatchQueue.main.async {
                        self.postImageView.image = image
                    }
                } else {
                    fatalError()
                }
            }
        }
    }
    
    func setupAttachment(for attachments: [Attachments]) {
        
        //В приложении учитываем что прикрепления только картинки
        //И если прикрепленных картинок несколько, то показываем только первую
        
        for attachment in attachments {
            
            if attachment.type == "photo" {
                
                let photo = attachment.photo!
                let photoHeight = photo.sizes.last!.height
                let photoWidth = photo.sizes.last!.width
                
                let compressCoefficient = photoWidth / Int(self.frame.width)
                let newWidth = Int(self.frame.width)
                let newHeight = photoHeight / compressCoefficient
                
                postImageView.sizeThatFits(CGSize(width: newWidth, height: newHeight))
                postImageView.contentMode = .scaleAspectFill
                
                let photoStringURL = photo.sizes.last!.url
                NetworkManager.shared.getImage(by: photoStringURL) { image, error in
                    
                    if let image = image {
                        
                        DispatchQueue.main.async {
                            self.postImageView.image = image
                        }
                    } else {
                        fatalError()
                    }
                }
                break
            }
            return
        }
    }
}
