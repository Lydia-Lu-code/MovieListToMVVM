//
//  Protocols.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/20.
//

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

//protocol MovieListViewModelInput {
//    func viewDidLoad()
//    func viewWillAppear()  // 添加生命週期方法
//    func didSelectMovie(at index: Int)
//    func toggleFavorite(at index: Int)
//    func clearCache()      // 添加快取清理方法
//    func refreshData()     // 添加資料刷新方法
//}
//
//protocol MovieListViewModelOutput {
//    var movies: Observable<[MovieCellViewModel]> { get }
//    var isLoading: Observable<Bool> { get }
//    var error: Observable<String?> { get }
//}
//
//protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {}
//
