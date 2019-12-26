//
//  DataManager.swift
//  RequestsLesson
//
//  Created by Enoxus on 20/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

protocol DataManager {
    
    func getCurrentUser(completion: @escaping (UserDTO?) -> Void)
    func getCachedPosts(completion: @escaping ([PostDTO]) -> Void)
    func saveCurrentUser(user: UserDTO, token: String)
    func cachePosts(posts: [PostDTO])
    func clearPostsCache(completion: @escaping (Bool) -> Void)
    func clearAllCache(completion: @escaping (Bool) -> Void)
}
