import XCTest
@testable import MergeTwoLists_End
/**
 * Definition for singly-linked list.
 */

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
    
    public init(_ values: [Int]) {
        val = -1
        guard let value = values.first else { fatalError("Invalid input") }
        self.val = value
        
        var current: ListNode? = self
        for index in 1..<values.count {
            let value = values[index]
            current?.next = ListNode(value)
            current = current?.next
        }
    }
}

extension ListNode: Equatable {
    
    
    public static func == (lhs: ListNode, rhs: ListNode) -> Bool {
        return compare2(lhs: lhs, rhs: rhs)
    }
    
    // Recursive compare function
    public static func compare(lhs: ListNode?, rhs: ListNode?) -> Bool {
        print("compare: \(lhs?.val ?? "nil" as Any) to \(rhs?.val ?? "nil" as Any)")
        if lhs == nil && rhs == nil {
            return true
        }
        if lhs == nil || rhs == nil {
            return false
        }
        
        if lhs?.val != rhs?.val {
            return false
        }
        return compare(lhs: lhs?.next, rhs: rhs?.next)
    }
    
    // Iterative compare function
    public static func compare2(lhs: ListNode?, rhs: ListNode?) -> Bool {
        if lhs == nil && rhs == nil {
            return true
        }
        if lhs == nil || rhs == nil {
            return false
        }
       
        var left = lhs
        var right = rhs
        
        // loop through all values and compare each time
        while left != nil {
            print("compare: \(left?.val ?? "nil" as Any) to \(right?.val ?? "nil" as Any)")
            if left?.val != right?.val {
                return false
            }
            left = left?.next
            right = right?.next
        }
        
        // compare right list's end to make sure there are not more nodes
        if right != nil {
            return false
        }
        return true
    }
}

func mergeTwoLists(_ list1: ListNode?, _ list2: ListNode?) -> ListNode? {
    // base cases
    // guard let list1, let list2 else { return nil }
    if list1 == nil && list2 != nil {
        return list2
    }
    if list1 != nil && list2 == nil {
        return list1
    }
    // Do at end? Then we don't need to dance aroudn it
    guard let head1 = list1, let head2 = list2 else { return nil }
    let head: ListNode?
    
    var node1: ListNode? = list1
    var node2: ListNode? = list2
    
    if head1.val > head2.val { // Can't compare Int? ???? HOW????
        head = list2
        node2 = node2?.next
        // head?.next = nil    // PITFALL make sure to do last ... (or skip?)
        // print("head2: \(head2.val)")
    } else {
        head = list1
        node1 = node1?.next
        // head?.next = nil // PITFALL make sure to do last ... (or skip?)
        // print("head1: \(head1.val)")
    }
    // TODO: Move list1 or list2 forward
    // print("head: \(toString(head) )")
    // while both lists node != nil append
    
    var current: ListNode? = head
    
    // Compare the current value
    // print("node1: \(toString(node1))")
    // print("node2: \(toString(node2))")
    while let n1 = node1, let n2 = node2 {
        // var next:
        
        // print("compare: \(n1.val) to \(n2.val)")
        if n1.val > n2.val {
            current?.next = node2
            
            node2 = node2?.next
            
            current = current?.next
            current?.next = nil
        } else { // node1 is smaller
            // let next = node1
            // node1 = node1?.next
            current?.next = node1
            node1 = node1?.next
            current = current?.next
            current?.next = nil
        }
    }
    
    
    // if either is nil, append the remainder from the other list
    if node1 != nil {
        // append remainder
        current?.next = node1
    }
    
    if node2 != nil {
        current?.next = node2
    }
    return head
}

func toString(_ node: ListNode?) -> String {
    guard node != nil else { return "nil" }
    var current = node
    var output = ""
    while current != nil {
        if let value = current?.val {
            output += current?.next != nil ? "\(value) -> " : "\(value)"
        }
        
        current = current?.next
    }
    return output
}

final class MergeTwoLists_EndTests: XCTestCase {
    func testMergeList() throws {
        
        let list1 = ListNode([1, 2, 4])
        let list2 = ListNode([1, 3, 4])
        
        let newList = mergeTwoLists(list1, list2)
        print(toString(newList))
        
        let expected = ListNode([1, 1, 2, 3, 4, 4])
        XCTAssertEqual(expected, newList)
        
    }
    
    func testMergeListLonger() throws {
        
        let list1 = ListNode([1, 2, 4])
        let list2 = ListNode([1, 3, 4, 5])
        
        let newList = mergeTwoLists(list1, list2)
        print(toString(newList))
        
        let expected = ListNode([1, 1, 2, 3, 4, 4, 5])
        XCTAssertEqual(expected, newList)
        
    }
    
    func testEqualLists() throws {
        XCTAssertNotEqual(ListNode([1]), ListNode([1, 2]))
    }

}
