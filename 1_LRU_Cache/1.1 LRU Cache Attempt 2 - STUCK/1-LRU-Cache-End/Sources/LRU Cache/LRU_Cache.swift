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
    let list: List<Item>
    
    init(size: Int) {
        self.size = size
        self.list = List<Item>(maxSize: size)
    }
    
    func read(_ key: Item.Key) -> Item? {
        list.read(key)
    }

    func write(_ item: Item) {
        list.write(item: item)
    }
}

// Takeaways: 1 hour 22 minutes to solve! YIKES!
// Order of operations
// Functional cache without expiration if we started with the dictionary
// Unfunctional cache by starting with the queue like implementation
// Can I move the dictionary into the list data structure? (Refactor?)

class Node<Item: CacheItem> {
    var key: Item.Key
    var item: Item
    var next: Node?
    weak var previous: Node? // prevent retain cycle
    
    // WHY: init(key: CacheItem.Key, item: CacheItem, next: Node? = nil) { // build error?
    // Cannot access associated type 'Key' from 'CacheItem'; use a concrete type or generic parameter base instead
//    init(key: CacheItem.Key, item: CacheItem, next: Node? = nil) {
    init(key: Item.Key, item: Item, previous: Node? = nil, next: Node? = nil) {
        self.key = key
        self.item = item
        self.previous = previous
        self.next = next
    }
}

class List<Item: CacheItem> {
    var head: Node<Item>?
    var tail: Node<Item>?
    var count: Int = 0
    var maxSize: Int
    var dict: [Item.Key : Node<Item>]

    init(maxSize: Int) {
        assert(maxSize >= 1, "Size must be >= 1")
        self.maxSize = maxSize
        dict = [Item.Key : Node<Item>]()
    }
    
    func insert(item: Item) -> Node<Item> {
        print("Insert: \(item): \(toString())")
        print("\thead PRE:  \(String(describing: head?.item)), tail: \(String(describing: tail?.item))")
        // always insert tail, remove from head
        if head == nil {
            print("BASE Case: Insert 1st node")
            // base case
            let node = Node(key: item.key, item: item)
            head = node
            tail = head
            print("\tPRE  Thead: \(String(describing: head?.item)), tail: \(String(describing: tail?.item))")
            dict[item.key] = node
            return node
        }
        if let node = dict[item.key] {
            // Already exists
            node.item = item // Update item
            print("UPDATE item on insert, node already exists")
            return node
        }
        let node = Node(key: item.key, item: item, previous: tail)
        print("Insert Tail: \(node.item)")
        tail?.next = node
        tail = node
        count += 1
        print("toString: \(toString())")
        print("DICT: \(dict.keys)")
        print("\tPOST head: \(String(describing: head?.item)), tail: \(String(describing: tail?.item))")
        
        dict[item.key] = node
        // check size
        if count >= maxSize {
            print("OVER MAX SIZE")
            // remove head from dictionary
            if let key = head?.key { // Remove dictionary entry for head
                print("REMOVE HEAD: \(key)")
                dict[key] = nil
            }
            // Remove from list
            head = head?.next
            head?.previous = nil // clear reference to previous head
            print("POST REMOVE: \(toString())")
            print("DICT: \(dict.keys)")
            count -= 1
        }
        return node
    }
    
    func read(_ key: Item.Key) -> Item? {
        print("Read: \(toString())")
        print("DICT: \(dict.keys)")
        if let node = dict[key] {
            print("Delete/Insert Node for cache hit: \(key)")
            delete(key)
//            write(item: node.item)// fixme: use insert, not write
            let node = insert(item: node.item)
            return node.item
        }
        return nil
//        return dict[key]?.item
    }
    
    func write(item: Item) {
//    func write(_ node: Node<Item>) {

//        if let node = dict[item.key] { // Don't duplicate value if already cached
//            print("ITEM Exists: Update it")
//            delete(item.key)
//            
//            insert(item: item) // TODO: Refactor (same as logic below)
//            node.item = item // Update node's verison of item
////            dict[item.key] = item // Update item stored (version: v1, v2, v3)
//            dict[item.key] = node
////            print("list.count: \(count) >= \(maxSize)")
//            return
//        }
        
        let node = insert(item: item)
//        dict[item.key] = node // FIXME: by moving these together, this created a problem, we're going to manage inside insert, but i really want to extract it back to how they were separated. This is a lot harder to test now.
    }
    
    func delete(_ key: Item.Key) {
        // double linked list ... get previous and update
        if let node = dict[key] {
            if head?.key == node.key { // node.previous == nil { // head
                head = node.next
            }
            else if tail?.key == node.key { //node.next == nil { // tail
                tail = node.previous
            }
           // FIXME: Paul is this correct?
            else if let previous = node.previous {
                previous.next = node.next
            }
            
            // decrease count
            count -= 1
        }
    }
    
    func find(key: Item.Key) -> Item? {
        var current = head
        while current != nil { // O(n) to find
            if current?.key == key {
                return current?.item
            }
            current = current?.next
        }
        return nil
    }
    
    func toString() -> String {
        var current = head
        var output = ""
        while current != nil {
            if let current, current.next != nil {
                output += "\(current.item), "
            } else if let current {
                output += "\(current.item)"
            }
            current = current?.next
        }
        return output
    }
}
