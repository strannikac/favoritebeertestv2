//
//  BeersTableViewController.swift
//  FavoriteBeer
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation
import UIKit

class BeersTableViewController: UITableViewController {
    
    var dataController: DataController!
    
    private var beers: [Beer] = []
    private let photosCache = NSCache<NSString, NSData>()
    private let api: APIService = APIService()
    
    private var activityIndicatorHelper: ActivityIndicatorHelper!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCache.countLimit = 100
        
        configureUI()
        
        updateData(checkTime: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUI() {
        title = Constants.Content.allBeers
        self.setNavBarTitleFont()
        
        let refreshItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTap))
        self.navigationItem.rightBarButtonItem = refreshItem
        
        tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: "BeerTableViewCell")
    }
    
    private func updateData(checkTime: Bool = true) {
        activityIndicatorHelper = ActivityIndicatorHelper(forController: self)
        let updater = UpdaterService()
        updater.startUpdate(controllerDelegate: self, checkTime: checkTime)
    }
    
    @objc private func refreshButtonTap() {
        updateData()
    }
    
    private func updateTable() {
        beers = dataController.getBeers()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: Table View Data Source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return beers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BeerTableViewCell", for: indexPath) as! BeerTableViewCell
        
        let beer = beers[indexPath.row]
        cell.setup(with: beer)
        
        cell.favoriteButton.addTarget(self, action: #selector(setFavorite), for: .touchUpInside)
        cell.favoriteButton.tag = indexPath.row
        
        if let url = beer.imageUrl, url != "" {
            let cacheID = NSString(string: "\(beer.id)")
            
            if let cachedData = photosCache.object(forKey: cacheID) {
                let image = UIImage(data: cachedData as Data)
                cell.photoImageView.image = image
            } else {
                api.downloadImage(url: url) { data, error in
                    guard let data = data else {
                        return
                    }
                    
                    self.photosCache.setObject(data as NSData, forKey: cacheID)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = BeerDetailsViewController()
        detailsVC.beer = beers[indexPath.row]
        
        let cacheID = NSString(string: "\(beers[indexPath.row].id)")
        if let cachedData = photosCache.object(forKey: cacheID) {
            detailsVC.imgData = cachedData as Data
        }
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
    @objc private func setFavorite(sender: UIButton) {
        dataController.saveFavorite(beers[sender.tag])
        updateTable()
    }
    
}

//MARK: protocol implementation for updating table view

extension BeersTableViewController: UpdatingTableDelegate {
    func didUpdate(items: [BeerModel]) {
        if items.count > 0 {
            dataController.saveBeers(items: items)
        }
        
        updateTable()
        
        activityIndicatorHelper.remove()
    }
}
