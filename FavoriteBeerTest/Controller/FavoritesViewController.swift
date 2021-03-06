//
//  FavoritesViewController.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
    
    var dataController: DataController!
    
    let tableView = UITableView()
    var safeArea: UILayoutGuide!
    
    private let photosCache = NSCache<NSString, NSData>()
    private let api: APIService = APIService()
    
    private var sortBy = 0
    private var isSortDesc = true
    
    private let sortTypes: [String] = [
        Constants.Content.name,
        Constants.Content.alcohol,
        Constants.Content.ebc,
        Constants.Content.ibu
    ]
    
    private let sortStackView = UIStackView()
    private var sortButtons: [UIButton] = []
    
    private var favorites: [Beer] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosCache.countLimit = 25
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        favorites = dataController.getFavoriteBeers()
        updateTable()
    }
    
    private func updateTable() {
        DispatchQueue.main.async {
            self.tableView.dataSource = self
            self.tableView.reloadData()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide

        title = Constants.Content.favorites
        self.setNavBarTitleFont()
        
        let sortStack = UIStackView()
        
        let count = sortTypes.count
        for i in 0..<count {
            let button = createSortButton(title: sortTypes[i], tag: i)
            sortButtons.append(button)
            sortStack.addArrangedSubview(button)
        }
        
        sortStack.axis = .horizontal
        sortStack.alignment = .fill
        sortStack.distribution = .fillEqually
        
        view.addSubview(sortStack)
        sortStack.anchor(top: safeArea.topAnchor, bottom: nil, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.anchor(top: sortStack.bottomAnchor, bottom: safeArea.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        tableView.register(FavoritesTableViewCell.self, forCellReuseIdentifier: "FavoritesTableViewCell")
    }
    
    private func createSortButton(title: String, tag: Int) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = Constants.Design.Font.button
        button.setTitleColor(Constants.Design.Color.Primary.buttonText, for: .normal)
        button.tag = tag
        
        if sortBy == tag {
            button.backgroundColor = Constants.Design.Color.Primary.buttonBgSel
        } else {
            button.backgroundColor = Constants.Design.Color.Primary.buttonBg
        }
        
        button.addTarget(self, action: #selector(sortButtonTaped), for: .touchUpInside)
        
        return button
    }
    
    @objc func sortButtonTaped(sender: UIButton!) {
        if sortBy == sender.tag {
            isSortDesc = !isSortDesc
        } else {
            let count = sortTypes.count
            for i in 0..<count {
                sortButtons[i].backgroundColor = Constants.Design.Color.Primary.buttonBg
            }
            sender.backgroundColor = Constants.Design.Color.Primary.buttonBgSel
            
            sortBy = sender.tag
            
            isSortDesc = true
        }
        
        sortFavorites(tag: sender.tag)
        updateTable()
    }
    
    private func sortFavorites(tag: Int) {
        switch tag {
        case 1:
            isSortDesc ? favorites.sort(by: { $0.alcohol < $1.alcohol }) : favorites.sort(by: { $0.alcohol > $1.alcohol })
        case 2:
            isSortDesc ?  favorites.sort(by: { $0.ebc < $1.ebc }) : favorites.sort(by: { $0.ebc > $1.ebc })
        case 3:
            isSortDesc ? favorites.sort(by: { $0.ibu < $1.ibu }) : favorites.sort(by: { $0.ibu > $1.ibu })
        default:
            isSortDesc ? favorites.sort(by: { $0.name! < $1.name! }) : favorites.sort(by: { $0.name! > $1.name! })
        }
    }
}

// MARK: Table View Data Source

extension FavoritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavoritesTableViewCell", for: indexPath) as! FavoritesTableViewCell
        
        let beer = favorites[indexPath.row]
        cell.setup(with: beer)
        
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailsVC = BeerDetailsViewController()
        detailsVC.beer = favorites[indexPath.row]
        
        let cacheID = NSString(string: "\(favorites[indexPath.row].id)")
        if let cachedData = photosCache.object(forKey: cacheID) {
            detailsVC.imgData = cachedData as Data
        }
        
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
}
