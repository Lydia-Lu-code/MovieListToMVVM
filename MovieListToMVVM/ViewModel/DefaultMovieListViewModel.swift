

import Foundation

class DefaultMovieListViewModel: MovieListViewModel {
    // MARK: - Outputs
    var movies: Observable<[MovieCellViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var error: Observable<String?> = Observable(nil)
    var favoriteUpdated: Observable<(String, Bool)> = Observable(("", false))
    
    // MARK: - Private Properties
    private let movieService: MovieServiceProtocol
    private var movieList: [Movie] = []
    private var isDisposed = false
    
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
        loadSavedMovies()
    }
    
    deinit {
        isDisposed = true
    }
    
    // MARK: - MovieListViewModelInput
    func viewDidLoad() {
        fetchMovies()
    }
    
    func viewWillAppear() {
        refreshData()
    }
    
    func toggleFavorite(at index: Int) {
        guard index < movieList.count else { return }
        
        movieList[index].isFavorite.toggle()
        let movie = movieList[index]
        
        if movie.isFavorite {
            movieService.saveMovie(movie)
        } else {
            movieService.deleteMovie(movie)
        }
        
        favoriteUpdated.value = (movie.id, movie.isFavorite)
        updateMoviesViewModel()
    }
    
    func updateFavoriteStatus(for movieId: String, isFavorite: Bool) {
        if let index = movieList.firstIndex(where: { $0.id == movieId }) {
            var updatedMovie = movieList[index]
            updatedMovie.isFavorite = isFavorite
            
            if isFavorite {
                movieService.saveMovie(updatedMovie)
            } else {
                movieService.deleteMovie(updatedMovie)
            }
            
            movieList[index] = updatedMovie
            updateMoviesViewModel()
            favoriteUpdated.value = (movieId, isFavorite)
        }
    }
    
    func clearCache() {
        movieList.removeAll()
        updateMoviesViewModel()
    }
    
    func refreshData() {
        fetchMovies()
    }
    
    // MARK: - Private Methods
    private func fetchMovies() {
        guard !isDisposed else { return }
        isLoading.value = true
        
        movieService.fetchMovies { [weak self] result in
            guard let self = self, !self.isDisposed else { return }
            
            DispatchQueue.main.async {
                self.isLoading.value = false
                
                switch result {
                case .success(let movies):
                    self.movieList = movies
                    self.loadSavedMovies()
                    self.updateMoviesViewModel()
                case .failure(let error):
                    self.error.value = error.localizedDescription
                }
            }
        }
    }
    
    private func loadSavedMovies() {
        let savedMovies = movieService.loadSavedMovies()
        for savedMovie in savedMovies {
            if let index = movieList.firstIndex(where: { $0.id == savedMovie.id }) {
                movieList[index].isFavorite = true
            }
        }
    }
    
    private func updateMoviesViewModel() {
        guard !isDisposed else { return }
        DispatchQueue.main.async {
            self.movies.value = self.movieList.map { MovieCellViewModel(movie: $0) }
        }
    }
}

