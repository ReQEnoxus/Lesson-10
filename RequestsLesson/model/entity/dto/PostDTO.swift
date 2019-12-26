//
//  PostDTO.swift
//  RequestsLesson
//
//  Created by Enoxus on 14/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

class PostDTO: Codable {
    
    var id: Int
    var reposted: Bool
    var text: String?
    var likes: Int
    var canLike: Bool
    var comments: Int
    var reposts: Int
    var date: Date
    var repostedText: String?
    var repostedImageLink: String?
    var repostedImage: Data?
    var originalDate: Date?
    var imageLink: String?
    var imageData: Data?
    var owner: String?
    var ownerImageLink: String?
    var ownerImage: Data?
    
    init(id: Int, reposted: Bool, text: String?, likes: Int, canLike: Bool, comments: Int, reposts: Int, date: Date, repostedText: String?, repostedImageLink: String?, repostedImage: Data?, originalDate: Date?, imageLink: String?, imageData: Data?, owner: String?, ownerImageLink: String?, ownerImage: Data?) {
        
        self.id = id
        self.reposted = reposted
        self.text = text
        self.likes = likes
        self.canLike = canLike
        self.comments = comments
        self.reposts = reposts
        self.date = date
        self.repostedText = repostedText
        self.repostedImageLink = repostedImageLink
        self.repostedImage = repostedImage
        self.originalDate = originalDate
        self.imageLink = imageLink
        self.imageData = imageData
        self.owner = owner
        self.ownerImageLink = ownerImageLink
        self.ownerImage = ownerImage
    }
}
