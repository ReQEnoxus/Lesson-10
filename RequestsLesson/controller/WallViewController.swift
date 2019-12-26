//
//  WallViewController.swift
//  DynamicTable
//
//  Created by Enoxus on 11/10/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit

class WallViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    
    var posts = [PostDTO]()
    var user: UserDTO!
    var dataManager: DataManager = DataManagerImpl.shared
    var networkManager: NetworkManager = NetworkManagerImpl.shared
    var loadingMore = false
    
    let staticCellsCount = 1
    let cellSpacingHeight: CGFloat = 10
    let logoutSegueId = "logoutSegue"
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        mainTableView.delegate = self
        mainTableView.dataSource = self
        mainTableView.estimatedRowHeight = UITableView.automaticDimension
        
        mainTableView.register(cell: TextAndImageCell.self)
        
        mainTableView.register(cell: PageHeaderCell.self)
        
        mainTableView.separatorColor = UIColor.clear
        
        navigationItem.setHidesBackButton(true, animated:true)
        
        dataManager.getCachedPosts() { [weak self] posts in
            
            self?.posts = posts
            self?.mainTableView.reloadData()
        }
        
        networkManager.getMorePosts { [weak self] posts in
            
            self?.posts = posts
            self?.dataManager.clearPostsCache() { success in
                
                if success {
                    
                    self?.dataManager.cachePosts(posts: posts)
                }
            }
            
            self?.mainTableView.reloadData()
        }
    }
    
    //MARK: - TableView Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = mainTableView.dequeueReusableCell(withIdentifier: PageHeaderCell.nibName, for: indexPath) as! PageHeaderCell
            
            cell.configure(with: user)
                        
            return cell
        }
        else {

            let cell = mainTableView.dequeueReusableCell(withIdentifier: TextAndImageCell.nibName, for: indexPath) as! TextAndImageCell
                
            cell.configure(with: posts[indexPath.section - 1], user: user) { [weak self] in
                
                UIView.performWithoutAnimation {

                    self?.mainTableView.beginUpdates()
                    self?.mainTableView.endUpdates()
                }
            }
            
            return cell
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return staticCellsCount + posts.count
    }
    
    /// configures the view with user
    /// - Parameter user: user to configure with
    func configure(with user: UserDTO) {
        self.user = user
    }
    
    /// method that is called when exit button is tapped
    /// - Parameter sender: sender of the event
    @IBAction func exitButtonPressed(_ sender: Any) {
        
        networkManager.logout() { [weak self] in
            
            guard let self = self else { return }
            
            self.dataManager.clearAllCache() { success in
                
                self.performSegue(withIdentifier: self.logoutSegueId, sender: nil)
            }
        }
    }
    
    /// method that intercepts the moment when the bottom of tableview is reached and asks for a new bunch of posts from network manager
    /// - Parameter scrollView: scrollview of tableview
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        if mainTableView.contentOffset.y >= mainTableView.contentSize.height - mainTableView.frame.size.height, !loadingMore {
            
            loadingMore = true
            networkManager.getMorePosts() { [weak self] posts in

                if !posts.isEmpty {

                    self?.posts += posts
                    self?.mainTableView.reloadData()
                    self?.loadingMore = false
                }
            }
        }
    }
}
