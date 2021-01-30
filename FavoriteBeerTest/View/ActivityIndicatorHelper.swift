//
//  ActivityIndicatorHelper.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation
import UIKit

class ActivityIndicatorHelper {
    private var activityIndicatorView: UIActivityIndicatorView = UIActivityIndicatorView()
    
    private weak var controller: UITableViewController!
    
    init(forController controller: UITableViewController) {
        self.controller = controller
        create()
    }
    
    func create() {
        DispatchQueue.main.async {
            let indicator: UIActivityIndicatorView = UIActivityIndicatorView()
            self.controller.view.addSubview(indicator)
            
            indicator.backgroundColor = UIColor.white.withAlphaComponent(0.8)
            indicator.color = .red
            indicator.style = .large
            
            indicator.translatesAutoresizingMaskIntoConstraints = false
            
            let w = self.controller.view.bounds.size.width
            let h = self.controller.view.bounds.size.height
            
            indicator.widthAnchor.constraint(equalToConstant: w).isActive = true
            indicator.heightAnchor.constraint(equalToConstant: h).isActive = true
            
            let topOffset = self.controller.tableView.contentOffset.y
            indicator.topAnchor.constraint(equalTo: self.controller.tableView.topAnchor, constant: topOffset).isActive = true
            
            indicator.hidesWhenStopped = true
            indicator.center = self.controller.view.center
            
            self.activityIndicatorView = indicator
        }
        
        self.set(true)
    }
    
    func set(_ isShow: Bool) {
        DispatchQueue.main.async {
            self.activityIndicatorView.isHidden = !isShow
            self.controller.view.isUserInteractionEnabled = !isShow
            
            isShow ? self.activityIndicatorView.startAnimating() : self.activityIndicatorView.stopAnimating()
        }
    }
    
    func remove() {
        set(false)
        
        DispatchQueue.main.async {
            self.activityIndicatorView.removeFromSuperview()
        }
    }
}

