import Foundation
import SwiftSoup

public struct Property {
    public let key: PropertyKey
    public let value: String?
}

public enum PropertyKey: String, CaseIterable {
    case title = "og:title"
    case description = "og:description"
    case image = "og:image"
    case url = "og:url"
    case type = "og:type"
    case siteName = "og:site_name"
    case duration = "video:duration"
    case casts = "video:actor"
    case director = "video:director"
    case genre = "v:genre"
    case releaseDate = "v:initialReleaseDate"
    case runtime = "v:runtime"
    case average = "v:average"
    case best = "v:best"
    case votes = "v:votes"
    
    case summary = "v:summary"
}


public struct PropertyInfo: Hashable {
    public var key: PropertyInfoKey
    public var value: Any?
    
    public static func == (lhs: PropertyInfo, rhs: PropertyInfo) -> Bool {
        return lhs.key == rhs.key
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(key)
    }
}

public enum PropertyInfoKey: String, CaseIterable {
    // Movie & TVSeries
    case country = "制片国家/地区"
    case language = "语言"
    case pubDate = "上映日期"
    case runtime = "片长"
    case website = "官方网站"
    case alias = "又名"
    case imdbId = "IMDb"
    case episodeNumber = "集数"
    // case seasonNumber = "季数"
    case episodeDuration = "单集片长"
    
    // Book
    case publisher = "出版社"
    case producer = "出品方"
    case subtitle = "副标题"
    case translator = "译者"
    case pubYear = "出版年"
    case pages = "页数"
    case price = "定价"
    case binding = "装帧"
    case isbn = "ISBN"
    case originalTitle = "原作名"
    case series = "丛书"
}
