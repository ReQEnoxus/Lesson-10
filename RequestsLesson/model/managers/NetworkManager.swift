//
//  NetworkManager.swift
//  RequestsLesson
//
//  Created by Enoxus on 14/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation

protocol NetworkManager {
    
    func getCurrentUser(completion: @escaping (UserDTO) -> Void)
    func getMorePosts(completion: @escaping ([PostDTO]) -> Void)
    func getImageData(from url: String, completion: @escaping (Data) -> Void)
    func like(post: PostDTO, completion: @escaping (LikeResponse) -> Void)
    func disLike(post: PostDTO, completion: @escaping (LikeResponse) -> Void)
    func logout(completion: @escaping () -> Void)
    var token: String { get set }
}
