//
//  BeerIngredientsModel.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation

// MARK: - Ingredients Model

struct BeerIngredientsModel: Codable, Equatable {
    let malt: [BeerIngredientsMaltModel]
    let hops: [BeerIngredientsHopsModel]
    let yeast: String?
}

// MARK: - Ingredients Malt Model

struct BeerIngredientsMaltModel: Codable, Equatable {
    let name: String?
    let amount: BeerVolumeModel?
}

// MARK: - Ingredients Hops Model

struct BeerIngredientsHopsModel: Codable, Equatable {
    let name: String?
    let amount: BeerVolumeModel?
    let add: String?
    let attribute: String?
}
