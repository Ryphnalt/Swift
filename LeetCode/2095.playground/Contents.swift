public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() { self.val = 0; self.next = nil; }
    public init(_ val: Int) { self.val = val; self.next = nil; }
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val; self.next = next;
    }
}

func deleteMiddle(_ head: ListNode?) -> ListNode? {
    var nodeTmp = head
    var total = 1
    while nodeTmp?.next != nil {
        total += 1
        nodeTmp = nodeTmp?.next
    }
    var result = head
    var current = head
    var prev: ListNode?
    for i in 0...total {
        prev = current
        if i == Int((total / 2) + 1) {
            result = prev?.next
        } else {
            var oldFirst = result
            result = prev
            oldFirst = nil
        }
        print(result?.val)
        current = current?.next
    }
//    while result?.next != nil {
//        print(result?.val)
//        result = current?.next
//    }
    return result
}

let node6 = ListNode(6)
let node2 = ListNode(2, node6)
let node11 = ListNode(1, node2)
let node7 = ListNode(7, node11)
let node4 = ListNode(4, node7)
let node3 = ListNode(3, node4)
let node1 = ListNode(1, node3)

deleteMiddle(node1)
