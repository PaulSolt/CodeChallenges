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
    var dict: [Item.Key : Node<Item>] = [:] // O(1) lookup / insert
    var list = LinkedList<Item>() // O(1) removal of least recent item
    
    init(size: Int) {
        self.size = size
    }
    
    func read(_ key: Item.Key) -> Item? {
        guard let node = dict[key] else { return nil }
        
        // if exists, make most recent
        list.delete(node)
        list.append(node)
        return node.item
    }
    
    func write(_ item: Item) {
       // if exists, update it
        if let node = dict[item.key] {
            node.item = item
            
            // mark as most recent
            list.delete(node)
            list.append(node)
        } else {
            // Remove element if >= size
            if list.count >= size, let head = list.head {
                // remove from dict + list
                dict[head.item.key] = nil
                list.delete(head)
            }
            
            let node = Node(item)
            list.append(node)
            dict[item.key] = node
        }
        
        // append to list + dict
    }
}

class Node<Item> : Equatable {
    var next: Node<Item>?
    var prev: Node<Item>?
    var item: Item
    
    init(_ item: Item) {
        self.item = item
    }
    
    static func == (lhs: Node<Item>, rhs: Node<Item>) -> Bool {
        return lhs === rhs
    }
}

class LinkedList<Item> {
    var head: Node<Item>?
    var tail: Node<Item>?
    var count: Int = 0
    
    func append(_ node: Node<Item>) {
        if head == nil {
            head = node
        } else {
            tail?.next = node
            node.next = nil
            node.prev = tail
        }
        tail = node
        count += 1
    }
    
    func delete(_ node: Node<Item>) {
        node.prev?.next = node.next
        node.next?.prev = node.prev
        
        if head == node { head = head?.next }
        if tail == node { tail = tail?.prev }
        
        count -= 1
    }
}
