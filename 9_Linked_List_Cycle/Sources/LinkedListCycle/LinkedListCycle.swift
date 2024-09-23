// The Swift Programming Language
// https://docs.swift.org/swift-book
/**
 * Definition for singly-linked list.

 */

public class ListNode {
    public var val: Int
    public var next: ListNode?
    
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

public class ListNodeBuilder {
    public init() {
        
    }
    
    public static func create(_ array: [Int]) -> ListNode? {
        var head: ListNode? = nil
        var current: ListNode? = nil
        
        for number in array {
            if head == nil {
                head = ListNode(number)
                current = head
            } else {
                current?.next = ListNode(number)
                current = current?.next
            }
        }
        return head
    }
}

 // Time complexity: O(n)
 // O(~2n) to loop around in worst case

class Solution {
    func hasCycle(_ head: ListNode?) -> Bool {
        var slowNode = head
        var fastNode = head

        while slowNode != nil {
            slowNode = slowNode?.next
            fastNode = fastNode?.next?.next

            if slowNode == nil && fastNode == nil {
                return false
            } else if slowNode === fastNode {
                return true
            }
        }
        return false
    }
}
