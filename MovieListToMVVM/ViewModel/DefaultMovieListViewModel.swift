//
//  DefaultMovieListViewModel.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/20.
//

import Foundation

class DefaultMovieListViewModel: MovieListViewModel {
    // MARK: - Outputs
    var movies: Observable<[MovieCellViewModel]> = Observable([])
    var isLoading: Observable<Bool> = Observable(false)
    var error: Observable<String?> = Observable(nil)
    
    // MARK: - Private Properties
    private let movieService: MovieServiceProtocol
    private var movieList: [Movie] = []
    
    // MARK: - Initialization
    init(movieService: MovieServiceProtocol) {
        self.movieService = movieService
    }
    
    // MARK: - MovieListViewModelInput
    func viewDidLoad() {
        fetchMovies()
    }
    
    func viewWillAppear() {
        // 可以在這裡實現進入畫面時的更新邏輯
        refreshData()
    }
    
    func didSelectMovie(at index: Int) {
        guard index < movieList.count else { return }
        // 處理電影選擇邏輯
    }
    
    func toggleFavorite(at index: Int) {
        guard index < movieList.count else { return }
        movieList[index].isFavorite.toggle()
        updateMoviesViewModel()
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
        isLoading.value = true
        
        movieService.fetchMovies { [weak self] result in
            guard let self = self else { return }
            self.isLoading.value = false
            
            switch result {
            case .success(let movies):
                self.movieList = movies
                self.updateMoviesViewModel()
            case .failure(let error):
                self.error.value = error.localizedDescription
            }
        }
    }
    
    private func updateMoviesViewModel() {
        movies.value = movieList.map { movie in
            MovieCellViewModel(
                title: movie.title,
                overview: movie.overview,
                rating: "\(movie.rating)/10",
                isFavorite: movie.isFavorite
            )
        }
    }
}
