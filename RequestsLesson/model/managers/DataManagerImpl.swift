//
//  DataManagerImpl.swift
//  RequestsLesson
//
//  Created by Enoxus on 20/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import Foundation
import CoreData

class DataManagerImpl: DataManager {
       
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "RequestsLesson")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {

                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    
    private init() {
        
    }
    
    /// shared instance
    static let shared: DataManager = DataManagerImpl()
    
    /// method that retrieves the current user from core data cache
    /// - Parameter completion: block that is called when user is retrieved
    func getCurrentUser(completion: @escaping (UserDTO?) -> Void) {
        
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: false)]
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            if let user = try? self?.persistentContainer.viewContext.fetch(fetchRequest).first {
                
                DispatchQueue.main.async {
                    completion(user.toDto())
                }
            }
            else {
                
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        
    }
    
    /// method that fetches first 10 posts from core data cache
    /// - Parameter completion: block that is called when posts are retreived
    func getCachedPosts(completion: @escaping ([PostDTO]) -> Void) {
        
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            
            if let posts = try? self?.persistentContainer.viewContext.fetch(fetchRequest), !posts.isEmpty {
                
                DispatchQueue.main.async {
                    completion(posts.map({ $0.toDto() }))
                }
            }
            else {
                
                DispatchQueue.main.async {
                    completion([])
                }
            }
        }
    }
    
    /// method that caches given posts to core data storage
    /// - Parameter posts: posts to cache
    func cachePosts(posts: [PostDTO]) {
        
        DispatchQueue.global(qos: .utility).async { [weak self] in
            
            guard let self = self else { return }
            
            for post in posts {
                
                let postModel = Post(context: self.persistentContainer.viewContext)
                postModel.id = Int64(post.id)
                postModel.reposted = post.reposted
                postModel.text = post.text
                postModel.likes = Int16(post.likes)
                postModel.canLike = post.canLike
                postModel.comments = Int16(post.comments)
                postModel.reposts = Int16(post.reposts)
                postModel.date = post.date
                postModel.repostedText = post.repostedText
                postModel.repostedImageLink = post.repostedImageLink
                
                if post.repostedImage == nil, let link = post.repostedImageLink, let url = URL(string: link), let data = try? Data(contentsOf: url) {
                    postModel.repostedImage = data
                }
                
                postModel.originalDate = post.originalDate
                postModel.imageLink = post.imageLink
                
                if post.imageData == nil, let link = post.imageLink, let url = URL(string: link), let data = try? Data(contentsOf: url) {
                    postModel.imageData = data
                }
                
                postModel.owner = post.owner
                postModel.ownerImageLink = post.ownerImageLink
                
                if post.ownerImage == nil, let link = post.ownerImageLink, let url = URL(string: link), let data = try? Data(contentsOf: url) {
                    postModel.ownerImage = data
                }
            }
            
            self.saveContext()
        }
    }
    
    /// method that purges all available cache
    /// - Parameter completion: block that is called when the cache is cleared (parameter indicates if the purge was successful)
    func clearAllCache(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let self = self else { return }
            
            let userDeleteRequest = NSBatchDeleteRequest(fetchRequest: User.fetchRequest())
            let postsDeleteRequest = NSBatchDeleteRequest(fetchRequest: Post.fetchRequest())
            
            do {
                
                try self.persistentContainer.viewContext.execute(userDeleteRequest)
                try self.persistentContainer.viewContext.execute(postsDeleteRequest)
                
                self.saveContext()
                
                DispatchQueue.main.async {
                    
                    completion(true)
                }
            }
            catch {
                
                print("Failed to clear cache")
                completion(false)
            }
        }
    }
    
    /// method that purges only cached posts
    /// - Parameter completion: block that is called when the cache is cleared (parameter indicates if the purge was successful)
    func clearPostsCache(completion: @escaping (Bool) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let self = self else { return }

            let postsDeleteRequest = NSBatchDeleteRequest(fetchRequest: Post.fetchRequest())
            
            do {
                
                try self.persistentContainer.viewContext.execute(postsDeleteRequest)
                
                self.saveContext()
                
                DispatchQueue.main.async {
                    
                    completion(true)
                }
            }
            catch {
                
                print("Failed to clear cache")
                completion(false)
            }
        }
    }
    
    /// method that caches current user and his token to core data storage
    /// - Parameter user: user to cache
    /// - Parameter token: token to cache
    func saveCurrentUser(user: UserDTO, token: String) {
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            
            guard let self = self else { return }
            
            let userModel = User(context: self.persistentContainer.viewContext)
            
            userModel.id = Int64(user.id)
            userModel.firstName = user.firstName
            userModel.lastName = user.lastName
            userModel.online = user.online
            
            if user.avi == nil, let url = URL(string: user.aviLink), let data = try? Data(contentsOf: url) {
                
                userModel.avi = data
            }
            
            userModel.aviLink = user.aviLink
            userModel.token = token
            
            self.saveContext()
        }
    }
}
