//
//  PostResponse.swift
//  RequestsLesson
//
//  Created by Enoxus on 15/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

// MARK: - PostResponse
/// class that represents server response. All of the rest classes are used for convenient decoding
class PostResponse: Codable {
    
    let response: Response

    init(response: Response) {
        self.response = response
    }
    
    func getPosts() -> [PostDTO] {
        
        var posts = [PostDTO]()
        
        for item in response.items {
            
            let id = item.id
            let reposted = item.copyHistory != nil
            let text = item.text
            let likes = item.likes.count
            let canLike = item.likes.canLike == 1
            let comments = item.comments.count
            let reposts = item.reposts.count
            let date = Date(timeIntervalSince1970: TimeInterval(exactly: item.date)!)
            
            var imageLink: String?
            var originalDate: Date?
            var owner: String?
            var ownerImageLink: String?
            
            var repostedText: String?
            var repostedImageLink: String?
            
            if let imageUrl = item.attachments?.first?.photo.sizes.last?.url {
                imageLink = imageUrl
            }
                        
            if reposted {
                
                if let repostedImageUrl = item.copyHistory?.first?.attachments?.first?.photo.sizes.last?.url {
                    
                    repostedImageLink = repostedImageUrl
                }
                
                if let repostedTextString = item.copyHistory?.first?.text {
                    
                    repostedText = repostedTextString
                }
                
                if let intOriginalDate = item.copyHistory?.first?.date {
                    originalDate = Date(timeIntervalSince1970: TimeInterval(exactly: intOriginalDate)!)
                }
                
                if let ownerId = item.copyHistory?.first?.ownerId {
                    if let group = response.groups.filter({ $0.id == abs(ownerId) }).first {
                        
                        owner = group.name
                        ownerImageLink = group.aviLink
                    }
                    else if let profile = response.profiles.filter({ $0.id == ownerId }).first {
                        
                        owner = "\(profile.firstName) \(profile.lastName)"
                        ownerImageLink = profile.aviLink
                    }
                }
            }
            
            let post = PostDTO(id: id, reposted: reposted, text: text, likes: likes, canLike: canLike, comments: comments, reposts: reposts, date: date, repostedText: repostedText, repostedImageLink: repostedImageLink, repostedImage: nil, originalDate: originalDate, imageLink: imageLink, imageData: nil, owner: owner, ownerImageLink: ownerImageLink, ownerImage: nil)
            
            posts.append(post)
        }
        
        return posts
    }
}

// MARK: - Response
class Response: Codable {
    
    let count: Int
    let items: [Item]
    let profiles: [Profile]
    let groups: [Group]

    init(count: Int, items: [Item], profiles: [Profile], groups: [Group]) {
        
        self.count = count
        self.items = items
        self.profiles = profiles
        self.groups = groups
    }
}

//MARK: - Group
class Group: Codable {
    
    let id: Int
    let name: String
    let aviLink: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case aviLink = "photo100"
    }

    init(id: Int, name: String, aviLink: String) {
        
        self.id = id
        self.name = name
        self.aviLink = aviLink
    }
}

//MARK: - Item
class Item: Codable {
    
    let id, date: Int
    let text: String
    let attachments: [Attachment]?
    let copyHistory: [CopyHistory]?
    let comments: Comments
    let likes: Likes
    let reposts: Reposts
    let views: Views?

    enum CodingKeys: String, CodingKey {
        case id
        case date
        case text
        case attachments
        case copyHistory
        case comments, likes, reposts, views
    }
    
    init(id: Int, date: Int, text: String, attachments: [Attachment], copyHistory: [CopyHistory], comments: Comments, likes: Likes, reposts: Reposts, views: Views?) {
        
        self.id = id
        self.date = date
        self.text = text
        self.attachments = attachments
        self.copyHistory = copyHistory
        self.comments = comments
        self.likes = likes
        self.reposts = reposts
        self.views = views
    }
}

//MARK: - Attachment
class Attachment: Codable {
    
    let type: String
    let photo: Photo

    init(type: String, photo: Photo) {
        self.type = type
        self.photo = photo
    }
}

//MARK: - Photo
class Photo: Codable {
    
    let id: Int
    let sizes: [Size]
    let text: String
    let date: Int

    enum CodingKeys: String, CodingKey {
        case id
        case sizes, text, date
    }

    init(id: Int, sizes: [Size], text: String, date: Int) {
        self.id = id
        self.sizes = sizes
        self.text = text
        self.date = date
    }
}

//MARK: - Sizse
class Size: Codable {
    
    let url: String
    
    init(url: String) {
        self.url = url
    }
}

//MARK: - Comments
class Comments: Codable {
    
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }

    init(count: Int) {
        self.count = count
    }
}

//MARK: - CopyHistory
class CopyHistory: Codable {
    
    let id, ownerId, fromId, date: Int?
    let text: String?
    let attachments: [Attachment]?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case ownerId
        case fromId
        case date
        case text, attachments
    }

    init(id: Int, ownerId: Int, fromId: Int, date: Int, text: String, attachments: [Attachment]) {
        
        self.id = id
        self.ownerId = ownerId
        self.fromId = fromId
        self.date = date
        self.text = text
        self.attachments = attachments
    }
}

//MARK: - Likes
class Likes: Codable {
    
    let count, canLike: Int

    enum CodingKeys: String, CodingKey {
        
        case count
        case canLike
    }

    init(count: Int, canLike: Int) {
        
        self.count = count
        self.canLike = canLike
    }
}

// MARK: - Reposts
class Reposts: Codable {
    
    let count: Int

    enum CodingKeys: String, CodingKey {
        case count
    }

    init(count: Int) {
        self.count = count
    }
}

// MARK: - Views
class Views: Codable {
    
    let count: Int

    init(count: Int) {
        self.count = count
    }
}

// MARK: - Profile
class Profile: Codable {
    
    let id: Int
    let firstName, lastName: String
    let aviLink: String

    enum CodingKeys: String, CodingKey {
        
        case id
        case firstName
        case lastName
        case aviLink = "photo100"
    }

    
    init(id: Int, firstName: String, lastName: String, aviLink: String) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.aviLink = aviLink
    }
}
