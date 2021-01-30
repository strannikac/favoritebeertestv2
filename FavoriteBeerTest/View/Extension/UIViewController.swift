//
//  UIViewController.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 25.01.2021.
//

import UIKit

extension UIViewController {
    func setNavBarTitleFont() {
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.font: UIFont(name: "Chalkduster", size: 20)!,
             NSAttributedString.Key.foregroundColor: UIColor.black]
    }
}
