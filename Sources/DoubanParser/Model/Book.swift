import Foundation

public struct Book: Identifiable, Decodable {
    public var id: Int
    public let name: String
    public let url: String
    public var autors: [Author]?
    public var description: String?
    public var image: String?

    public let isbn: String?
    public let sameAs: String?
    
    // 出版社、出品方、副标题、译者、出版年、页数、定价、装帧
    public var originalTitle: String?
    public var publisher: String?
    public var producer: String?
    public var subtitle: String?
    public var translator: [String]?
    public var pubDate: Date?
    public var pages: Int?
    public var price: Double?
    public var binding: String?
    public var series: String?
    
    public var aggregateRating: AggregateRating?
}

extension Book {
    enum CodingKeys: String, CodingKey {
        case name
        case url
        case author
        case type = "@type"
        case isbn
        case sameAs
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let url = try container.decode(String.self, forKey: .url)
        self.url = url
        self.id = Utils.parseSubjectId(url: url)
        
        self.name = try container.decode(String.self, forKey: .name)
        self.isbn = try container.decodeIfPresent(String.self, forKey: .isbn)
        self.sameAs = try container.decodeIfPresent(String.self, forKey: .sameAs)
        self.autors = try container.decodeIfPresent([Author].self, forKey: .author)
    }
}
