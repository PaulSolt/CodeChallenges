import Foundation
/// An item we can place in our cache.
protocol CacheItem: Equatable, CustomStringConvertible {
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
// Read/Write: O(1)
class MyCache<Item: CacheItem>: Cache {
    let size: Int
    var dict = [Item.Key : Node<Item>]()
    var list = DoubleLinkedList<Item>()
    
    init(size: Int) {
        self.size = size
    }
    
    func read(_ key: Item.Key) -> Item? {
        if let node = dict[key] {
            list.delete(node: node)
            list.insert(node: node)
        }
        return dict[key]?.item
    }
    
    func write(_ item: Item) {
        // Item exists
        if let node = dict[item.key] {
            node.item = item
            list.delete(node: node)
            list.insert(node: node)
        } else { // Add a new item
            
            // Remove the least recently used item if over limit
            if list.count >= size, let head = list.head {
                dict[head.item.key] = nil
                list.delete(node: head)
            }
            
            // New item
            let node = Node(item: item)
            dict[item.key] = node
            list.insert(node: node)
        }
    }
}

class Node<Item: CacheItem> : Equatable, CustomStringConvertible {
    var item: Item
    var next: Node<Item>?
    weak var previous: Node<Item>? // Prevent retain cycles
    
    init(item: Item) {
        self.item = item
    }
    
    static func == (lhs: Node<Item>, rhs: Node<Item>) -> Bool {
        return lhs.item == rhs.item && lhs.next === rhs.next && lhs.previous === rhs.previous // Pitfall for stack frame crash
    }
    
    var description: String {
        guard let next else { return "\(item)" }
        return "\(item) -> " + next.description
    }
}

class DoubleLinkedList<Item: CacheItem> : CustomStringConvertible {
    var head: Node<Item>?
    var tail: Node<Item>?
    var count: Int = 0
    
    func insert(node: Node<Item>) {
        if head == nil {
            head = node
        } else {
            // tail - we append
            tail?.next = node
            node.previous = tail
            node.next = nil // Pitfall: avoid a delete/insert cycle!
        }
        tail = node
        count += 1
    }
    
    func delete(node: Node<Item>) {
        // head - it becomes head
        if node == head {
            head = head?.next
            head?.previous = nil
        } else {
            let next = node.next
            let previous = node.previous
            previous?.next = next
            next?.previous = previous
        }
        count -= 1
    }
    
    var description: String {
        var output = "head: \(head?.item.description ?? "nil"), tail: \(tail?.item.description ?? "nil")"
        output += "\n\t" + (head?.description ?? "nil")
        return output
    }
}
