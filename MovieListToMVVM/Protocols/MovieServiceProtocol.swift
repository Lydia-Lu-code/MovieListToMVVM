import Foundation

protocol MovieServiceProtocol {
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
    func saveMovie(_ movie: Movie)
    func deleteMovie(_ movie: Movie)
    func loadSavedMovies() -> [Movie]
}

class MovieService: MovieServiceProtocol {
    private let dataManager = MovieDataManager.shared
    
    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            // Simulate network delay
            Thread.sleep(forTimeInterval: 1.0)
            
            let movies = [
                Movie(id: "1",
                     title: "大藍海",
                     overview: "在一片浩瀚的海洋中...",
                     releaseDate: "2024-01-15",
                     rating: 8.5,
                     posterPath: nil,
                     isFavorite: false),
                Movie(id: "2",
                     title: "星際冒險",
                     overview: "一群勇敢的太空探險家...",
                     releaseDate: "2024-02-20",
                     rating: 9.0,
                     posterPath: nil,
                     isFavorite: false)
            ]
            
            DispatchQueue.main.async {
                completion(.success(movies))
            }
        }
    }
    
    func saveMovie(_ movie: Movie) {
        dataManager.addToCache(movie)
        dataManager.saveToUserDefaults()
    }
    
    func deleteMovie(_ movie: Movie) {
        dataManager.removeFromCache(movie.id)
        dataManager.saveToUserDefaults()
    }
    
    func loadSavedMovies() -> [Movie] {
        return dataManager.loadFromUserDefaults()
    }
}

//class MovieService: MovieServiceProtocol {
//    private let dataManager = MovieDataManager.shared
//    
//    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//            let movies = [
//                Movie(id: "1",
//                     title: "大藍海",
//                     overview: "在一片浩瀚的海洋中...",
//                     releaseDate: "2024-01-15",
//                     rating: 8.5,
//                     posterPath: nil,
//                     isFavorite: false),
//                Movie(id: "2",
//                     title: "星際冒險",
//                     overview: "一群勇敢的太空探險家...",
//                     releaseDate: "2024-02-20",
//                     rating: 9.0,
//                     posterPath: nil,
//                     isFavorite: false)
//            ]
//            completion(.success(movies))
//        }
//    }
//    
//    func saveMovie(_ movie: Movie) {
//        dataManager.addToCache(movie)
//        dataManager.saveToUserDefaults()
//    }
//    
//    func deleteMovie(_ movie: Movie) {
//        dataManager.removeFromCache(movie.id)
//        dataManager.saveToUserDefaults()
//    }
//    
//    func loadSavedMovies() -> [Movie] {
//        return dataManager.loadFromUserDefaults()
//    }
//}

//import Foundation
//
//// MARK: - Protocols
////protocol MovieServiceProtocol {
////    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
////    func saveMovie(_ movie: Movie)
////    func deleteMovie(_ movie: Movie)
////}
//
//protocol MovieServiceProtocol {
//    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
//    func saveMovie(_ movie: Movie)
//    func deleteMovie(_ movie: Movie)
//    func loadSavedMovies() -> [Movie]
//}
//
//// MARK: - Error Types
//enum MovieError: Error {
//    case saveFailed
//    case loadFailed
//    case invalidData
//}
//
//// MARK: - Service Implementation
//class MovieService: MovieServiceProtocol {
//    private let dataManager = MovieDataManager.shared
//    
//    func saveMovie(_ movie: Movie) {
//        dataManager.addToCache(movie)
//        dataManager.saveToUserDefaults()
//    }
//    
//    func deleteMovie(_ movie: Movie) {
//        dataManager.removeFromCache(movie.id)
//        dataManager.saveToUserDefaults()
//    }
//    
//    func loadSavedMovies() -> [Movie] {
//        return dataManager.loadFromUserDefaults()
//    }
//    
//    
//    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
//            let movies = [
//                Movie(id: "1", title: "大藍海", overview: "在一片浩瀚的海洋中...",
//                      releaseDate: "2024-01-15", rating: 8.5, posterPath: nil, isFavorite: false),
//                Movie(id: "2", title: "星際冒險", overview: "一群勇敢的太空探險家...",
//                      releaseDate: "2024-02-20", rating: 9.0, posterPath: nil, isFavorite: false)
//            ]
//            completion(.success(movies))
//        }
//    }
////    
////    func saveMovie(_ movie: Movie) {
////        dataManager.addToCache(movie)
////        dataManager.saveToUserDefaults()
////    }
////    
////    func deleteMovie(_ movie: Movie) {
////        dataManager.removeFromCache(movie.id)
////        dataManager.saveToUserDefaults()
////    }
//}
//
//////
//////  MovieServiceProtocol.swift
//////  MovieListToMVVM
//////
//////  Created by Lydia Lu on 2024/11/20.
//////
////
////import Foundation
////
////protocol MovieServiceProtocol {
////    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void)
////    func saveMovie(_ movie: Movie)
////    func deleteMovie(_ movie: Movie)
////}
////
////class MovieService: MovieServiceProtocol {
////    func fetchMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
////        // 模擬網路請求
////        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
////            let movies = [
////                Movie(id: "1", title: "測試電影1", overview: "簡介1", releaseDate: "2024-01-01", rating: 8.5, isFavorite: false),
////                Movie(id: "2", title: "測試電影2", overview: "簡介2", releaseDate: "2024-02-01", rating: 7.8, isFavorite: false)
////            ]
////            completion(.success(movies))
////        }
////    }
////    
////    func saveMovie(_ movie: Movie) {
////        // 實現儲存邏輯
////    }
////    
////    func deleteMovie(_ movie: Movie) {
////        // 實現刪除邏輯
////    }
////}
