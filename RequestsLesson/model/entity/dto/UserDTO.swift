//
//  UserDTO.swift
//  RequestsLesson
//
//  Created by Enoxus on 14/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

class UserDTO: Codable {
    
    var id: Int
    var firstName: String
    var lastName: String
    var online: Bool
    var avi: Data?
    var aviLink: String
    var token: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case online
        case aviLink = "photo_100"
    }
    
    required init(from decoder: Decoder) throws {
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        id = try values.decode(Int.self, forKey: .id)
        firstName = try values.decode(String.self, forKey: .firstName)
        lastName = try values.decode(String.self, forKey: .lastName)
        
        let online = try values.decode(Int.self, forKey: .online)
        self.online = online == 0 ? false : true
        
        let aviLink = try values.decode(String.self, forKey: .aviLink)
        self.aviLink = aviLink
        
    }
    
    init(id: Int, firstName: String, lastName: String, online: Bool, avi: Data?, aviLink: String, token: String?) {
        
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.online = online
        self.avi = avi
        self.aviLink = aviLink
        self.token = token
    }
}

