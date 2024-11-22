

import Foundation

struct Movie: Codable {
    let id: String
    let title: String
    let overview: String
    let releaseDate: String
    let rating: Double
    let posterPath: String?
    var isFavorite: Bool
    
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let date = dateFormatter.date(from: releaseDate) {
            dateFormatter.dateFormat = "yyyy年MM月dd日"
            return dateFormatter.string(from: date)
        }
        return releaseDate
    }
}
