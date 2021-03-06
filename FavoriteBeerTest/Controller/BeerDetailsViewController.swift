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
        titleLabel.textColor = Constants.Design.Color.Primary.normalText
        titleLabel.font = Constants.Design.Font.title
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.numberOfLines = 0
        valueLabel.textColor = Constants.Design.Color.Primary.normalText
        valueLabel.font = Constants.Design.Font.titleThin
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, valueLabel])
        stack.axis = .horizontal
        stack.spacing = Constants.Design.Size.stackSpacing
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
                    malts += ", " + Constants.Content.value + ": \(item.value)"
                    malts += ", " + Constants.Content.unit + ": " + unit
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
                    hops += ", " + Constants.Content.value + ": \(item.value)"
                    hops += ", " + Constants.Content.unit + ": " + unit
                    
                    if let add = item.add {
                        hops += ", " + Constants.Content.add + ": " + add
                    }
                    
                    if let attribute = item.attribute {
                        hops += ", " + Constants.Content.attribute + ": " + attribute
                    }
                }
            }
        }
        
        let titles = [
            Constants.Content.name,
            Constants.Content.alcohol,
            Constants.Content.ebc,
            Constants.Content.ibu,
            Constants.Content.description,
            Constants.Content.tagline,
            Constants.Content.firstBrewed,
            Constants.Content.brewersTips,
            Constants.Content.foodPairing,
            Constants.Content.yeast,
            Constants.Content.malts,
            Constants.Content.hops
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
                if titles[i] == Constants.Content.alcohol {
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
        parentStack.spacing = Constants.Design.Size.stackSpacing
        parentStack.alignment = .fill
        parentStack.distribution = .fill
        
        contentView.addSubview(parentStack)
        parentStack.fillSuperview(padding: Constants.Design.Size.stackPadding)
    }
}
