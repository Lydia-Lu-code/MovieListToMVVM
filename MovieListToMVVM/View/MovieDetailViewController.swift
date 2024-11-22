

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: - Properties
    private let movie: Movie
    private let viewModel: MovieListViewModel
    private var isFavorite: Bool
    
    // MARK: - UI Elements
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .systemBackground
        return scrollView
    }()
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .systemGray
        return label
    }()
    
    private let ratingView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemOrange
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let overviewTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "劇情簡介"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    // MARK: - Initialization
    init(movie: Movie, viewModel: MovieListViewModel) {
        self.movie = movie
        self.viewModel = viewModel
        self.isFavorite = movie.isFavorite
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        configureWithMovie()
        setupBindings()
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        view.backgroundColor = .systemBackground
        setupScrollView()
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        let contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        // Add all subviews to content view
        contentView.addSubview(posterImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(releaseDateLabel)
        contentView.addSubview(ratingView)
        contentView.addSubview(overviewTitleLabel)
        contentView.addSubview(overviewLabel)
        ratingView.addSubview(ratingLabel)
        
        // Setup constraints
        setupConstraints(for: contentView)
    }
    
    private func setupConstraints(for contentView: UIView) {
        [posterImageView, titleLabel, releaseDateLabel, ratingView,
         ratingLabel, overviewTitleLabel, overviewLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            // ScrollView constraints
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // ContentView constraints
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Poster image constraints
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.heightAnchor.constraint(equalToConstant: 300),
            
            // Title constraints
            titleLabel.topAnchor.constraint(equalTo: posterImageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            // Release date constraints
            releaseDateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            releaseDateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            releaseDateLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Rating view constraints
            ratingView.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 16),
            ratingView.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            ratingView.widthAnchor.constraint(equalToConstant: 80),
            ratingView.heightAnchor.constraint(equalToConstant: 32),
            
            // Rating label constraints
            ratingLabel.centerXAnchor.constraint(equalTo: ratingView.centerXAnchor),
            ratingLabel.centerYAnchor.constraint(equalTo: ratingView.centerYAnchor),
            
            // Overview title constraints
            overviewTitleLabel.topAnchor.constraint(equalTo: ratingView.bottomAnchor, constant: 24),
            overviewTitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewTitleLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            // Overview content constraints
            overviewLabel.topAnchor.constraint(equalTo: overviewTitleLabel.bottomAnchor, constant: 8),
            overviewLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            overviewLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            overviewLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
    }
    
    private func setupBindings() {
        // 監聽收藏狀態變化
        viewModel.favoriteUpdated.bind { [weak self] (movieId, isFavorite) in
            guard let self = self, movieId == self.movie.id else { return }
            DispatchQueue.main.async {
                self.isFavorite = isFavorite
                self.updateFavoriteButton()
            }
        }
    }
    
    
    private func configureNavigationBar() {
        let favoriteButton = UIBarButtonItem(
            image: UIImage(systemName: isFavorite ? "heart.fill" : "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteButtonTapped)
        )
        favoriteButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = favoriteButton
    }
    
    private func configureWithMovie() {
        title = movie.title
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.formattedDate
        ratingLabel.text = String(format: "%.1f", movie.rating)
        overviewLabel.text = movie.overview
        
        if movie.posterPath == nil {
            posterImageView.image = UIImage(systemName: "film")
            posterImageView.tintColor = .systemGray4
            posterImageView.contentMode = .scaleAspectFit
        }
    }
    
    private func updateFavoriteButton() {
        let image = UIImage(systemName: isFavorite ? "heart.fill" : "heart")
        navigationItem.rightBarButtonItem?.image = image
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        isFavorite.toggle()
        updateFavoriteButton()
        viewModel.updateFavoriteStatus(for: movie.id, isFavorite: isFavorite)
    }
}
