import Foundation

public struct Genre: Codable {
    public var name: String?
    
    public init(name: String? = nil) {
        self.name = name
    }
}
