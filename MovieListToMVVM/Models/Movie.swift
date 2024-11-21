//
//  Movie.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/20.
//

import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let overview: String
    let releaseDate: String
    let rating: Double
    var isFavorite: Bool
}
