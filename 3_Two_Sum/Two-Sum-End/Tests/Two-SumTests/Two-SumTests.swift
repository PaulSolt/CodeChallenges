import XCTest
@testable import Two_Sum

final class Two_SumTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual([0, 2].sorted(), twoSum([2, 3, 4], 6).sorted())

    }
}
