//
//  UIColor.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 06.03.2021.
//

import UIKit

extension UIColor {
    static func rgba(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
