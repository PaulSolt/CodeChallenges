# LRU Cache Trick

1. You need to use a Dictionary for O(1) insert and lookup
2. You need to use a Double Linked List for O(1) removal (head and tail pointers)
3. Store Nodes in the Dictionary so you can remove them in O(1)
4. Reading or Writing is a "Cache Hit" so you need to mark it as recently used.
5. Start with caching and then enhance with logic to track the most recent.
6. It may be helpful to insert and delete `Node`'s into your list.

## Pitfalls

1. Prevent retain cycles by making your Double Linked List `Node`'s `previous` a `weak` variable.
2. Watch out for a infinite loop if you delete and re-insert the same `Node`. It is easy to create a cycle that will hang. 
	1. Reset both `previous` and `next` values on every insertion. 

## Fundamental Skills Required (Practice) 

* Dictionary
* Double Linked List
    * Insert / Delete
* [Protocols and Associated Types](https://www.hackingwithswift.com/articles/74/understanding-protocol-associated-types-and-their-constraints)
* Generics (see above)
* CustomStringConvertible
* Equatable


## Alternate Approaches

* You should be able to do this with a fixed size Array, but I failed to finish that solution in my Technical Screening
