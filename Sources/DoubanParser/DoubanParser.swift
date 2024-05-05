import Foundation
import SwiftSoup

public class DoubanParser {
    private var data: Data?
    private var url: URL?
    
    public init(data: Data) {
        self.data = data
    }
    
    public init(url: URL) {
        self.url = url
    }
    
    public func parse() async -> Result<Media?, ParserError> {
        if let url = url {
            do {
                data = try await download(url)
            } catch {
                return .failure(error as! ParserError)
            }
        }
        
        guard let data = data, let html = String(data: data, encoding: .utf8) else {
            return .failure(.missingData)
        }
        
        do {
            let doc = try SwiftSoup.parse(html)
            let douban: Media? = parseJSON(document: doc)
            return .success(douban)
        } catch {
            return .failure(.missingData)
        }
    }
    
    private func parseJSON(document: Document) -> Media? {
        do {
            let script = try document.select("script[type=application/ld+json]").first()
            guard let script, let data = script.data().data(using: .utf8) else {
                return nil
            }
            
            var media = try JSONDecoder().decode(Media.self, from: data)
            
            let property = DoubanPropertyParser(docment: document)
            let info = DoubanInfoParser(docment: document)
            
            switch media {
            case .movie(var movie):
                if let summary = property.summary("link-report-intra") {
                    movie.description = summary
                }
                movie.runtime = property.runtime()
                movie.imdbId = info.value(.imdbId)
                movie.alias = info.alias()
                movie.country = info.value(.country)
                movie.language = info.value(.language)
                movie.website = info.value(.website)
                
                media = .movie(movie)
            case .tvSeries(var tvSeries):
                if let summary = property.summary("link-report-intra") {
                    tvSeries.description = summary
                }
                
                tvSeries.imdbId = info.value(.imdbId)
                tvSeries.alias = info.alias()
                tvSeries.country = info.value(.country)
                tvSeries.language = info.value(.language)
                tvSeries.episodeRunTime = info.episodeDuration()
                let seasons = info.seasons()
                tvSeries.seasons = seasons
                tvSeries.seasonNumber = seasons.count 
                tvSeries.episodeNumber = Int(info.value(.episodeNumber)!)
                
                media = .tvSeries(tvSeries)
            case .book(var book):
                book.image = property.value(.image)
                book.description = property.summary("link-report")
                let average = property.value(.average)
                let best = property.value(.best)
                let votes = property.value(.votes)
                book.aggregateRating = AggregateRating(ratingValue: average, ratingCount: votes, bestRating: best)
                
                book.publisher = info.value(.publisher)
                book.subtitle = info.value(.subtitle)
                book.translator = info.value(.translator, of: [String].self)
                let pubYear = info.value(.pubYear)
                if let pubYear, !pubYear.isEmpty {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM"
                    book.pubDate = dateFormatter.date(from: pubYear)
                }
                
                book.pages = Int(info.value(.pages)!)
                book.price = Double(info.value(.price)!)
                book.binding = info.value(.binding)
                book.producer = info.value(.producer)
                book.series = info.value(.series)
                book.originalTitle = info.value(.originalTitle)
                
                media = .book(book)
            }
            
            return media
        } catch {
            print(error)
            return nil
        }
    }
    
    public func download(_ url: URL) async throws -> Data? {
        var request = URLRequest(url: url)
        request.setValue("Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/107.0.0.0 Safari/537.36", forHTTPHeaderField: "User-Agent")
        (data, _) = try await URLSession.shared.data(for: request)
        
        return data
    }
}
