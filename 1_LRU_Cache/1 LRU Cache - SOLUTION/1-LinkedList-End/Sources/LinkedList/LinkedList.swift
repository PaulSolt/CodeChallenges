import Foundation

// TODO: Implement LinkedList<Item> with Node<Item> using generics
// 1. Store the count of nodes
// 2. Add a description for debug printing
// 3. Implement methods:
//      append(_ node: Node<Item>) O(1)
//      delete(_ node: Node<Item>) O(n)
// 4. Verify all unit tests pass

class Node<Item> : Equatable, CustomStringConvertible {
    var item: Item
    var next: Node<Item>?
    
    init(_ item: Item) {
        self.item = item
    }
    
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs === rhs // PITFALL: Use === not == for pointer comparisons
    }
    
    var description: String {
        guard let next else { return "\(item)" }
        return "\(item) -> \(next)"
    }
}

class LinkedList<Item>: CustomStringConvertible {
    var head: Node<Item>?
    var tail: Node<Item>?
    var count: Int = 0
    
    func delete(_ node: Node<Item>) {
        var current = head
        
        // look for the node before the node we want to remove
        while let next = current?.next {
            if node == next {
                // delete value by assigning to the next node
                current?.next = next.next
                break
            }
            current = next
        }
        
        // Adjust head, tail, and count
        if node == head { head = head?.next }
        if node == tail { tail = current }
        
        count -= 1
    }
    
    func append(_ node: Node<Item>) {
        if head == nil {
            head = node
            tail = node
        } else { // append to tail
            tail?.next = node
            tail = node
            node.next = nil // PITFALL: Avoid a cycle
        }
        count += 1
    }
    
    var description: String {
        "head: \(head?.item ?? "nil" as Any), tail: \(tail?.item ?? "nil" as Any)\n\thead -> \(head ?? "nil" as Any)" // TODO: Cleanup warnings with ?? and Any
    }
}
