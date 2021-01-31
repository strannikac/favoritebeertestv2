//
//  BeerTableViewCell.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 24.01.2021.
//

import UIKit

class BeerTableViewCell: UITableViewCell {

    private let favoriteButtonSize: CGFloat = 50
    private let photoWidth: CGFloat = 30
    private let photoHeight: CGFloat = 50

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.boldSystemFont(ofSize: 16)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    let alcoholLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .black
        lbl.font = UIFont.systemFont(ofSize: 12)
        lbl.textAlignment = .left
        return lbl
    }()

    let favoriteButton: UIButton = {
        let image = UIImage(systemName: "star.fill") as UIImage?
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        let btn = UIButton(type: .custom)
        btn.setImage(tintedImage, for: .normal)
        btn.imageView?.contentMode = .scaleAspectFill
        return btn
    }()
    
    let photoImageView: UIImageView = {
        let image = UIImage(named: "default_beer")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.isUserInteractionEnabled = true
        
        addSubview(titleLabel)
        addSubview(alcoholLabel)
        addSubview(favoriteButton)
        addSubview(photoImageView)
        
        photoImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 0), width: photoWidth, height: photoHeight, enableInsets: false)
        
        titleLabel.anchor(top: topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: favoriteButton.leftAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), width: 0, height: 0, enableInsets: false)
        
        alcoholLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, padding: UIEdgeInsets(top: 3, left: 0, bottom: 10, right: 0), width: 0, height: 0, enableInsets: false)
        
        favoriteButton.anchor(top: nil, left: nil, bottom: nil, right: rightAnchor, padding: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 5), width: favoriteButtonSize, height: favoriteButtonSize, enableInsets: false)
        
        favoriteButton.centerByY(self.centerYAnchor)
        photoImageView.centerByY(self.centerYAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with beer: Beer) {
        titleLabel.text = beer.name
        
        let alcohol = "\(beer.alcohol)"
        alcoholLabel.text = alcohol == "" ? "" : StringConstants.vol.rawValue + ": \(alcohol)"
        
        favoriteButton.tintColor = .lightGray
        if beer.isFavorite {
            favoriteButton.tintColor = .systemYellow
        }
    }
}
