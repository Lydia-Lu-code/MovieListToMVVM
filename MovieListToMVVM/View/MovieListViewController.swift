import UIKit

class MovieListViewController: UIViewController {
    // MARK: - Properties
    private var viewModel: MovieListViewModel
    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    private let movieService = MovieService()
    
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
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "電影列表"
        setupUI()
        bindViewModel()
        setupBindings()
        viewModel.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.viewWillAppear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        viewModel.clearCache()
    }
    
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
private extension MovieListViewController {
    func setupUI() {
        view.backgroundColor = .white
        setupTableView()
        setupActivityIndicator()
    }
    
    func setupTableView() {
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
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
    }
    
    func setupActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        activityIndicator.hidesWhenStopped = true
    }
}

// MARK: - Binding Setup
private extension MovieListViewController {
    func setupBindings() {
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
        
        viewModel.favoriteUpdated.bind { [weak self] (movieId, isFavorite) in
            self?.updateCellFavoriteStatus(for: movieId, isFavorite: isFavorite)
        }
    }
    
    func updateCellFavoriteStatus(for movieId: String, isFavorite: Bool) {
        for case let cell as MovieTableViewCell in tableView.visibleCells {
            if let indexPath = tableView.indexPath(for: cell),
               viewModel.movies.value[indexPath.row].movie.id == movieId {
                cell.updateFavoriteStatus(isFavorite)
                break
            }
        }
    }
    
    func showError(_ message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
    
    @objc func handleRefresh() {
        viewModel.refreshData()
        tableView.refreshControl?.endRefreshing()
    }
}

//// MARK: - MovieCellDelegate
//extension MovieListViewController: MovieCellDelegate {
//    func didTapFavorite(movieId: String, currentState: Bool) {
//        viewModel.updateFavoriteStatus(for: movieId, isFavorite: !currentState)
//    }
//}

// MARK: - UITableViewDelegate
extension MovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let movieCellViewModel = viewModel.movies.value[indexPath.row]
        let detailVC = MovieDetailViewController(
            movie: movieCellViewModel.movie,
            viewModel: viewModel
        )
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension MovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.movies.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: MovieTableViewCell.identifier,
            for: indexPath
        ) as? MovieTableViewCell else {
            return UITableViewCell()
        }
        
        let movie = viewModel.movies.value[indexPath.row]
        cell.configure(with: movie)
        cell.delegate = self
        
        return cell
    }
}

// MARK: - MovieCellDelegate
extension MovieListViewController: MovieCellDelegate {
    func didTapFavorite(movieId: String, currentState: Bool) {
        // 更新 ViewModel 中的收藏狀態
        viewModel.updateFavoriteStatus(for: movieId, isFavorite: !currentState)
        
        // 重新加載數據以確保 UI 更新
        if let index = viewModel.movies.value.firstIndex(where: { $0.movie.id == movieId }) {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? MovieTableViewCell {
                cell.updateFavoriteStatus(!currentState)
            }
        }
    }
}
