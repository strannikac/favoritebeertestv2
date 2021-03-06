//
//  Constants.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 06.03.2021.
//

import Foundation
import UIKit

struct Constants {
    struct Design {
        struct Color {
            struct Primary {
                static let normalText = UIColor.black
                static let buttonText = UIColor.black
                static let buttonBg = UIColor.lightGray
                static let buttonBgSel = UIColor.white
                // example: static let Blue = UIColor.rgba(red: 0, green: 122, blue: 255, alpha: 1)
            }
            
            struct Secondary {
               
            }
            
            struct Grayscale {
                
            }
        }
        
        struct Image {
            static let icoTabBarList = UIImage(systemName: "list.bullet")
            static let defaultBeer = UIImage(named: "default_beer")
            static let icoFavorites = UIImage(systemName: "star.fill")
        }
        
        struct Font {
            static let title = UIFont.boldSystemFont(ofSize: 16)
            static let titleThin = UIFont.systemFont(ofSize: 16)
            static let small = UIFont.systemFont(ofSize: 12)
            static let navbar = UIFont(name: "Chalkduster", size: 20)
            static let button = UIFont.boldSystemFont(ofSize: 16)
        }
        
        struct Size {
            static let favoriteButtonSize: CGFloat = 50
            static let thumbWidth: CGFloat = 30
            static let thumbHeight: CGFloat = 50
            static let stackSpacing: CGFloat = 10
            static let stackPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        }
    }

    struct Content {
        static let no = "No"
        static let yes = "Yes"
        static let ok = "OK"
        static let error = "Error"
        static let notice = "Notice"
        static let cancel = "Cancel"
        static let submit = "Submit"
        static let decline = "Decline"
        static let confirm = "Confirm"
        static let accept = "Accept"
        static let delete = "Delete"
        static let somethingWrong = "Something goes wrong. Try again later."
        static let errUrl = "URL address is invalid."
        static let errResponseData = "Response data is empty or incorrect."
        static let nocashBranch = "No cash branch."
        static let hasCoinStation = "Has coin station."
        static let errEmptyData = "Data is not found."
        static let allBeers = "All Beers"
        static let favorites = "Favorites"
        static let vol = "Vol"
        static let alcohol = "Alcohol"
        static let name = "Name"
        static let ebc = "EBC"
        static let ibu = "IBU"
        static let description = "Description"
        static let tagline = "Tagline"
        static let firstBrewed = "First Brewed"
        static let brewersTips = "Brewers Tips"
        static let foodPairing = "Food Pairing"
        static let yeast = "Yeast"
        static let malt = "Malt"
        static let malts = "Malts"
        static let hop = "Hop"
        static let hops = "Hops"
        static let value = "Value"
        static let unit = "Unit"
        static let add = "Add"
        static let attribute = "Attribute"
    }

    struct API {
        static let baseUrl = "https://api.punkapi.com/v2/beers"
        // example: static let DB_REF = Firestore.firestore()
    }
}
