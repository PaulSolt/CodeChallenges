import XCTest
@testable import LinkedList

final class LinkedListTests: XCTestCase {
    
    func testLinkedList_addAndDeleteOneNode() {
        
        let list = LinkedList<Int>()
        print("List: \(list)")
        
        let seven = Node(7)
        list.append(seven)
        
        print("\nInsert 7: \(list)")
        XCTAssertEqual(list.head?.item, 7) // 7
        XCTAssertEqual(list.count, 1)
        
        list.delete(seven)
        
        print("\nDelete 7: \(list)")
        XCTAssertNil(list.head?.item) // nil
        XCTAssertEqual(list.count, 0)
    }
    
    func testLinkedList_addAndDelete() {
        let list = LinkedList<Int>()
        let seven = Node(7)
        list.append(seven) // 7
        
        list.append(Node(3))
        print("\nInsert 3: \(list)") // 7, 3
        
        list.append(Node(5))
        print("\nInsert 5: \(list)") // 7, 3, 5
        
        list.delete(seven)
        print("\nDelete 7: \(list)") // 3, 5
        
        list.append(seven)
        print("\nInsert 7: \(list)") // 3, 5, 7
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.head?.item, 3)
        XCTAssertEqual(list.head?.next?.item, 5)
        XCTAssertEqual(list.tail?.item, 7)
    }

    func testLinkedList_deleteHead() {
        let list = LinkedList<Int>()
        let seven = Node(7)
        let five = Node(5)
        list.append(seven) // 7
        list.append(Node(3)) // 7, 3
        list.append(five) // 7, 3, 5
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.head?.item, 7)
        XCTAssertEqual(list.head?.next?.item, 3)
        XCTAssertEqual(list.head?.next?.next?.item, 5)
        XCTAssertEqual(list.tail?.item, 5)
        
        list.delete(seven)
        
        XCTAssertEqual(list.count, 2)
        
        XCTAssertEqual(list.head?.item, 3) // 3, 5, nil
        XCTAssertEqual(list.head?.next?.item, 5)
        XCTAssertEqual(list.head?.next?.next, nil)
        
        XCTAssertEqual(list.tail, five)
   }
    
    func testLinkedList_deleteTail() {
        let list = LinkedList<Int>()
        let seven = Node(7)
        let three = Node(3)
        let five = Node(5)
        list.append(seven)
        list.append(three)
        list.append(five) // 7, 3, 5
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.head?.item, 7)
        XCTAssertEqual(list.head?.next?.item, 3)
        XCTAssertEqual(list.head?.next?.next?.item, 5)
        XCTAssertEqual(list.tail?.item, 5)
        
        print("head: \(list.head ?? "nil" as Any)")
        print("tail: \(list.tail ?? "nil" as Any)")
        
        list.delete(five) // 7, 3
        
        print("head: \(list.head ?? "nil" as Any)")
        print("tail: \(list.tail ?? "nil" as Any)")
        
        XCTAssertEqual(list.count, 2)
        
        XCTAssertEqual(list.head?.item, 7) // 7, 3 -> nil
        XCTAssertEqual(list.head?.next?.item, 3)
        XCTAssertEqual(list.head?.next?.next, nil)
        
        XCTAssertEqual(list.tail?.item, 3)
   }
}

