//
//  BeerDetailsViewController.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 25.01.2021.
//

import Foundation
import UIKit

class BeerDetailsViewController: UIViewController {
    
    var beer: Beer!
    var imgData: Data?
    
    private let labelFont = UIFont.systemFont(ofSize: 16)
    private let labelFontTitle = UIFont.boldSystemFont(ofSize: 16)
    private let labelFontColor = UIColor.black
    
    private let stackSpacing: CGFloat = 10
    private let stackPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var safeArea: UILayoutGuide!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        safeArea = view.layoutMarginsGuide
        
        title = beer.name
        setNavBarTitleFont()
        
        scrollView.alwaysBounceVertical = true
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.anchor(top: safeArea.topAnchor, bottom: safeArea.bottomAnchor, leading: view.leadingAnchor, trailing: view.trailingAnchor)
        
        contentView.fillSuperview()
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        createParentStack()
    }
    
    private func createStack(title: String, value: String?) -> UIStackView {
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .right
        titleLabel.textColor = labelFontColor
        titleLabel.font = labelFontTitle
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.numberOfLines = 0
        valueLabel.textColor = labelFontColor
        valueLabel.font = labelFont
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.spacing = stackSpacing
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        
        if let widthAnchor = titleLabel.superview?.widthAnchor {
            titleLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.3).isActive = true
        }
        
        return stack
    }
    
    private func createParentStack() {
        let parentStack = UIStackView()
        
        var malts = ""
        
        if let items = beer.malts {
            for item in items {
                if let item = item as? BeerMalt,
                   let name = item.name,
                   let unit = item.unit
                {
                    if malts != "" {
                        malts += "\n"
                    }
                    
                    malts += name
                    malts += ", " + StringConstants.value.rawValue + ": \(item.value)"
                    malts += ", " + StringConstants.unit.rawValue + ": " + unit
                }
            }
        }
        
        var hops = ""
        
        if let items = beer.hops {
            for item in items {
                if let item = item as? BeerHop,
                   let name = item.name,
                   let unit = item.unit
                {
                    if hops != "" {
                        hops += "\n"
                    }
                    
                    hops += name
                    hops += ", " + StringConstants.value.rawValue + ": \(item.value)"
                    hops += ", " + StringConstants.unit.rawValue + ": " + unit
                    
                    if let add = item.add {
                        hops += ", " + StringConstants.add.rawValue + ": " + add
                    }
                    
                    if let attribute = item.attribute {
                        hops += ", " + StringConstants.attribute.rawValue + ": " + attribute
                    }
                }
            }
        }
        
        let titles = [
            StringConstants.name.rawValue,
            StringConstants.alcohol.rawValue,
            StringConstants.ebc.rawValue,
            StringConstants.ibu.rawValue,
            StringConstants.description.rawValue,
            StringConstants.tagline.rawValue,
            StringConstants.firstBrewed.rawValue,
            StringConstants.brewersTips.rawValue,
            StringConstants.foodPairing.rawValue,
            StringConstants.yeast.rawValue,
            StringConstants.malts.rawValue,
            StringConstants.hops.rawValue
        ];
        
        let values = [
            beer.name,
            "\(beer.alcohol)",
            "\(beer.ebc)",
            "\(beer.ibu)",
            beer.info,
            beer.tagline,
            beer.firstBrewed,
            beer.brewersTips,
            beer.foodPairing,
            beer.yeast,
            malts,
            hops
        ];
        
        let count = titles.count
        
        for i in 0..<count {
            if var value = values[i], value != "" {
                if titles[i] == StringConstants.alcohol.rawValue {
                    value += "°"
                }
                
                let stack = createStack(title: titles[i] + ":", value: value)
                parentStack.addArrangedSubview(stack)
            }
        }
        
        if let data = imgData {
            let photoImageView: UIImageView = {
                let image = UIImage(data: data)
                let imageView = UIImageView(image: image)
                imageView.contentMode = .scaleAspectFit
                return imageView
            }()
            
            parentStack.addArrangedSubview(photoImageView)
        }
        
        parentStack.axis = .vertical
        parentStack.spacing = stackSpacing
        parentStack.alignment = .fill
        parentStack.distribution = .fill
        
        contentView.addSubview(parentStack)
        parentStack.fillSuperview(padding: stackPadding)
    }
}
