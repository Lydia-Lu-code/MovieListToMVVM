//
//  MovieCellViewModel.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/20.
//

import Foundation


// MARK: - Cell ViewModel
struct MovieCellViewModel {
    let title: String
    let overview: String
    let rating: String
    let isFavorite: Bool
    let movie: Movie
    
    init(movie: Movie) {
        self.title = movie.title
        self.overview = movie.overview
        self.rating = String(format: "%.1f", movie.rating)
        self.isFavorite = movie.isFavorite
        self.movie = movie
    }
}
