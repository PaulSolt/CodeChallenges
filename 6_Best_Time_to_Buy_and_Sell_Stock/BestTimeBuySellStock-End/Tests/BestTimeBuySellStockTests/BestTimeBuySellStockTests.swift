import XCTest
@testable import BestTimeBuySellStock

func maxProfit(_ prices: [Int]) -> Int {
    guard prices.count > 0 else { return 0 }
    
    var min: Int = .max
    var max: Int?
    var maxProfit: Int?
    
    for price in prices {
        if price < min {
            min = price
        } else if max == nil {
            max = price
            maxProfit = price - min
        } else if let previousMax = max,
                  let previousProfit = maxProfit, price - min > previousProfit {
//            let previousProfit = maxProfit, price - min > previousProfit,
//                  let maxProfit = price - min { // Error: 2
//            let maxProfit {  // Error 1: unwrapping masks previous local value (how do I get access to it?)
            max = price
            maxProfit = price - min
            // Error 1: error: cannot assign to value: 'maxProfit' is a 'let' constant in solution.swift
            // maxProfit = price - min
            
            // Error 2: error: initializer for conditional binding must have Optional type, not 'Int' in solution.swift
            // let maxProfit = price - min {
        }
    }
    return if let maxProfit { maxProfit } else { 0 }
}

final class BestTimeBuySellStockTests: XCTestCase {
    func testExample() throws {
        XCTAssertEqual(5, maxProfit([7,1,5,3,6,4]))
        XCTAssertEqual(0, maxProfit([7,6,4,3,1]))
        XCTAssertEqual(4, maxProfit([7,0,4,3,1]))
    }
}
