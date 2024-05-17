//
//  main.swift
//  Spiral
//
//  Created by Paul Solt on 5/16/24.
//

import Foundation

// Starter project to get size from Console or Command Line

print("Enter a size: ")
guard let line = readLine(), let maxSize = Int(line) else { fatalError("Unable to read input") }

guard maxSize > 0 else { fatalError("Invalid size") }

//let maxSize = 8
var row = Array<Int>(repeating: 0, count: maxSize)
var grid = Array<[Int]>(repeating: row, count: maxSize) // grid[y][x]

var direction = 0
var size = maxSize

func isValidMove(x: Int, y: Int, grid: [[Int]]) -> Bool {
    return x >= 0 && x < grid.count &&
    y >= 0 && y < grid.count &&
    grid[y][x] == 0
}

let maxValue = maxSize * maxSize
var value = 1
let dx = [1, 0, -1, 0] // clockwise [dx, dy] movement - always turn right
let dy = [0, 1, 0, -1]
var x = 0
var y = 0

while value <= maxValue {
    grid[y][x] = value
    printGrid(grid)
    
    let nextX = x + dx[direction]
    let nextY = y + dy[direction]

    if isValidMove(x: nextX,
                   y: nextY, grid: grid) {
        print("move to x: \(nextX), y: \(nextY)")
        x = nextX
        y = nextY
    } else {
        // turn right
        direction = (direction + 1) % 4 // only 4 turns
        print("turn: dx: \(dx[direction]), dy: \(dy[direction])")
        
        x += dx[direction]
        y += dy[direction]
    }

    
    value += 1
}




//printGrid(grid)

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