//import Foundation
//
//
//class DefaultMovieListViewModel: MovieListViewModel {
//    // MARK: - Outputs
//    var movies: Observable<[MovieCellViewModel]> = Observable([])
//    var isLoading: Observable<Bool> = Observable(false)
//    var error: Observable<String?> = Observable(nil)
//    var favoriteUpdated: Observable<(String, Bool)> = Observable(("", false))
//    
//    // MARK: - Private Properties
//    private let movieService: MovieServiceProtocol
//    private var movieList: [Movie] = []
//    
//    init(movieService: MovieServiceProtocol) {
//        self.movieService = movieService
//        loadSavedMovies()
//    }
//    
//    // MARK: - MovieListViewModelInput
//    func viewDidLoad() {
//        fetchMovies()
//    }
//    
//    func viewWillAppear() {
//        refreshData()
//    }
//    
//    func toggleFavorite(at index: Int) {
//        guard index < movieList.count else { return }
//        
//        movieList[index].isFavorite.toggle()
//        let movie = movieList[index]
//        
//        if movie.isFavorite {
//            movieService.saveMovie(movie)
//        } else {
//            movieService.deleteMovie(movie)
//        }
//        
//        favoriteUpdated.value = (movie.id, movie.isFavorite)
//        updateMoviesViewModel()
//    }
//    
//    func updateFavoriteStatus(for movieId: String, isFavorite: Bool) {
//        if let index = movieList.firstIndex(where: { $0.id == movieId }) {
//            var updatedMovie = movieList[index]
//            updatedMovie.isFavorite = isFavorite
//            
//            if isFavorite {
//                movieService.saveMovie(updatedMovie)
//            } else {
//                movieService.deleteMovie(updatedMovie)
//            }
//            
//            movieList[index] = updatedMovie
//            updateMoviesViewModel()
//            favoriteUpdated.value = (movieId, isFavorite)
//        }
//    }
//    
//    func clearCache() {
//        movieList.removeAll()
//        updateMoviesViewModel()
//    }
//    
//    func refreshData() {
//        fetchMovies()
//    }
//    
//    // MARK: - Private Methods
//    private func fetchMovies() {
//        isLoading.value = true
//        
//        movieService.fetchMovies { [weak self] result in
//            guard let self = self else { return }
//            self.isLoading.value = false
//            
//            switch result {
//            case .success(let movies):
//                self.movieList = movies
//                self.loadSavedMovies() // 載入已保存的收藏狀態
//                self.updateMoviesViewModel()
//            case .failure(let error):
//                self.error.value = error.localizedDescription
//            }
//        }
//    }
//    
//    private func loadSavedMovies() {
//        let savedMovies = movieService.loadSavedMovies()
//        for savedMovie in savedMovies {
//            if let index = movieList.firstIndex(where: { $0.id == savedMovie.id }) {
//                movieList[index].isFavorite = true
//            }
//        }
//    }
//    
//    private func updateMoviesViewModel() {
//        movies.value = movieList.map { MovieCellViewModel(movie: $0) }
//    }
//}
//
////import Foundation
////
////class DefaultMovieListViewModel: MovieListViewModel {
////    // MARK: - Outputs
////    var movies: Observable<[MovieCellViewModel]> = Observable([])
////    var isLoading: Observable<Bool> = Observable(false)
////    var error: Observable<String?> = Observable(nil)
////    var favoriteUpdated: Observable<(String, Bool)> = Observable(("", false))
////    
////    // MARK: - Private Properties
////    private let movieService: MovieServiceProtocol
////    private var movieList: [Movie] = []
////    
////    init(movieService: MovieServiceProtocol) {
////        self.movieService = movieService
////        loadSavedMovies()
////    }
////    
////    // MARK: - Public Methods
////    func updateFavoriteStatus(for movieId: String, isFavorite: Bool) {
////        // 更新本地資料
////        if let index = movieList.firstIndex(where: { $0.id == movieId }) {
////            var updatedMovie = movieList[index]
////            updatedMovie.isFavorite = isFavorite
////            
////            // 儲存到資料庫
////            if isFavorite {
////                movieService.saveMovie(updatedMovie)
////            } else {
////                movieService.deleteMovie(updatedMovie)
////            }
////            
////            // 更新本地列表
////            movieList[index] = updatedMovie
////            updateMoviesViewModel()
////            
////            // 通知觀察者
////            favoriteUpdated.value = (movieId, isFavorite)
////        }
////    }
////    
////    private func loadSavedMovies() {
////        // 從 UserDefaults 加載已保存的收藏狀態
////        let savedMovies = movieService.loadSavedMovies()
////        for savedMovie in savedMovies {
////            if let index = movieList.firstIndex(where: { $0.id == savedMovie.id }) {
////                movieList[index].isFavorite = true
////            }
////        }
////        updateMoviesViewModel()
////    }
////}
////
//////import Foundation
//////
//////// MARK: - ViewModel Implementation
//////class DefaultMovieListViewModel: MovieListViewModel {
//////    // MARK: - Outputs
//////    var movies: Observable<[MovieCellViewModel]> = Observable([])
//////    var isLoading: Observable<Bool> = Observable(false)
//////    var error: Observable<String?> = Observable(nil)
//////    var favoriteUpdated: Observable<(String, Bool)> = Observable(("", false))
//////    
//////    // MARK: - Private Properties
//////    private let movieService: MovieServiceProtocol
//////    private var movieList: [Movie] = []
//////    
//////    init(movieService: MovieServiceProtocol) {
//////        self.movieService = movieService
//////    }
//////    
//////    // MARK: - Input Methods
//////    func viewDidLoad() {
//////        fetchMovies()
//////    }
//////    
//////    func viewWillAppear() {
//////        refreshData()
//////    }
//////    
//////    func didSelectMovie(at index: Int) {
//////        guard index < movieList.count else { return }
//////    }
//////    
//////    func toggleFavorite(at index: Int) {
//////        guard index < movieList.count else { return }
//////        
//////        movieList[index].isFavorite.toggle()
//////        let movie = movieList[index]
//////        
//////        if movie.isFavorite {
//////            movieService.saveMovie(movie)
//////        } else {
//////            movieService.deleteMovie(movie)
//////        }
//////        
//////        favoriteUpdated.value = (movie.id, movie.isFavorite)
//////        updateMoviesViewModel()
//////    }
//////    
//////    func updateFavoriteStatus(for movieId: String, isFavorite: Bool) {
//////        guard let index = movieList.firstIndex(where: { $0.id == movieId }) else { return }
//////        
//////        movieList[index].isFavorite = isFavorite
//////        
//////        if isFavorite {
//////            movieService.saveMovie(movieList[index])
//////        } else {
//////            movieService.deleteMovie(movieList[index])
//////        }
//////        
//////        favoriteUpdated.value = (movieId, isFavorite)
//////        updateMoviesViewModel()
//////    }
//////    
//////    func clearCache() {
//////        movieList.removeAll()
//////        updateMoviesViewModel()
//////    }
//////    
//////    func refreshData() {
//////        fetchMovies()
//////    }
//////    
//////    // MARK: - Private Methods
//////    private func fetchMovies() {
//////        isLoading.value = true
//////        
//////        movieService.fetchMovies { [weak self] result in
//////            guard let self = self else { return }
//////            self.isLoading.value = false
//////            
//////            switch result {
//////            case .success(let movies):
//////                self.movieList = movies
//////                self.updateMoviesViewModel()
//////            case .failure(let error):
//////                self.error.value = error.localizedDescription
//////            }
//////        }
//////    }
//////    
//////    private func updateMoviesViewModel() {
//////        movies.value = movieList.map { MovieCellViewModel(movie: $0) }
//////    }
//////}
//////
////////import UIkit
////////
////////class DefaultMovieListViewModel: MovieListViewModel {
////////    // MARK: - Outputs
////////    var movies: Observable<[MovieCellViewModel]> = Observable([])
////////    var isLoading: Observable<Bool> = Observable(false)
////////    var error: Observable<String?> = Observable(nil)
////////    var favoriteUpdated: Observable<(String, Bool)> = Observable(("", false))
////////    
////////    // MARK: - Private Properties
////////    private let movieService: MovieServiceProtocol
////////    private var movieList: [Movie] = []
////////    
////////    init(movieService: MovieServiceProtocol) {
////////        self.movieService = movieService
////////        loadSavedMovies()
////////    }
////////    
////////    // MARK: - MovieListViewModelInput
////////    func viewDidLoad() {
////////        fetchMovies()
////////    }
////////    
////////    func viewWillAppear() {
////////        refreshData()
////////    }
////////    
////////    func toggleFavorite(at index: Int) {
////////        guard index < movieList.count else { return }
////////        
////////        movieList[index].isFavorite.toggle()
////////        let movie = movieList[index]
////////        
////////        if movie.isFavorite {
////////            movieService.saveMovie(movie)
////////        } else {
////////            movieService.deleteMovie(movie)
////////        }
////////        
////////        favoriteUpdated.value = (movie.id, movie.isFavorite)
////////        updateMoviesViewModel()
////////    }
////////    
////////    func updateFavoriteStatus(for movieId: String, isFavorite: Bool) {
////////        if let index = movieList.firstIndex(where: { $0.id == movieId }) {
////////            var updatedMovie = movieList[index]
////////            updatedMovie.isFavorite = isFavorite
////////            
////////            if isFavorite {
////////                movieService.saveMovie(updatedMovie)
////////            } else {
////////                movieService.deleteMovie(updatedMovie)
////////            }
////////            
////////            movieList[index] = updatedMovie
////////            updateMoviesViewModel()
////////            favoriteUpdated.value = (movieId, isFavorite)
////////        }
////////    }
////////    
////////    func clearCache() {
////////        movieList.removeAll()
////////        updateMoviesViewModel()
////////    }
////////    
////////    func refreshData() {
////////        fetchMovies()
////////    }
////////    
////////    // MARK: - Private Methods
////////    private func fetchMovies() {
////////        isLoading.value = true
////////        
////////        movieService.fetchMovies { [weak self] result in
////////            guard let self = self else { return }
////////            self.isLoading.value = false
////////            
////////            switch result {
////////            case .success(let movies):
////////                self.movieList = movies
////////                self.loadSavedMovies() // 載入已保存的收藏狀態
////////                self.updateMoviesViewModel()
////////            case .failure(let error):
////////                self.error.value = error.localizedDescription
////////            }
////////        }
////////    }
////////    
////////    private func loadSavedMovies() {
////////        let savedMovies = movieService.loadSavedMovies()
////////        for savedMovie in savedMovies {
////////            if let index = movieList.firstIndex(where: { $0.id == savedMovie.id }) {
////////                movieList[index].isFavorite = true
////////            }
////////        }
////////    }
////////    
////////    private func updateMoviesViewModel() {
////////        movies.value = movieList.map { MovieCellViewModel(movie: $0) }
////////    }
////////}
////////
////////////
////////////  DefaultMovieListViewModel.swift
////////////  MovieListToMVVM
////////////
////////////  Created by Lydia Lu on 2024/11/20.
////////////
//////////
//////////import Foundation
//////////
//////////class DefaultMovieListViewModel: MovieListViewModel {
//////////    // MARK: - Outputs
//////////    var movies: Observable<[MovieCellViewModel]> = Observable([])
//////////    var isLoading: Observable<Bool> = Observable(false)
//////////    var error: Observable<String?> = Observable(nil)
//////////    
//////////    // MARK: - Private Properties
//////////    private let movieService: MovieServiceProtocol
//////////    private var movieList: [Movie] = []
//////////    
//////////    // MARK: - Initialization
//////////    init(movieService: MovieServiceProtocol) {
//////////        self.movieService = movieService
//////////    }
//////////    
//////////    // MARK: - MovieListViewModelInput
//////////    func viewDidLoad() {
//////////        fetchMovies()
//////////    }
//////////    
//////////    func viewWillAppear() {
//////////        // 可以在這裡實現進入畫面時的更新邏輯
//////////        refreshData()
//////////    }
//////////    
//////////    func didSelectMovie(at index: Int) {
//////////        guard index < movieList.count else { return }
//////////        // 處理電影選擇邏輯
//////////    }
//////////    
//////////    func toggleFavorite(at index: Int) {
//////////        guard index < movieList.count else { return }
//////////        movieList[index].isFavorite.toggle()
//////////        updateMoviesViewModel()
//////////    }
//////////    
//////////    func clearCache() {
//////////        movieList.removeAll()
//////////        updateMoviesViewModel()
//////////    }
//////////    
//////////    func refreshData() {
//////////        fetchMovies()
//////////    }
//////////    
//////////    // MARK: - Private Methods
//////////    private func fetchMovies() {
//////////        isLoading.value = true
//////////        
//////////        movieService.fetchMovies { [weak self] result in
//////////            guard let self = self else { return }
//////////            self.isLoading.value = false
//////////            
//////////            switch result {
//////////            case .success(let movies):
//////////                self.movieList = movies
//////////                self.updateMoviesViewModel()
//////////            case .failure(let error):
//////////                self.error.value = error.localizedDescription
//////////            }
//////////        }
//////////    }
//////////    
//////////    private func updateMoviesViewModel() {
//////////        movies.value = movieList.map { movie in
//////////            MovieCellViewModel(
//////////                title: movie.title,
//////////                overview: movie.overview,
//////////                rating: "\(movie.rating)/10",
//////////                isFavorite: movie.isFavorite
//////////            )
//////////        }
//////////    }
//////////}
