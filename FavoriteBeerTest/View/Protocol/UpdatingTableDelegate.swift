//
//  UpdatingTableDelegate.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import UIKit

//MARK: protocol for updating data in view controller

protocol UpdatingTableDelegate: UITableViewController {
    func didUpdate(items: [BeerModel])
}
