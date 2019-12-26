//
//  NetworkManagerImpl.swift
//  RequestsLesson
//
//  Created by Enoxus on 14/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation
import WebKit

class NetworkManagerImpl: NetworkManager {
    
    /// shared instance
    static var shared: NetworkManagerImpl = NetworkManagerImpl()
    
    /// current token
    var token: String
    /// offset for pagination
    var currentOffset = 0
    /// limit for pagination
    var currentLimit = 10
    
    private init() {
        token = ""
    }
    
    /// method that retrieves current user
    /// - Parameter completion: block that is called once user is received
    func getCurrentUser(completion: @escaping (UserDTO) -> Void) {
        
        guard let url = URL(string: userEndPoint(token)) else { return }
        
        URLSession.shared.dataTask(with: url) { data, resp, error in
            
            guard let data = data else { return }
            
            if let response = try? JSONDecoder().decode(UserResponse.self, from: data), let user = response.response.first {
                
                DispatchQueue.main.async {
                    completion(user)
                }
            }
            else {
                print("error decoding")
            }
        }.resume()
    }
    
    /// method that requests the next bunch of posts from server
    /// - Parameter completion: block that is called when posts are received
    func getMorePosts(completion: @escaping ([PostDTO]) -> Void) {
        
        guard let url = URL(string: postsEndPoint(offset: currentOffset, limit: currentLimit)) else { return }
        
        URLSession.shared.dataTask(with: url) { [weak self] data, resp, error in
            
            self?.currentOffset = self!.currentLimit
            self?.currentLimit += 10
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            if let response = try? decoder.decode(PostResponse.self, from: data) {
                
                let posts = response.getPosts()
                if posts.isEmpty {
                    self?.currentLimit -= 10
                }
                
                DispatchQueue.main.async {
                    completion(response.getPosts())
                }
            }
        }.resume()
    }
    
    /// method that asynchronously gets the data from given url
    /// - Parameter url: string representation of url
    /// - Parameter completion: block that is called once data is received
    func getImageData(from url: String, completion: @escaping (Data) -> Void) {
                
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
    
    /// method that is responsible for logging user out
    /// - Parameter completion: block that is called when the cookies are gone
    func logout(completion: @escaping () -> Void) {
        
        currentLimit = 10
        currentOffset = 0
        
        let dataStore = WKWebsiteDataStore.default()
        dataStore.fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
        
            dataStore.removeData(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes(), for: records, completionHandler: completion)
        }
    }
    
    /// method that allows to add like to a post
    /// - Parameter post: post to like
    /// - Parameter completion: block that is called when server responds
    func like(post: PostDTO, completion: @escaping (LikeResponse) -> Void) {
        
        guard let url = URL(string: likeEndPoint(id: post.id)) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            guard let resp = try? JSONDecoder().decode(LikeResponse.self, from: data) else { return }
            
            DispatchQueue.main.async {
                
                post.canLike = false
                post.likes = resp.likes
                completion(resp)
            }
        }.resume()
    }
    
    /// method that allows to remove like from post
    /// - Parameter post: post to remove like from
    /// - Parameter completion: block that is called when server responds
    func disLike(post: PostDTO, completion: @escaping (LikeResponse) -> Void) {
        
        guard let url = URL(string: disLikeEndPoint(id: post.id)) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            guard let data = data else { return }
            
            guard let resp = try? JSONDecoder().decode(LikeResponse.self, from: data) else { return }
            
            DispatchQueue.main.async {
                
                post.canLike = true
                post.likes = resp.likes
                completion(resp)
            }
        }.resume()
    }
    
    /// method that returns the endpoint for user object
    /// - Parameter token: auth token
    private func userEndPoint(_ token: String) -> String {
        return "https://api.vk.com/method/users.get?fields=photo_100,online&access_token=\(token)&v=5.103"
    }
    
    /// method that returns the endpoint for the next bunch of posts
    /// - Parameter offset: pagination offset
    /// - Parameter limit: pagination limit
    private func postsEndPoint(offset: Int, limit: Int) -> String {
        return "https://api.vk.com/method/wall.get?count=\(limit)&offset=\(offset)&access_token=\(token)&v=5.103&extended=1"
    }
    
    /// method that returns the endpoint for liking
    /// - Parameter id: id of the post
    private func likeEndPoint(id: Int) -> String {
        return "https://api.vk.com/method/likes.add?type=post&item_id=\(id)&access_token=\(token)&v=5.103"
    }
    
    /// method that returns the endpoint for removing like
    /// - Parameter id: id of the post
    private func disLikeEndPoint(id: Int) -> String {
        return "https://api.vk.com/method/likes.delete?type=post&item_id=\(id)&access_token=\(token)&v=5.103"
    }
}
