import XCTest
@testable import Valid_Parentheses

final class Valid_ParenthesesTests: XCTestCase {
    
    let pairs: [String : String] = [ "(" : ")", "{" : "}", "[" : "]" ]

    func isValid(_ s: String) -> Bool {
        var stack: [String] = Array<String>()
        print(s)
        for character in s {
            let element = String(character)
            if pairs[element] != nil { // open bracket, store it
                stack.append(element)
            } else {
                // pop and compare to see if matching
                if let previous = stack.popLast() {
                    if element != pairs[previous] { // Error: Mismatched pair
                        return false
                    }
                } else { // Error: No starting bracket on stack
                    return false
                }
            }
        }

        if !stack.isEmpty {
            return false
        }

        return true
    }
    
    func testExample() throws {
        
        XCTAssertEqual(isValid("[]()[]"), true)
        XCTAssertEqual(isValid("[]([]"), false)
        XCTAssertEqual(isValid("((()"), false)
        XCTAssertEqual(isValid("())"), false)
        XCTAssertEqual(isValid("[]([{}])[]"), true)

    }
}
