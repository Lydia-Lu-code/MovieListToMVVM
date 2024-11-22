
import Foundation

protocol MovieListViewModelInput {
    func viewDidLoad()
    func viewWillAppear()
    func toggleFavorite(at index: Int)
    func updateFavoriteStatus(for movieId: String, isFavorite: Bool)
    func clearCache()
    func refreshData()
}

protocol MovieListViewModelOutput {
    var movies: Observable<[MovieCellViewModel]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
    var favoriteUpdated: Observable<(String, Bool)> { get }  // 新增：用於通知收藏狀態更新
}

protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {}
