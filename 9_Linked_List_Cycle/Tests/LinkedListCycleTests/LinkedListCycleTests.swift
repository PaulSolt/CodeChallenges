import Testing
@testable import LinkedListCycle

@Test func example() async throws {
    // Write your test here and use APIs like `#expect(...)` to check expected conditions.
    
    // pos: -1, []
    // false

    let list = ListNodeBuilder.create([])
    let solution = Solution()
    #expect(solution.hasCycle(list) == false)
    
    
    //[3,2,0,-4]
    // pos: 1
    let list2 = ListNodeBuilder.create([3,2,0,-4])
    list2?.next?.next?.next?.next = list2?.next
    #expect(solution.hasCycle(list2) == true)

}



