import XCTest
@testable import LRU_Cache

final class LRU_CacheTests: XCTestCase {
    func testLRUCache() throws {
        // Tests
        let cache = MyCache<Int>(size: 3)
        cache.write(2) // [2]
        cache.write(3) // [2, 3] (Most recent ==> right side)
        cache.write(4) // [2, 3, 4]
        
        XCTAssertEqual(cache.read(2), 2) // [3, 4, 2]
        XCTAssertEqual(cache.read(3), 3) // [4, 2, 3]
        XCTAssertEqual(cache.read(4), 4) // [2, 3, 4]
        
        print(cache.list)
        
        cache.write (5) // 2 [3, 4, 5]
       
        print("write(5): \(cache.list)")
        XCTAssertEqual(cache.read(2), nil)
        XCTAssertEqual(cache.read(3), 3) // [4, 5, 3]
        XCTAssertEqual(cache.read(4), 4) // [5, 3, 4]
        XCTAssertEqual(cache.read(5), 5) // [3, 4, 5]
        
        // Verify that reading is a cache hit
        XCTAssertEqual(cache.read(3), 3) // [4, 5, 3]
        
        cache.write(7) // 4 [5, 3, 7] ===> 4 should be removed
        
        XCTAssertNil(cache.read(4)) // [5, 3, 7] ===> nil
        XCTAssertEqual(cache.read(3), 3) // [5, 7, 3]
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

