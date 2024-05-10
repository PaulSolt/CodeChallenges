import Foundation
/// An item we can place in our cache.
protocol CacheItem {
    /// A Hashable type we can use to identify this item.
    associatedtype Key: Hashable
    /// The key associated with this item.
    var key: Key { get }
    
}

/// The interface for the cache.
protocol Cache {
    associatedtype Item: CacheItem
    /// The size of the cache.
    var size: Int { get }
    /// Read an item from the cache given a key.
    func read(_ key: Item.Key) -> Item?
    
    /// Write an item into the cache.
    func write(_ item: Item)
}

// Let's start with some simple items we can store.
// For this example, Strings and Ints can be stored using themselves as a key.
extension String: CacheItem {
    var key: String { self }
}
extension Int: CacheItem {
    var key: Int { self }
}
    // How performant can we make this cache?
class MyCache<Item: CacheItem>: Cache {
    let size: Int
    
    init(size: Int) {
        self.size = size
    }
    
    func read(_ key: Item.Key) -> Item? {
        // TODO: Implement this
        nil
    }
    
    func write(_ item: Item) {
        // TODO: Implement this
        
    }
}


