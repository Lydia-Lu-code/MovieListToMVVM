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
