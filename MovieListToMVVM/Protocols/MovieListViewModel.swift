//
//  Protocols.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/20.
//

import Foundation

protocol MovieListViewModelInput {
    func viewDidLoad()
    func viewWillAppear()  // 添加生命週期方法
    func didSelectMovie(at index: Int)
    func toggleFavorite(at index: Int)
    func clearCache()      // 添加快取清理方法
    func refreshData()     // 添加資料刷新方法
}

protocol MovieListViewModelOutput {
    var movies: Observable<[MovieCellViewModel]> { get }
    var isLoading: Observable<Bool> { get }
    var error: Observable<String?> { get }
}

protocol MovieListViewModel: MovieListViewModelInput, MovieListViewModelOutput {}

