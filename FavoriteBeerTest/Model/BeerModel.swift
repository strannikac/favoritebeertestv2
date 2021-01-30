//
//  BeerModel.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation

// MARK: - Beer (response)
struct BeerModel: Codable, Equatable {
    let id: Int
    let name: String?
    let tagline: String?
    let firstBrewed: String?
    let description: String?
    let imageUrl: String?
    let alcohol: Float?
    let ibu: Float?
    let targetFg: Float?
    let targetOg: Float?
    let ebc: Float?
    let srm: Float?
    let ph: Float?
    let attenuationLevel: Float?
    let volume: BeerVolumeModel?
    let boilVolume: BeerVolumeModel?
    let method: BeerMethodModel?
    let ingredients: BeerIngredientsModel?
    let foodPairing: [String]?
    let brewersTips: String?
    let contributedBy: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, tagline
        case firstBrewed = "first_brewed"
        case description
        case imageUrl = "image_url"
        case alcohol = "abv"
        case ibu
        case targetFg = "target_fg"
        case targetOg = "target_og"
        case ebc, srm, ph
        case attenuationLevel = "attenuation_level"
        case volume
        case boilVolume = "boil_volume"
        case method, ingredients
        case foodPairing = "food_pairing"
        case brewersTips = "brewers_tips"
        case contributedBy = "contributed_by"
    }
}
