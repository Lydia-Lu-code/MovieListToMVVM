

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
