import Foundation

public struct Movie: Identifiable, Decodable {
    public var id: Int
    
    public var name: String
    
    public var url: String?
    
    public var image: String?
    
    public var pubDate: Date?
    
    public var duration: String?
    
    public var description: String?
    
    public var aggregateRating: AggregateRating?
    
    public var genres: [Genre]?
    
    public var directors: [Director]?
    
    public var authors: [Author]?
    
    public var casts: [CastMember]?
    
    public var website: String?
    
    public var language: String?
    
    public var country: String?
    
    public var runtime: Int?
    
    public var imdbId: String?
    
    public var alias: [String]?
}

extension Movie {
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case image
        case pubDate = "datePublished"
        case duration
        case description
        case type = "@type"
        case aggregateRating
        case genre
        case director
        case author
        case actor
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        
        let url = try container.decode(String.self, forKey: .url)
        id = Utils.parseSubjectId(url: url)
        
        self.url = url

        image = try container.decodeIfPresent(String.self, forKey: .image)
        
        let pubDate = try container.decodeIfPresent(String.self, forKey: .pubDate)
        self.pubDate = {
            guard let pubDate, !pubDate.isEmpty else {
                return nil
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            return dateFormatter.date(from: pubDate)
        }()
        
        duration = try container.decodeIfPresent(String.self, forKey: .duration)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        aggregateRating = try container.decodeIfPresent(AggregateRating.self, forKey: .aggregateRating)
        
        let genres = try container.decodeIfPresent([String].self, forKey: .genre)
        if let genres {
            self.genres = genres.map { Genre(name: $0) }
        }
        
        directors = try container.decodeIfPresent([Director].self, forKey: .director)
        authors = try container.decodeIfPresent([Author].self, forKey: .author)
        casts = try container.decodeIfPresent([CastMember].self, forKey: .actor)
    }
    
}
