import XCTest
@testable import BinarySearch_End

final class BinarySearch_EndTests: XCTestCase {
    func testSearch() throws {
        let binary = BinarySearch()
        XCTAssertEqual(binary.search([], 27), -1)
        XCTAssertEqual(binary.search([1], 27), -1)
        XCTAssertEqual(binary.search([1], 1), 0)
        XCTAssertEqual(binary.search([1, 7], 3), -1)
        XCTAssertEqual(binary.search([1, 3], 3), 1)
        XCTAssertEqual(binary.search([3, 7], 3), 0)
        
        
    }
}
