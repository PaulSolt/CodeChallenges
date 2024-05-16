import Foundation
/// An item we can place in our cache.
//protocol CacheItem: Equatable, CustomStringConvertible {
protocol CacheItem: CustomStringConvertible {
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
    var list: LinkedList<Item>
    
    init(size: Int) {
        self.size = size
        self.list = LinkedList()
    }
    
    func read(_ key: Item.Key) -> Item? {
        // If item exists, mark it as recently seen
        if let node = dict[key] {
            makeMostRecent(node)
        }
        return dict[key]?.item
    }
   
    func write(_ item: Item) {
        // If key exists, update it using the new item value (and mark it as recently seen)
        if let node = dict[item.key] {
            node.item = item // update value of node
            makeMostRecent(node)
        } else {
            // Remove the head (least recently seen) if we are at max size
            if list.count >= size, let head = list.head {
                dict[head.item.key] = nil
                list.delete(head)
            }
           
            // Append to list and dictionary
            let node = Node(item: item)
            list.append(node)
            dict[item.key] = node
        }
    }
    
    func makeMostRecent(_ node: Node<Item>) {
        list.delete(node)
        list.append(node)
    }
}

class Node<Item: CacheItem>: CustomStringConvertible, Equatable {
    var item: Item
    var next: Node?
    weak var prev: Node? // PITFALL: Prevent retain cycles using weak
    
    init(item: Item) {
        self.item = item
    }
   
    // Recursive description with a base case
    var description: String {
        guard let next else { return "\(item)" }
        return "\(item) -> \(next)"
    }
    
    static func == (lhs: Node<Item>, rhs: Node<Item>) -> Bool {
        return lhs === rhs // PITFALL: Use === not ==
    }
}

class LinkedList<Item: CacheItem> : CustomStringConvertible {
    var head: Node<Item>? // oldest
    var tail: Node<Item>? // most recent
    var count: Int = 0
 
    func delete(_ node: Node<Item>) {
        // Remove the node
        node.prev?.next = node.next  // INSIGHT: To delete we need a Doubly Linked List
        node.next?.prev = node.prev
        
        // If needed, update head/tail pointers
        if node == head { head = head?.next }   // PITFALL: Can lead to unexpected state
        if node == tail { tail = tail?.prev }
        
        count -= 1
    }
    
    func append(_ node: Node<Item>) {
        if head == nil {
            // Base case
            head = node
        } else {
            // Append to tail
            tail?.next = node
            
            // Update pointers
            node.prev = tail
            node.next = nil // PITFALL: Can create a cycle if delete/append the previous node
        }
        tail = node
        count += 1
    }
   
    var description: String {
        var output = "head: \(head?.item.description ?? "nil"), tail: \(tail?.item.description ?? "nil")"
        output += "\n\t" + (head?.description ?? "nil")
        return output
    }
}
