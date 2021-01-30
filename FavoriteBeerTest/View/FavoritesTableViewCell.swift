//
//  FavoritesTableViewCell.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 28.01.2021.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {
    
    private let photoWidth: CGFloat = 30
    private let photoHeight: CGFloat = 50
    
    var beer: Beer? {
        didSet {
            if let beer = beer {
                show(beer)
            }
        }
    }

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    let detailsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let photoImageView: UIImageView = {
        let image = UIImage(named: "default_beer")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(detailsLabel)
        addSubview(photoImageView)
        
        photoImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0), width: photoWidth, height: photoHeight, enableInsets: false)
        
        titleLabel.anchor(top: topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: rightAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), width: 0, height: 0, enableInsets: false)
        
        detailsLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, padding: UIEdgeInsets(top: 3, left: 0, bottom: 10, right: 0), width: 0, height: 0, enableInsets: false)
        
        photoImageView.centerByY(self.centerYAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func show(_ beer: Beer) {
        titleLabel.text = beer.name
        
        var details = ""
        
        var value = "\(beer.alcohol)"
        if value != "" {
            details += StringConstants.vol.rawValue + ": \(value)"
        }
        
        value = "\(beer.ebc)"
        if value != "" {
            if details != "" {
                details += ", "
            }
            details += StringConstants.ebc.rawValue + ": \(value)"
        }
        
        value = "\(beer.ibu)"
        if value != "" {
            if details != "" {
                details += ", "
            }
            details += StringConstants.ibu.rawValue + ": \(value)"
        }
        
        detailsLabel.text = details
    }
}
