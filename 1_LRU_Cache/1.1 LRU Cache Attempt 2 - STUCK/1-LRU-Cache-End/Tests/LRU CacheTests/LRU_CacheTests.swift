import XCTest
@testable import LRU_Cache






final class LRU_CacheTests: XCTestCase {
    
    func testLRUCacheWriteRead() throws {
        let cache = MyCache<Int>(size: 3)
        
        XCTAssertNil(cache.read(2))
        
        cache.write(2)
        
        XCTAssertEqual(cache.read(2), 2)
    }
     
    func testLRUCacheWriteTwiceSameValue() throws {
        let cache = MyCache<Int>(size: 1)
        XCTAssertEqual(cache.size, 1)
        
        XCTAssertNil(cache.read(2))
        
        cache.write(2)
        
        XCTAssertEqual(cache.read(2), 2)
        
        cache.write(2)
        
        XCTAssertEqual(cache.read(2), 2)
    }
    
    func testLRUCache() throws {
        // Tests
        let cache = MyCache<Int>(size: 3)
        cache.write(2)
        cache.write(3)
        cache.write(4)

        XCTAssertEqual(cache.read(2), 2)
        XCTAssertEqual(cache.read(3), 3)
        XCTAssertEqual(cache.read(4), 4)
        
        cache.write(5)

        XCTAssertNil(cache.read(2)) // Last accessed from a read/write, size is 3
        
        XCTAssertEqual(cache.read(5), 5)
        XCTAssertEqual(cache.read(4), 4)
        XCTAssertEqual(cache.read(3), 3)
        
        XCTAssertEqual(cache.read(4), 4) // Remove + reinsert
        
        cache.write(7)
        // OLD <--> NEW
        // 5 4 3
        // read 4
        // 5 3 4
        // insert 7
        // 5 [3 4 7] // 5 is dropped
        
        print("Cache: \(cache.list.toString())")
        XCTAssertNil(cache.read(5))
        print("Cache: \(cache.list.toString())")
    }
}
