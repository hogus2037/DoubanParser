import Foundation

public struct TVSeason: Identifiable {
    public var id: Int
    public var seasonNumber: Int
    
    public var url: String?
    
    public init(id: Int, seasonNumber: Int, url: String? = nil) {
        self.id = id
        self.seasonNumber = seasonNumber
        self.url = url
    }
}
