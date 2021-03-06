//
//  FavoritesTableViewCell.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 28.01.2021.
//

import UIKit

class FavoritesTableViewCell: UITableViewCell {

    let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.Design.Color.Primary.normalText
        lbl.font = Constants.Design.Font.title
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()

    let detailsLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = Constants.Design.Color.Primary.normalText
        lbl.font = Constants.Design.Font.small
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    let photoImageView: UIImageView = {
        let imageView = UIImageView(image: Constants.Design.Image.defaultBeer)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        addSubview(detailsLabel)
        addSubview(photoImageView)
        
        photoImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, padding: UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0), width: Constants.Design.Size.thumbWidth, height: Constants.Design.Size.thumbHeight, enableInsets: false)
        
        titleLabel.anchor(top: topAnchor, left: photoImageView.rightAnchor, bottom: nil, right: rightAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), width: 0, height: 0, enableInsets: false)
        
        detailsLabel.anchor(top: titleLabel.bottomAnchor, left: titleLabel.leftAnchor, bottom: bottomAnchor, right: titleLabel.rightAnchor, padding: UIEdgeInsets(top: 3, left: 0, bottom: 10, right: 0), width: 0, height: 0, enableInsets: false)
        
        photoImageView.centerByY(self.centerYAnchor)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(with beer: Beer) {
        titleLabel.text = beer.name
        
        var details = ""
        
        var value = "\(beer.alcohol)"
        if value != "" {
            details += Constants.Content.vol + ": \(value)"
        }
        
        value = "\(beer.ebc)"
        if value != "" {
            if details != "" {
                details += ", "
            }
            details += Constants.Content.ebc + ": \(value)"
        }
        
        value = "\(beer.ibu)"
        if value != "" {
            if details != "" {
                details += ", "
            }
            details += Constants.Content.ibu + ": \(value)"
        }
        
        detailsLabel.text = details
    }
}
