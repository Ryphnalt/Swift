public class Node {
    public var val: Int
    public var left: Node?
    public var right: Node?
    public var next: Node?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
        self.next = nil
    }
}

func connect(_ root: Node?) -> Node? {
    guard let root = root else {
        return nil
    }
    var queue = [root]
    var next = [Node]()
    while !queue.isEmpty {
        for i in 0..<queue.count {
            let node = queue[i]
            if i+1 < queue.count {
                node.next = queue[i+1]
            }
            if let left = node.left {
                next.append(left)
            }
            if let right = node.right {
                next.append(right)
            }
        }
        queue = next
        next = []
    }
    return root
}

let node4 = Node(4)
let node5 = Node(5)
let node6 = Node(6)
let node7 = Node(7)
let node2 = Node(2)
node2.left = node4
node2.right = node5
let node3 = Node(3)
node3.left = node6
node3.right = node7
let node1 = Node(1)
node1.left = node2
node1.right = node3

connect(node1)
