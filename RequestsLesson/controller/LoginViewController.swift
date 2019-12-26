//
//  LoginViewController.swift
//  RequestsLesson
//
//  Created by Enoxus on 14/12/2019.
//  Copyright © 2019 Ildar Zalyalov. All rights reserved.
//

import UIKit
import WebKit

class LoginViewController: UIViewController, WKNavigationDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    /// data manager instance
    var dataManager: DataManager = DataManagerImpl.shared
    
    /// default auth url
    let authUrl = "https://oauth.vk.com/authorize?client_id=7246710&display=page&redirect_uri=oauth.vk.com/blank.html&response_type=token&scope=73728"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.frame = .zero
        
        navigationItem.setHidesBackButton(true, animated:true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        webView.alpha = 1
        let vkUrl = URL(string: authUrl)
        
        if let url = vkUrl {
            webView.load(URLRequest(url: url))
        }
    }
    
    //MARK: - WKNavigationDelegate
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
        if let urlString = webView.url?.absoluteString.replacingOccurrences(of: "#", with: "?"), let urlParams = URL(string: urlString)?.queryParameters, let token = urlParams["access_token"] {
            
            webView.alpha = 0
            
            NetworkManagerImpl.shared.token = token
            
            NetworkManagerImpl.shared.getCurrentUser { [weak self] user in
                
                self?.dataManager.saveCurrentUser(user: user, token: token)
                self?.performSegue(withIdentifier: "wallSegue", sender: user)
            }
        }
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "wallSegue", let user = sender as? UserDTO {
            
            let destVC = segue.destination as! WallViewController
            destVC.configure(with: user)
        }
    }
}
