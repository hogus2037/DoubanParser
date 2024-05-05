import Foundation

public struct AggregateRating: Codable {
    public var ratingValue: String?
    
    public var ratingCount: String?
    
    public var bestRating: String?
    
    public var worstRating: String?
    
    public var type: String?
    
    public init(ratingValue: String? = nil, ratingCount: String? = nil, bestRating: String? = nil, worstRating: String? = nil) {
        self.ratingValue = ratingValue
        self.ratingCount = ratingCount
        self.bestRating = bestRating
        self.worstRating = worstRating
        self.type = "AggregateRating"
    }
    
    enum CodingKeys: String, CodingKey {
        case ratingValue
        case ratingCount
        case bestRating
        case worstRating
        case type = "@type"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.ratingValue = try container.decodeIfPresent(String.self, forKey: .ratingValue)
        self.ratingCount = try container.decodeIfPresent(String.self, forKey: .ratingCount)
        self.bestRating = try container.decodeIfPresent(String.self, forKey: .bestRating)
        self.worstRating = try container.decodeIfPresent(String.self, forKey: .worstRating)
        self.type = try container.decodeIfPresent(String.self, forKey: .type)
    }
}
