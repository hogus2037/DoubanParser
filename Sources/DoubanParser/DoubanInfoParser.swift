import Foundation
import SwiftSoup

public class DoubanInfoParser {
    private var docment: Document
    public var properties: [PropertyInfo] = []
    
    public init(docment: Document) {
        self.docment = docment
        
        self.properties = parse()
    }
    
    public var info: Element? {
        try? docment.getElementById("info")
    }
    
    public func parse() -> [PropertyInfo] {
        var infos = Set<PropertyInfo>()
        do {
            let spans = try info?.select("span")
            for element in spans?.array() ?? [] {
                if element.childNodeSize() == 1 {
                    let node = element.childNode(0)
                    let property = try node.outerHtml().replacingOccurrences(of: ":", with: "")
                    guard let key = PropertyInfoKey(rawValue: property) else { continue }
                    
                    let nextElementSibling = try element.nextElementSibling()
                    let value = try (nextElementSibling?.tagName() == "a" ? nextElementSibling?.text() : element.nextSibling()?.outerHtml())?.replacingOccurrences(of: ":", with: "")
                        .trimmingCharacters(in: .whitespacesAndNewlines)
                    if value?.isEmpty == true { continue }
                    infos.insert(.init(key: key, value: value))
                } else {
                    let property = try element.child(0).text().replacingOccurrences(of: ":", with: "")
                    let value = try element.children().select("a").map { try $0.text().trimmingCharacters(in: .whitespacesAndNewlines) }
                    guard !property.isEmpty, let key = PropertyInfoKey(rawValue: property) else { continue }
                    infos.insert(.init(key: key, value: value))
                }
            }
        } catch {
            print(error)
        }
        return Array(infos)
    }
    
    public func seasons() -> [TVSeason] {
        let seasonElement = try? info?.getElementById("season")
        var tvSeasons: [TVSeason] = []
        for season in seasonElement?.children().array() ?? [] {
            guard let seasonId = try? Int(season.attr("value")), let seasonNumber = try? Int(season.text()) else { continue }
            tvSeasons.append(.init(id: seasonId, seasonNumber: seasonNumber))
        }
        return tvSeasons
    }
    
    public func value<T>(_ key: PropertyInfoKey, of type: T.Type = String.self) -> T? {
        let value = values(key)?.first?.value
        return value as? T
    }
    
    public func values(_ key: PropertyInfoKey) -> [PropertyInfo]? {
        properties.filter { $0.key == key }
    }
    
    public func episodeDuration() -> Int? {
        let value = value(.episodeDuration)
        if let value {
            let duration = value.replacingOccurrences(of: "分钟", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
            return Int(duration)
        }
        
        return nil
    }
    
    public func alias() -> [String] {
        let alias = value(.alias) ?? ""
        return alias.components(separatedBy: "/").map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
