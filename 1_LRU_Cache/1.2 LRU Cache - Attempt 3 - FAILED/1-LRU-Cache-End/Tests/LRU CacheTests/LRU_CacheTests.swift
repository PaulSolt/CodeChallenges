import XCTest
@testable import LRU_Cache

final class LRU_CacheTests: XCTestCase {
    
    func testDoubleLinkedList() {
        
        let list = DoubleLinkedList<Int>()
        print("List: \(list)")
        
        let seven = Node(item: 7)
        list.insert(node: seven)
        
        print("\nInsert 7: \(list.description)")
        XCTAssertEqual(list.head?.item, 7) // 7
        
        list.insert(node: Node(item: 3))
        print("\nInsert 3: \(list.description)") // 7, 3
        
        list.insert(node: Node(item: 5))
        print("\nInsert 5: \(list.description)") // 7, 3, 5
        
        list.delete(node: seven)
        print("\nDelete 7: \(list.description)") // 3, 5
        
        list.insert(node: seven)
        print("\nInsert 7: \(list.description)") // 3, 5, 7
        
        XCTAssertEqual(list.count, 3)
        XCTAssertEqual(list.head?.item, 3)
        XCTAssertEqual(list.head?.next?.item, 5)
        XCTAssertEqual(list.tail?.item, 7)

    }
    
    func testLRUCache() throws {
        // Tests
        let cache = MyCache<Int>(size: 3)
        cache.write(2) // [2]
        cache.write(3) // [2, 3] (Most recent ==> right side)
        cache.write(4) // [2, 3, 4]
        
        XCTAssertEqual(cache.read(2), 2) // [3, 4, 2]
        XCTAssertEqual(cache.read(3), 3) // [4, 2, 3]
        XCTAssertEqual(cache.read(4), 4) // [2, 3, 4]
        
        cache.write (5) // 2 [3, 4, 5]
        
        XCTAssertEqual(cache.read(2), nil)
        XCTAssertEqual(cache.read(3), 3) // [4, 5, 3]
        XCTAssertEqual(cache.read(4), 4) // [5, 3, 4]
        XCTAssertEqual(cache.read(5), 5) // [3, 4, 5]
        
        // Verify that reading is a cache hit
        XCTAssertEqual(cache.read(3), 3) // [4, 5, 3]
        
        cache.write(7) // 4 [5, 3, 7] ===> 4 should be removed
        
        XCTAssertNil(cache.read(4))
        XCTAssertEqual(cache.read(3), 3)
    }
    
    func testLRUCacheWriteRead() throws {
        let cache = MyCache<Int>(size: 3)
        
        XCTAssertNil(cache.read(2)) // []
        
        cache.write(2) // [2]
        
        XCTAssertEqual(cache.read(2), 2) // [2]
    }
     
    func testLRUCacheWriteTwiceSameValue() throws {
        let cache = MyCache<Int>(size: 1)
        XCTAssertEqual(cache.size, 1)
        
        XCTAssertNil(cache.read(2)) // []
        
        cache.write(2) // [2]
        
        XCTAssertEqual(cache.read(2), 2) // [2]
        
        cache.write(2) // [2]
        
        XCTAssertEqual(cache.read(2), 2) // [2]
    }
}

