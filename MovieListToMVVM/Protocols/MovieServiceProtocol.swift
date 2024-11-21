//
//  MovieServiceProtocol.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/20.
//

import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func saveMovie(_ movie: Movie)
    func deleteMovie(_ movie: Movie)
}

class MovieService: MovieServiceProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        // 模擬網路請求
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            let movies = [
                Movie(id: "1", title: "測試電影1", overview: "簡介1", releaseDate: "2024-01-01", rating: 8.5, isFavorite: false),
                Movie(id: "2", title: "測試電影2", overview: "簡介2", releaseDate: "2024-02-01", rating: 7.8, isFavorite: false)
            ]
            completion(.success(movies))
        }
    }
    
    func saveMovie(_ movie: Movie) {
        // 實現儲存邏輯
    }
    
    func deleteMovie(_ movie: Movie) {
        // 實現刪除邏輯
    }
}
