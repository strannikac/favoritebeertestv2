//
//  BeerVolumeModel.swift
//  FavoriteBeerTest
//
//  Created by Alexander Sokhin on 23.01.2021.
//

import Foundation

// MARK: - Volume Model

struct BeerVolumeModel: Codable, Equatable {
    let value: Float?
    let unit: String?
}
