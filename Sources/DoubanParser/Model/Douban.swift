import Foundation

public struct Douban: Decodable {
    public var id: Int?
    
    public var name: String?
    
    // 别名
    public var en: String?
    
    public var url: String?
    
    public var image: String?
    
    public var pubDate: Date?
    
    public var year: Int?
    
    public var duration: String?
    
    public var description: String?
    
//    public var type: MediaType?
    
    public var aggregateRating: AggregateRating?
    
    public var genres: [Genre]?
    
    public var directors: [Director]?
    
    public var authors: [Author]?
    
    public var actors: [CastMember]?
    
    public var website: String?
    
    public var language: String?
    
    public var country: String?
    
    // 季数
    public var seasonNumber: Int?
    
    // 片长
    public var runtime: Int?
    
    public var episodeNumber: Int?
    // 一集的时长
    public var episodeDuration: Int?
    
    public var imdbId: String?
    
    public mutating func getId() -> Int? {
        if let id = id {
            return id
        }
        
        if let url = url {
            let components = url.components(separatedBy: "/").filter { $0.isEmpty == false }
            if let id = components.last {
                self.id = Int(id)
                return Int(id)
            }
        }
        
        return nil
    }
}


extension Douban {
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
    
    private enum MediaType: String, Codable, Equatable {
        case movie
        case tvSeries = "TVSeries"
        case book
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        let url = try container.decode(String.self, forKey: .url)
        self.url = url

        self.id = getId()
        
        image = try container.decode(String.self, forKey: .image)
        let pubDate = try container.decode(String.self, forKey: .pubDate)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.pubDate = formatter.date(from: pubDate)
        if let pubDate = self.pubDate {
            self.year = Calendar.current.component(.year, from: pubDate)
        }
        
        let durationString = try container.decode(String.self, forKey: .duration)
        duration = durationString
        runtime = parseDurationToMinutes(durationString: durationString)
        
        description = try container.decode(String.self, forKey: .description)
//        type = try container.decode(MediaType.self, forKey: .type)
        aggregateRating = try container.decode(AggregateRating.self, forKey: .aggregateRating)
        
        let genres = try container.decode([String].self, forKey: .genre)
        self.genres = genres.map { Genre(name: $0) }
        
        directors = try container.decode([Director].self, forKey: .director)
        authors = try container.decode([Author].self, forKey: .author)
        actors = try container.decode([CastMember].self, forKey: .actor)
    }
    
    func parseDurationToMinutes(durationString: String) -> Int? {
        // 如果字符串不以"PT"开头，则无法解析
        guard durationString.hasPrefix("PT") else {
            return nil
        }
        
        // 从字符串中提取小时和分钟
        var hourString = ""
        var minuteString = ""
        
        // 从第 2 个字符开始循环，跳过"PT"
        for char in durationString.dropFirst(2) {
            // 如果是数字，则追加到 hourString 或 minuteString 中
            if char.isNumber {
                if minuteString.isEmpty && hourString.isEmpty {
                    hourString.append(char)
                } else {
                    minuteString.append(char)
                }
            } else {
                // 如果遇到 "H"，则表示小时
                if char == "H" {
                    continue
                }
                // 如果遇到 "M"，则表示分钟
                if char == "M" {
                    break
                }
                // 如果遇到其他字符，则格式错误，无法解析
                return nil
            }
        }
        
        // 将小时和分钟转换为整数
        guard let hours = Int(hourString), let minutes = Int(minuteString) else {
            return nil
        }
        
        // 计算总的分钟数
        return hours * 60 + minutes
    }
    
    static func makeURL(path: String) -> String {
        if path.hasPrefix("movie.douban.com") {
            return path
        }
        
        // 将path 两边的 / 替换掉
        let path = path.replacingOccurrences(of: "/", with: "")
        return "https://movie.douban.com/\(path)/"
    }
}

extension Douban {
    mutating public func updateValue(_ value: String, forKey key: String) {
        switch key {
        case "name":
            name = value
        case "imdbId":
            imdbId = value
        case "en":
            en = value
        case "language":
            language = value
        case "country":
            country = value
        case "seasonNumber":
            seasonNumber = Int(value)
        case "episodeNumber":
            episodeNumber = Int(value)
        case "episodeDuration":
            episodeDuration = Int(value.replacingOccurrences(of: "分钟", with: ""))
        default:
            break
        }
    }
}
