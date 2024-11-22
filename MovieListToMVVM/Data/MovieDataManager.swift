import Foundation

class MovieDataManager {
    static let shared = MovieDataManager()
    private init() {}
    
    private let userDefaults = UserDefaults.standard
    private let moviesKey = "saved_movies"
    private var movieCache: [String: Movie] = [:]
    
    func addToCache(_ movie: Movie) {
        movieCache[movie.id] = movie
        saveToUserDefaults()
    }
    
    func removeFromCache(_ movieId: String) {
        movieCache.removeValue(forKey: movieId)
        saveToUserDefaults()
    }
    
    func saveToUserDefaults() {
        do {
            let data = try JSONEncoder().encode(Array(movieCache.values))
            userDefaults.set(data, forKey: moviesKey)
        } catch {
            print("Save failed: \(error)")
        }
    }
    
    func loadFromUserDefaults() -> [Movie] {
        guard let data = userDefaults.data(forKey: moviesKey),
              let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
            return []
        }
        
        movieCache = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
        return movies
    }
}

//import Foundation
//
//class MovieDataManager {
//    static let shared = MovieDataManager()
//    private init() {}
//    
//    private let userDefaults = UserDefaults.standard
//    private let moviesKey = "saved_movies"
//    private var movieCache: [String: Movie] = [:]
//    
//    func addToCache(_ movie: Movie) {
//        movieCache[movie.id] = movie
//        saveToUserDefaults()
//    }
//    
//    func removeFromCache(_ movieId: String) {
//        movieCache.removeValue(forKey: movieId)
//        saveToUserDefaults()
//    }
//    
//    func saveToUserDefaults() {
//        do {
//            let data = try JSONEncoder().encode(Array(movieCache.values))
//            userDefaults.set(data, forKey: moviesKey)
//        } catch {
//            print("Save failed: \(error)")
//        }
//    }
//    
//    func loadFromUserDefaults() -> [Movie] {
//        guard let data = userDefaults.data(forKey: moviesKey),
//              let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
//            return []
//        }
//        
//        movieCache = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
//        return movies
//    }
//}
//
//////
//////  MovieDataManager.swift
//////  MovieListToMVVM
//////
//////  Created by Lydia Lu on 2024/11/21.
//////
////
////import Foundation
////
////// MARK: - Enum
////enum MovieError: Error {
////    case saveFailed
////    case loadFailed
////    case invalidData
////}
////
////class MovieDataManager {
////    // MARK: - Singleton
////    static let shared = MovieDataManager()
////    private init() {}
////    
////    // MARK: - Properties
////    private let userDefaults = UserDefaults.standard
////    private let moviesKey = "saved_movies"
////    
////    // MARK: - Dictionary Usage
////    private var movieCache: [String: Movie] = [:]
////    
////    // MARK: - UserDefaults Methods
////    func saveToUserDefaults() {
////        do {
////            let data = try JSONEncoder().encode(Array(movieCache.values))
////            userDefaults.set(data, forKey: moviesKey)
////        } catch {
////            print("Save failed: \(error)")
////        }
////    }
////    
////    func loadFromUserDefaults() -> [Movie] {
////        guard let data = userDefaults.data(forKey: moviesKey),
////              let movies = try? JSONDecoder().decode([Movie].self, from: data) else {
////            return []
////        }
////        
////        // 更新快取
////        movieCache = Dictionary(uniqueKeysWithValues: movies.map { ($0.id, $0) })
////        return movies
////    }
////    
////    // MARK: - Cache Methods
////    func addToCache(_ movie: Movie) {
////        movieCache[movie.id] = movie
////    }
////    
////    func removeFromCache(_ movieId: String) {
////        movieCache.removeValue(forKey: movieId)
////    }
////}
