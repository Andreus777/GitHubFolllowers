//
//  GFTabBarController.swift
//  GitHubFolllowers
//
//  Created by Андрей Фокин on 15.08.22.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNC(), createFavoriteNC()]
        
    }
    func createSearchNC() -> UINavigationController {
        let searchVC = SearchVC()
        searchVC.title = "Search"
        searchVC.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        return UINavigationController(rootViewController: searchVC)
    }
    func createFavoriteNC() -> UINavigationController {
        let favoriresVC = FavoritesVC()
        favoriresVC.title = "Favorites"
        favoriresVC.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        return UINavigationController(rootViewController: favoriresVC)
    }
   
}
