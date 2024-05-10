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
class MyCache<Item: CacheItem>: Cache {
    var size: Int
    var dict = [Item.Key : Node<Item>]()
    var list: DoubleLinkedList<Item>
    
    init(size: Int) {
        self.size = size
        self.list = DoubleLinkedList()
    }
    
    func read(_ key: Item.Key) -> Item? {
        // If item exists, mark it as recently seen
        if let node = dict[key] {
            makeMostRecent(node: node)
        }
        return dict[key]?.item
    }
   
    func write(_ item: Item) {
        // If key exists, update it using the new item value (and mark it as recently seen)
        if let node = dict[item.key] {
            node.item = item // update value of node
            makeMostRecent(node: node)
        } else {
            // Remove the head (least recently seen) if we are at max size
            if list.count >= size, let head = list.head {
                dict[head.item.key] = nil
                list.delete(node: head)
            }
           
            // Append to list and dictionary
            let node = Node(item: item)
            list.insert(node: node)
            dict[item.key] = node
        }
    }
    
    func makeMostRecent(node: Node<Item>) {
        list.delete(node: node)
        list.insert(node: node)
    }
}

class Node<Item: CacheItem>: CustomStringConvertible, Equatable {
    var item: Item
    var next: Node?
    weak var previous: Node? // PITFALL: prevent retain cycles
    
    init(item: Item, next: Node? = nil, previous: Node? = nil) {
        self.item = item
        self.next = next
        self.previous = previous
    }
   
    static func == (lhs: Node<Item>, rhs: Node<Item>) -> Bool {
        return lhs.item == rhs.item && lhs.next === rhs.next && lhs.previous === rhs.previous
    }
   
    // Recursive description with a base case
    var description: String {
        guard let next else { return "\(item)" }
        return "\(item) -> \(next)"
    }
}

class DoubleLinkedList<Item: CacheItem> : CustomStringConvertible {
    var head: Node<Item>? // oldest
    var tail: Node<Item>? // most recent
    var count: Int = 0
 
    func delete(node: Node<Item>) {
        if (node == head) {
            head = head?.next
            head?.previous = nil
        } else {
            node.previous?.next = node.next
            node.next?.previous = node.previous
        }
        count -= 1
    }
    
    func insert(node: Node<Item>) {
        if head == nil {
            head = node
        } else {
            // Append to tail
            tail?.next = node
            node.previous = tail
            node.next = nil // PITFALL: set both pointers! (cycle if delete/reinsert previous node)
        }
        tail = node
        count += 1
    }
   
    var description: String { // Make Node CustomStringConvertible
        var output = "head: \(head?.item.description ?? "nil"), tail: \(tail?.item.description ?? "nil")"
        output += "\n\t" + (head?.description ?? "nil")
        return output
    }
}
