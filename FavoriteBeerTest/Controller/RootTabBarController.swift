//
//  RootTabBarController.swift
//  FavoriteBeer
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import UIKit

class RootTabBarController: UITabBarController {
    
    private let dataController = DataController(modelName: "Beer")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let beersNavVC = UINavigationController(rootViewController: BeersTableViewController())
        let favoritesNavVC = UINavigationController(rootViewController: FavoritesViewController())
        
        let beersTabBarItem = UITabBarItem(title: StringConstants.allBeers.rawValue, image: UIImage(systemName: "list.bullet"), tag: 0)
        beersNavVC.tabBarItem = beersTabBarItem
        let beersVC = beersNavVC.viewControllers.first as! BeersTableViewController
        beersVC.dataController = dataController
        
        let favoritesTabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        favoritesNavVC.tabBarItem = favoritesTabBarItem
        let favoritesVC = favoritesNavVC.viewControllers.first as! FavoritesViewController
        favoritesVC.dataController = dataController

        viewControllers = [beersNavVC, favoritesNavVC]
    }

}
