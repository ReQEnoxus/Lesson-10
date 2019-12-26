//
//  LikeResponse.swift
//  RequestsLesson
//
//  Created by Enoxus on 26/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

struct LikeResponse: Decodable {
    
    let likes: Int
    
    enum CodingKeys: String, CodingKey {
        
        case response
    }
    
    enum LikeCodingKeys: String, CodingKey {
        
        case likes
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let likesContainer = try container.nestedContainer(keyedBy: LikeCodingKeys.self, forKey: .response)
        
        likes = try likesContainer.decode(Int.self, forKey: .likes)
    }
}
