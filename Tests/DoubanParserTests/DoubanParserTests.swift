import XCTest
@testable import DoubanParser

final class DoubanParserTests: XCTestCase {
    private lazy var fileURL = URL(fileURLWithPath: Bundle.module.path(forResource: "douban", ofType: "html")!)
    func testExample() async throws {
        do {
            let data = try await DoubanParser(data: Data(contentsOf: fileURL)).parse().get()
            XCTAssertNotNil(data)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
