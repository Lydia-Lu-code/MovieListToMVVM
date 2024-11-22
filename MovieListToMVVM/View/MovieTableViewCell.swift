//
//  MovieTableViewCell.swift
//  MovieListToMVVM
//
//  Created by Lydia Lu on 2024/11/22.
//

import UIKit

protocol MovieCellDelegate: AnyObject {
    func didTapFavorite(movieId: String, currentState: Bool)
}

class MovieTableViewCell: UITableViewCell {
    static let identifier = "MovieTableViewCell"
    
    // MARK: - Properties
    private var movieId: String?
    private var isFavorite: Bool = false
    weak var delegate: MovieCellDelegate?
    
    // MARK: - UI Elements
    private let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.textColor = .label
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        label.numberOfLines = 2
        return label
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .systemOrange
        return label
    }()
    
    private lazy var favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .systemRed
        button.setImage(UIImage(systemName: "heart"), for: .normal)
        button.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .center
        return stackView
    }()
    
    private let textStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .systemBackground
        
        contentView.addSubview(containerStackView)
        
        containerStackView.addArrangedSubview(movieImageView)
        containerStackView.addArrangedSubview(textStackView)
        containerStackView.addArrangedSubview(favoriteButton)
        
        textStackView.addArrangedSubview(titleLabel)
        textStackView.addArrangedSubview(overviewLabel)
        textStackView.addArrangedSubview(ratingLabel)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        [containerStackView, movieImageView, textStackView, favoriteButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            containerStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            containerStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            containerStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            
            movieImageView.widthAnchor.constraint(equalToConstant: 60),
            movieImageView.heightAnchor.constraint(equalToConstant: 90),
            
            favoriteButton.widthAnchor.constraint(equalToConstant: 44),
            favoriteButton.heightAnchor.constraint(equalToConstant: 44),
            
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 100)
        ])
    }
    
    // MARK: - Configuration
    func configure(with viewModel: MovieCellViewModel) {
        movieId = viewModel.movie.id
        isFavorite = viewModel.isFavorite
        titleLabel.text = viewModel.title
        overviewLabel.text = viewModel.overview
        ratingLabel.text = viewModel.rating
        updateFavoriteButton(isFavorite: viewModel.isFavorite)
    }
    
    func updateFavoriteStatus(_ isFavorite: Bool) {
        self.isFavorite = isFavorite
        updateFavoriteButton(isFavorite: isFavorite)
    }
    
    private func updateFavoriteButton(isFavorite: Bool) {
        let imageName = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    // MARK: - Actions
    @objc private func favoriteButtonTapped() {
        guard let movieId = movieId else { return }
        delegate?.didTapFavorite(movieId: movieId, currentState: isFavorite)
    }
    
    // MARK: - Reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImageView.image = nil
        titleLabel.text = nil
        overviewLabel.text = nil
        ratingLabel.text = nil
    }
}
