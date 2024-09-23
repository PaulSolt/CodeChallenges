//
//  main.swift
//  BalancedBinaryTree
//
//  Created by Paul Solt on 9/23/24.
//

import Foundation

print("Hello, World!")

//https:leetcode.com/problems/balanced-binary-tree/

/**
 * Definition for a binary tree node.
 
 
 */

public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

class Solution {
    func isBalanced(_ root: TreeNode?) -> Bool {
        guard let root else { return true }
        
        return heightBalanced(root).balanced
    }
    
    // We need to verify that every level is balanced at each stage of the tree
    // traversal. Use named tuple values so that the algorithm is easier to
    // read.
    func heightBalanced(_ node: TreeNode?) -> (height: Int, balanced: Bool) {
        guard let node else {
            return (0, true)
            // if node == nil {
            // return (0, true)
        }
        
        let (leftHeight, leftBalanced) = heightBalanced(node.left)
        let (rightHeight, rightBalanced) = heightBalanced(node.right)
        let height = max(leftHeight, rightHeight) + 1
        
        if abs(leftHeight - rightHeight) > 1 ||
            !(leftBalanced && rightBalanced) {
            return (height, false)
        }
        return (height, true)
    }
}

// Not Full: [1,2,2,3,null,null,3,4,null,null,4]


//class BinaryTreeBuilder {
//    func buildTree(_ elements: [Int?]) -> TreeNode? {
//        guard !elements.isEmpty else { return nil }
//        
//        var index = 0
//        return buildTreeHelper(elements, &index)
//    }
//    
//    private func buildTreeHelper(_ elements: [Int?], _ index: inout Int) -> TreeNode? {
//        guard index < elements.count else { return nil }
//        
//        guard let val = elements[index] else {
//            index += 1
//            return nil
//        }
//        
//        let node = TreeNode(val)
//        index += 1
//        node.left = buildTreeHelper(elements, &index)
//        index += 1
//        node.right = buildTreeHelper(elements, &index)
//        
//        return node
//    }
//}

class BinaryTreeBuilder {
    func buildTree(_ elements: [Int?]) -> TreeNode? {
        return buildTreeHelper(elements, 0)
    }
    
    private func buildTreeHelper(_ elements: [Int?], _ index: Int) -> TreeNode? {
        // Check if the index is out of bounds or the element is nil
        if index >= elements.count || elements[index] == nil {
            return nil
        }
        
        // Create the current node
        let node = TreeNode(elements[index]!)
        
        // Calculate the indices for the left and right children
        let leftIndex = 2 * index + 1
        let rightIndex = 2 * index + 2
        
        // Recursively build the left and right subtrees
        node.left = buildTreeHelper(elements, leftIndex)
        node.right = buildTreeHelper(elements, rightIndex)
        
        return node
    }
}


// Example Test Case
let elements: [Int?] = [1, 2, 2, 3, nil, nil, 3, 4, nil, nil, 4]
let treeBuilder = BinaryTreeBuilder()
if let root = treeBuilder.buildTree(elements) {
    let solution = Solution()
    let isTreeBalanced = solution.isBalanced(root)
    print("Is the tree balanced? \(isTreeBalanced)")
} else {
    print("The tree is empty.")
}

let solution = Solution()


let test2Array = [3,9,20,nil,nil,15,7]
let test2 = treeBuilder.buildTree(test2Array) // true
print("Is balanced? \(test2Array): \(solution.isBalanced(test2))")
