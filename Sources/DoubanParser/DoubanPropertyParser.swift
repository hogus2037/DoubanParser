import Foundation
import SwiftSoup

public class DoubanPropertyParser {
    public var docment: Document
    public var properties: [Property] = []
    
    public init(docment: Document) {
        self.docment = docment
        
        self.properties = parse()
    }
    
    public func parse() -> [Property] {
        var properties: [Property] = []
        let elements = try? docment.select("[property]")
        properties += elements?.compactMap{ element in
            guard let property = try? element.attr("property"), let key = PropertyKey(rawValue: property) else {
                return nil
            }
            let content = try? element.attr("content")
            if let content, !content.isEmpty {
                return Property(key: key, value: content)
            }
            
            let text = try? element.text()
            return Property(key: key, value: text)
        } ?? []
        
        return properties
    }
    
    public func value(_ key: PropertyKey) -> String? {
        properties.first { $0.key == key }?.value
    }
    
    public func values(_ key: PropertyKey) -> [String]? {
        properties.filter { $0.key == key }.map { $0.value ?? "" }
    }
    
    public func runtime() -> Int? {
        value(.runtime).flatMap(Int.init)
    }
    
    public func duration() -> Int? {
        value(.duration).flatMap(Int.init)
    }
    
    public func summary(_ id: String) -> String? {
        let element = try? docment.getElementById(id)
        // check if it's a short summary
        if element?.children().hasClass("short") == true {
            return try? element?.getElementsByClass("all").first()?.text()
        }
        
        return value(.summary)
    }
}
