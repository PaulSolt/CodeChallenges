//
//  main.swift
//  Spiral
//
//  Created by Paul Solt on 5/16/24.
//

import Foundation

// Starter project to get size from Console or Command Line

print("Enter a size: ")
//guard let line = readLine(), let maxSize = Int(line) else { fatalError("Unable to read input") }

//guard maxSize > 0 else { fatalError("Invalid size") }

let maxSize = 3
var row = Array<Int>(repeating: 0, count: maxSize)
var grid = Array<[Int]>(repeating: row, count: maxSize)
//grid[0][0] = 1
//grid[0][1] = 2 // grid[y][x]

enum Direction {
    case right, down, left, up
    
    func nextDirection(_ direction: Direction) -> Direction {
        switch direction {
        case .right: return .down
        case .down: return .left
        case .left: return .up
        case .up: return .right
        }
    }
}

var direction = Direction.right
var size = maxSize

if size == 1 {
    grid[0][0] = 1
} else if size >= 2 {
    
}


var value = 1

while size - 2 > 0 {
    var startRow = 0 // TODO: Inset on each completion
    var startCol = 0
    for x in startCol ..< size {
        let i = startRow
        let j = startCol + x
        print("\(i), \(j): \(value)")
        grid[i][j] = value
        value += 1
//        print(x)
    }
    startRow += 1
    size -= 1
    
    for y in 0 ..< size {
        let i = startRow + y
        let j = startCol + size
        print("\(i), \(j): \(value)")
        grid[i][j] = value
        value += 1
    }
    
    for x in startCol ..< size {
        let i = startCol + size - 1 - x
        let j = startRow + size - 1
        print("\(i), \(j): \(value)")
        grid[i][j] = value
        value += 1
    }
    
    for y in 0 ..< size {
        let i = 2
        let j = 1
        print("\(i), \(j): \(value)")
    }
    
    size -= 1
}

printGrid(grid)

func printGrid(_ grid: [[Int]]) {
    var output = ""
    for row in grid {
        for number in row {
            output += "\(number)\t"
        }
        output += "\n"
    }
    print(output)
}
