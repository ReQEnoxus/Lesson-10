//
//  TextAndImageCell.swift
//  DynamicTable
//
//  Created by Enoxus on 11/10/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class TextAndImageCell: UITableViewCell {
    
    @IBOutlet weak var repostInfoView: UIView!
    @IBOutlet weak var repostInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var repostedTextLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var postAuthorNameLabel: UILabel!
    @IBOutlet weak var repostedImageView: UIImageView!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var repostsLabel: UILabel!
    @IBOutlet weak var originalOwnerLabel: UILabel!
    @IBOutlet weak var originalDateLabel: UILabel!
    @IBOutlet weak var originalOwnerImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    /// network manager instance
    private var networkManager = NetworkManagerImpl.shared
    /// date helper instance
    private var dateHelper = DateHelper.shared
    
    let likedImage = "heart.fill"
    let notLikedImage = "heart"
    
    var post: PostDTO!
    
    /// block that is called when the image is retrieved to resize it properly
    var reloadBlock: (() -> Void)?
    
    /// configures the cell with post model
    /// - Parameter post: post itself
    /// - Parameter user: author of the post
    /// - Parameter reloadClosure: closure that is called to properly resize the image
    func configure(with post: PostDTO, user: UserDTO, reloadClosure: (() -> Void)?) {
                
        self.post = post
        
        reloadBlock = reloadClosure
        
        if !post.canLike {
            likeButton.setBackgroundImage(UIImage(systemName: likedImage), for: .normal)
        }
        else {
            likeButton.setBackgroundImage(UIImage(systemName: notLikedImage), for: .normal)
        }
        
        if let userImageData = user.avi {
            avatarImageView.image = UIImage(data: userImageData)
        }
        else {
            
            networkManager.getImageData(from: user.aviLink) { [weak self] data in
                
                DispatchQueue.main.async {
                    
                    self?.avatarImageView.image = UIImage(data: data)
                    user.avi = data
                }
            }
        }
        
        postAuthorNameLabel.text = "\(user.firstName) \(user.lastName)"
        
        dateLabel.text = dateHelper.formatDate(post.date)
        
        if let postText = post.text, !postText.isEmpty {
            
            postTextLabel.isHidden = false
            postTextLabel.text = postText
        }
        else {
            postTextLabel.isHidden = true
        }
        
        if let postImageData = post.imageData {
            
            postImageView.isHidden = false
            postImageView.image = UIImage(data: postImageData)
        }
        else if let postImageLink = post.imageLink {
            
            postImageView.isHidden = false
            networkManager.getImageData(from: postImageLink) { [weak self] data in
                
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                    post.imageData = data
                    self?.ensurePictureRatio()
                }
            }
        }
        else {
            
            postImageView.isHidden = true
        }
        
        likesLabel.text = String(post.likes)
        commentsLabel.text = String(post.comments)
        repostsLabel.text = String(post.reposts)
        
        if post.reposted {
            
            repostInfoView.isHidden = false
            
            if let originalDate = post.originalDate {
                originalDateLabel.text = dateHelper.formatDate(originalDate)
            }
            
            if let ownerImageData = post.ownerImage {
                originalOwnerImageView.image = UIImage(data: ownerImageData)
            }
            else {
                
                networkManager.getImageData(from: post.ownerImageLink!) { [weak self] data in
                    
                    DispatchQueue.main.async {
                        
                        self?.originalOwnerImageView.image = UIImage(data: data)
                        post.ownerImage = data
                    }
                }
            }
            
            originalOwnerLabel.text = post.owner!
            
            if let repostedText = post.repostedText, !repostedText.isEmpty {
                
                repostedTextLabel.isHidden = false
                repostedTextLabel.text = repostedText
            }
            else {
                repostedTextLabel.isHidden = true
            }
            
            if let repostedImage = post.repostedImage {
                
                repostedImageView.isHidden = false
                repostedImageView.image = UIImage(data: repostedImage)
            }
            else if let repostedImageLink = post.repostedImageLink {
                
                repostedImageView.isHidden = false
                networkManager.getImageData(from: repostedImageLink) { [weak self] data in
                    
                    DispatchQueue.main.async {
                        
                        self?.repostedImageView.image = UIImage(data: data)
                        post.repostedImage = data
                        self?.ensurePictureRatio()
                    }
                }
            }
            else {
                repostedImageView.isHidden = true
            }
        }
        else {
            
            repostedImageView.isHidden = true
            repostedTextLabel.isHidden = true
            repostInfoView.isHidden = true
        }
    }
    
    func ensurePictureRatio() {
        
        if let _ = postImageView.image, post.imageLink != nil {

            if let reloadClosure = reloadBlock {
                reloadClosure()
            }
        }
        
        if let _ = repostedImageView.image, post.repostedImageLink != nil {
            
            if let reloadClosure = reloadBlock {
                reloadClosure()
            }
        }
    }
    
    override func prepareForReuse() {
        
        super.prepareForReuse()

        postImageView.image = nil
        repostedImageView.image = nil
        
        postImageView.isHidden = false
        postTextLabel.isHidden = false
        repostedTextLabel.isHidden = false
        repostInfoView.isHidden = false
        repostedImageView.isHidden = false
        postImageView.isHidden = false
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.height / 2
        originalOwnerImageView.layer.cornerRadius = originalOwnerImageView.bounds.height / 2
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
        
        if post.canLike {
            
            networkManager.like(post: post) { [weak self] response in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    
                    self.likesLabel.text = String(response.likes)
                    self.likeButton.setBackgroundImage(UIImage(systemName: self.likedImage), for: .normal)
                }
            }
        }
        else {
            
            networkManager.disLike(post: post) { [weak self] response in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    
                    self.likesLabel.text = String(response.likes)
                    self.likeButton.setBackgroundImage(UIImage(systemName: self.notLikedImage), for: .normal)
                }
            }
        }
    }
}
