
class BinarySearch {

    // Keep track of the leftmost edge and the right most edge.
    // We finish when these two values intersect (inclusive intersection)
    // If the midpoint is the target, we are finished, otherwise depending on the
    // direction we need to shift the left or right point to either side of the
    // midpoint and then recalculate a new midpoint

    // TODO: Edge cases to test, 0 elements, 1 element, 2 element, 3+
    func search(_ nums: [Int], _ target: Int) -> Int {
        var left = 0
        var right = nums.count - 1

        while left <= right {
            let midpoint = (left + right) / 2
            if nums[midpoint] == target {
                return midpoint
            } else if target > nums[midpoint] {
                left = midpoint + 1
            } else {
                right = midpoint - 1
            }
        }
        return -1
    }
}
