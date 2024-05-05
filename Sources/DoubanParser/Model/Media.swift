
import Foundation

public enum Media: Identifiable, Decodable {
    public var id: Int {
        switch self {
        case .movie(let movie):
            return movie.id
        case .tvSeries(let tvSeries):
            return tvSeries.id
        case .book(let book):
            return book.id
        }
    }
    case movie(Movie)
    case tvSeries(TVSeries)
    case book(Book)
}


extension Media {
    private enum CodingKeys: String, CodingKey {
        case mediaType = "@type"
    }
    
    private enum MediaType: String, Codable, Equatable {
        case movie = "Movie"
        case tvSeries = "TVSeries"
        case book = "Book"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let mediaType = try container.decode(MediaType.self, forKey: .mediaType)
        
        switch mediaType {
        case .movie:
            self = try .movie(Movie(from: decoder))
            
        case .tvSeries:
            self = try .tvSeries(TVSeries(from: decoder))
            
        case .book:
            self = try .book(Book(from: decoder))
        }
    }
    
}
