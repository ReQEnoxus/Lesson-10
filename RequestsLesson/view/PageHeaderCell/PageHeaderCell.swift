//
//  PageHeaderCell.swift
//  DynamicTable
//
//  Created by Enoxus on 11/10/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class PageHeaderCell: UITableViewCell {

    @IBOutlet weak var aviImageView: UIImageView!
    @IBOutlet weak var nameTextLabel: UILabel!
    @IBOutlet weak var onlineLabel: UILabel!
    
    let online = "online"
    let offline = "offline"
    
    var user: UserDTO!
    
    /// configures the cell with user
    /// - Parameter user: user to configure with
    func configure(with user: UserDTO) {
        
        self.user = user
        
        if let aviData = user.avi {
            aviImageView.image = UIImage(data: aviData)
        }
        else {
            
            NetworkManagerImpl.shared.getImageData(from: user.aviLink) { [weak self] data in
                
                DispatchQueue.main.async {
                    
                    self?.aviImageView.image = UIImage(data: data)
                }
            }
        }
        onlineLabel.text = user.online ? online : offline
        nameTextLabel.text = "\(user.firstName) \(user.lastName)"
    }

    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        aviImageView.layer.cornerRadius = aviImageView.bounds.height / 2
    }
}
