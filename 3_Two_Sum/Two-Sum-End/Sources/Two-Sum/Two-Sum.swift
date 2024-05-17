// The Swift Programming Language
// https://docs.swift.org/swift-book
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var dict = [Int : Int]() // value : index
    for (index, num) in nums.enumerated() {
        if let otherIndex = dict[target - num] {
            return [index, otherIndex]
        }
        dict[num] = index
    }
    return []
}

