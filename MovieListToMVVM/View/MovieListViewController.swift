//
//  ViewController.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/20.
//

import UIKit

class MovieListViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: MovieListViewModel
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    // MARK: - Initialization
    init(viewModel: MovieListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        let movieService = MovieService()
        self.viewModel = DefaultMovieListViewModel(movieService: movieService)
        super.init(coder: coder)
    }
    
    deinit {
        print("MovieListViewController deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "電影列表"
        setupUI()
        bindViewModel()
        registerNotifications()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // 可以開始動畫或加載數據
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 停止ongoing操作
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        // 清理資源
    }
    
    // MARK: - Memory Warning
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // 清理快取
        viewModel.clearCache()
    }
    
    // MARK: - Concurrent Programming
    private func registerNotifications() {
        // 使用 DispatchQueue 確保線程安全
        DispatchQueue.main.async { [weak self] in
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self?.handleDataUpdate),
                name: NSNotification.Name("DataUpdated"),
                object: nil
            )
        }
    }
    
    @objc private func handleDataUpdate() {
        // 使用併發佇列處理更新
        let queue = DispatchQueue(label: "com.movieapp.update", qos: .userInitiated, attributes: .concurrent)
        queue.async { [weak self] in
            self?.viewModel.refreshData()
        }
    }
    
    // MARK: - Private Methods
    private func bindViewModel() {
        viewModel.isLoading.bind { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }
        
        viewModel.movies.bind { [weak self] _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
        viewModel.error.bind { [weak self] error in
            if let error = error {
                DispatchQueue.main.async {
                    self?.showError(error)
                }
            }
        }
    }
}

// MARK: - UI Setup
extension MovieListViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        setupActivityIndicator()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "MovieCell")
        // 添加下拉刷新
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    private func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func handleRefresh() {
        viewModel.viewDidLoad()
        tableView.refreshControl?.endRefreshing()
    }
}

// MARK: - UITableViewDelegate & UITableViewDataSource
extension MovieListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell", for: indexPath)
        let movie = viewModel.movies.value[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = movie.title
        content.secondaryText = movie.overview
        cell.contentConfiguration = content
        
        // 添加收藏按鈕
        let favoriteButton = UIButton(type: .system)
        favoriteButton.setImage(UIImage(systemName: movie.isFavorite ? "star.fill" : "star"), for: .normal)
        favoriteButton.tag = indexPath.row
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped(_:)), for: .touchUpInside)
        cell.accessoryView = favoriteButton
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel.didSelectMovie(at: indexPath.row)
    }
    
    @objc private func favoriteButtonTapped(_ sender: UIButton) {
        viewModel.toggleFavorite(at: sender.tag)
    }
}



