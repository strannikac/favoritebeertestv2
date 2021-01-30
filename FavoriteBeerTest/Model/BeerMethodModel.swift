//
//  BeerMethodModel.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation

// MARK: - Method Model

struct BeerMethodModel: Codable, Equatable {
    let mashTemp: [BeerMethodMashTempModel]?
    let fermentation: BeerMethodFermentationModel?
    let twist: String?
    
    enum CodingKeys: String, CodingKey {
        case mashTemp = "mash_temp"
        case fermentation, twist
    }
}

// MARK: - Method Mash Temp Model

struct BeerMethodMashTempModel: Codable, Equatable {
    let temp: BeerVolumeModel?
    let duration: Float?
}

// MARK: - Method Fermentation Model

struct BeerMethodFermentationModel: Codable, Equatable {
    let temp: BeerVolumeModel?
}
