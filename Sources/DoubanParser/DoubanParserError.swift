import Foundation

public enum ParserError: Error {
    case missingData
    case networkError
    case unexpectedError(error: Error)
}

extension ParserError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .missingData:
            return "No data returned from the server."
        case .networkError:
            return "The network request failed."
        case .unexpectedError(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
