import UIKit

//func isAnagram(_ s: String, _ t: String) -> Bool {
//    guard s.count == t.count else {
//        return false
//    }
//    var scalarArray = [Int](repeating: 0, count: 123)
//
//    for scalar in s.unicodeScalars {
//        scalarArray[Int(scalar.value)] += 1
//    }
//    for char in t {
//        if scalarArray[Int(char.asciiValue!)] == 0 {
//            return false
//        }
//    }
//    return true
//}
//
//isAnagram("ab","a")
//
//
//func removeDuplicates(_ nums: inout [Int]) -> Int {
//    let length = nums.count
//    guard length > 1 else { return length }
//    var keep = 1
//    for i in 1..<length {
//        print("loop\(i)")
//        print(nums[i &- 1])
//        print(nums[i])
//        if nums[i &- 1] != nums[i] {
//          nums[keep] = nums[i]
//          keep &+= 1
//        }
//        print(nums)
//    }
//    print(length &- keep)
//    nums.removeLast(length &- keep)
//    return keep
//}
//
//var value = [0,0,1,1,1,2,2,3,3,4]
//removeDuplicates(&value)

//func singleNumber(_ nums: [Int]) -> Int {
//    var tmps: [Int: Int] = [:]
//    for num in nums {
//        if let _ = tmps[num] {
//            tmps[num]! += 1
//        } else {
//            tmps[num] = 1
//        }
//    }
//    for (key, value) in tmps {
//        if value == 1 {
//            return key
//        }
//    }
//    return -1
//}
//
//singleNumber([4,1,2,1,2])
//
//func removeDuplicates(_ nums: inout [Int]) -> Int {
//    let length = nums.count
//    guard length > 2 else { return length }
//    var keep = 2
//    for i in 2..<length {
//        print("loop\(i)")
//        print(nums[i &- 1])
//        print(nums[i])
//        if nums[i &- 1] != nums[i] {
//            nums[keep] = nums[i]
//            keep &+= 1
//        }
//        print(nums)
//        print("=======")
//    }
//    return keep
//}
//
//var value = [0,0,1,1,1,1,2,3,3]
//removeDuplicates(&value)


//func countCharacters(_ words: [String], _ chars: String) -> Int {
//    var scalarArray = [Int](repeating: 0, count: 123)
//    var sum = 0
//    var wordSum = 0
//
//    for scalar in chars.unicodeScalars {
//        scalarArray[Int(scalar.value)] += 1
//        print("\(scalar): \(scalar.value)")
//    }
//    for each in words {
//        var copyScalarArray = scalarArray
//        for char in each {
//            print("\(char): \(char.asciiValue)")
//            if copyScalarArray[Int(char.asciiValue!)] == 0 {
//                wordSum = 0
//                break
//            } else {
//                copyScalarArray[Int(char.asciiValue!)] -= 1
//            }
//            wordSum += 1
//        }
//        sum += wordSum
//        wordSum = 0
//    }
//
//    return sum
//}
//
//
//var value = ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]
//countCharacters(value, "ABCDEFGHIJKLMNOPQRSTUVWKYZ")
//
//func findDuplicates(_ nums: [Int]) -> [Int] {
//    var result = [Int]()
//    var copyNums = nums
//    for i in 0..<copyNums.count {
//        let n = abs(copyNums[i])
//        let index = n-1
//        if (copyNums[index] < 0) {
//            result.append(n)
//        }
//        copyNums[index] = -copyNums[index]
//    }
//    return result
//}
//
//findDuplicates([4,3,2,7,8,2,3,1])

//func singleNumber(_ nums: [Int]) -> [Int] {
//    var tmp = [Int]()
//
//    nums.forEach {
//        if let index = tmp.firstIndex(of: $0) {
//            tmp.remove(at: index)
//        } else {
//            tmp.append($0)
//        }
//    }
//    return tmp
//}
//
//singleNumber([1,2,1,3,2,5])


//func groupAnagrams(_ strs: [String]) -> [[String]] {
//    guard strs.count != 0 else { return [] }
//    var dict = [String:[String]]()
//    for str in strs {
//        let sorted = String(str.sorted())
//        dict[sorted, default:[]].append(str)
//    }
//    return Array(dict.values)
//}
//
//groupAnagrams(["bdddddddddd","bbbbbbbbbbc"])
//
//func topKFrequent(_ nums: [Int], _ k: Int) -> [Int] {
//    var result = [Int]()
//    var dict: [Int: Int] = [:]
//    for num in nums {
//        if var tmp = dict[num] {
//            tmp += 1
//            dict[num] = tmp
//        } else {
//            dict[num] = 1
//        }
//    }
//    let sortedByKeyDictionary = dict.sorted { firstDictionary, secondDictionary in
//        return firstDictionary.1 > secondDictionary.1
//    }
//    var i = 0
//    for (key, _) in sortedByKeyDictionary {
//        if i == k { break }
//        result.append(key)
//        i+=1
//    }
//    return result
//}
//
//topKFrequent([1,1,1,2,2,3], 2)


//func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
//    guard nums.count >= 4 else { return [] }
//
//    let nums = nums.sorted()
//    var result = [[Int]]()
//    for i in 0..<nums.count {
//        guard i == 0 || nums[i] != nums[i - 1] else { continue }
//
//        for j in (i + 1)..<nums.count {
//            guard j == (i + 1) || nums[j] != nums[j - 1] else { continue }
//
////            for k in (j + 1)..<nums.count {
////                guard k == (j + 1) || nums[k] != nums[k - 1] else { continue }
////
////                for l in (k + 1)..<nums.count {
////                    guard l == (k + 1) || nums[l] != nums[l - 1] else { continue }
////
////                    let sum = nums[i] + nums[j] + nums[k] + nums[l]
////                    if sum == target {
////                        result.append([nums[i], nums[j], nums[k], nums[l]])
////                    }
////                }
////            }
//
//            var start = j + 1
//            var end = nums.count - 1
//
//            while start < end {
//                let sum = nums[i] + nums[j] + nums[start] + nums[end]
//                if sum < target || (start > j + 1 && nums[start] == nums[start - 1]) {
//                    start += 1
//                } else if sum > target || (end < nums.count - 1 && nums[end] == nums[end + 1]) {
//                    end -= 1
//                } else {
//                    result.append([nums[i], nums[j], nums[start], nums[end]])
//                    start += 1
//                    end -= 1
//                }
//
////                if sum < target {
////                    let currentStart = start
////                    while nums[currentStart] == nums[start], start < nums.count - 1 {
////                        start += 1
////                    }
////                } else {
////                    let currentEnd = end
////                    while nums[currentEnd] == nums[end], end > j {
////                        end -= 1
////                    }
////                }
//            }
//        }
//    }
//    return result
//}


//func fourSum(_ nums: [Int], _ target: Int) -> [[Int]] {
//    guard nums.count >= 4 else { return [] }
//
//    let nums = nums.sorted()
//    return nSum(nums, target, start: 0, n: 4)
//}
//
//func nSum(_ nums: [Int], _ target: Int, start: Int, n: Int) -> [[Int]] {
//    var resultTmp = [[Int]]()
//    if start == nums.count || nums[start] * n > target || target > nums[nums.count - 1] * n {
//        return resultTmp
//    }
//    if n == 2 {
//        return twoSum(nums, target, start: start)
//    } else {
//        for i in start..<nums.count {
//            guard i == start || nums[i] != nums[i - 1] else {
//                continue
//            }
//            for n in nSum(nums, target - nums[i], start: i + 1, n: n - 1) {
//                var tmp = n
//                tmp.append(nums[i])
//                resultTmp.append(tmp)
//            }
//        }
//    }
//    return resultTmp
//}
//
//func twoSum(_ nums: [Int], _ target: Int, start: Int) -> [[Int]] {
//    var result = [[Int]]()
//    var startIndex = start
//    var endIndex = nums.count - 1
//    while startIndex < endIndex {
//        let sum = nums[startIndex] + nums[endIndex]
//        if sum < target || (startIndex > start && nums[startIndex] == nums[startIndex - 1]) {
//            startIndex += 1
//        } else if sum > target || (endIndex < nums.count - 1 && nums[endIndex] == nums[endIndex + 1]) {
//            endIndex -= 1
//        } else {
//            result.append([nums[startIndex], nums[endIndex]])
//            startIndex += 1
//            endIndex -= 1
//        }
//    }
//    return result
//}

//fourSum([1,0,-1,0,-2,2], 0)

//public class ListNode {
//    public var val: Int
//    public var next: ListNode?
//    public init() { self.val = 0; self.next = nil; }
//    public init(_ val: Int) { self.val = val; self.next = nil; }
//    public init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
//}
//
//func splitListToParts(_ head: ListNode?, _ k: Int) -> [ListNode?] {
//    var result = [ListNode?]()
//    let size = getListSize(head)
//    var avgSize = 1
//    var extraSize = 0
//    if k <= size {
//        avgSize = size / k // 3
//        extraSize = size % k // 2
//    }
//    var node = head
//    var tmp: ListNode? = nil
//    for i in 0..<k {
//        if extraSize <= 0 { extraSize = 0 }
//        var oneMore = 0
//        if extraSize > 0 { oneMore = 1 }
//        result.append(node)
//        var count = 0
//        while count < avgSize + oneMore {
//            tmp = node
//            if node != nil {
//                node = node?.next
//            }
//            count += 1
//        }
//        extraSize -= 1
//        if tmp != nil { tmp?.next = nil }
//    }
//    return result
//}
//
//func getListSize(_ head: ListNode?) -> Int {
//    guard let head = head else { return 0 }
//    var node: ListNode? = head
//    var count = 0
//    while(node != nil){
//        count += 1
//        node = node?.next
//    }
//    return count
//}
//
//let node10: ListNode = ListNode(10, nil)
//let node9: ListNode = ListNode(9, node10)
//let node8: ListNode = ListNode(8, node9)
//let node7: ListNode = ListNode(7, node8)
//let node6: ListNode = ListNode(6, node7)
//let node5: ListNode = ListNode(5, node6)
//let node4: ListNode = ListNode(4, node5)
//let node3: ListNode = ListNode(3, node4)
//let node2: ListNode = ListNode(2, node3)
//let node1: ListNode = ListNode(1, node2)
//splitListToParts(node1, 3)


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

    func printVal() {
        print(val)
    }
}

// 1
// \
//  2
// /
// 3
func inorderTraversal(_ root: TreeNode?) -> [Int] {
    guard let root = root else {
        return []
    }
    //  [] + [1] + []
    //  [3] + [2] + []
    return inorderTraversal(root.left) + [root.val] + inorderTraversal(root.right)
}

//func internalInorder(root: TreeNode?, result: [Int]) -> [Int] {
//    var tmpResult = result
//
//    if root != nil {
//        internalInorder(root: root?.left, result: tmpResult)
//        tmpResult.append(root!.val)
//        internalInorder(root: root?.right, result: tmpResult)
//    }
//    return tmpResult
//}
//
//let treeNode3: TreeNode = TreeNode(3, nil, nil)
//let treeNode2: TreeNode = TreeNode(2, treeNode3, nil)
//let treeNode1: TreeNode = TreeNode(1, nil, treeNode2)
//inorderTraversal(treeNode1)


func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    if p == nil && q == nil {
        return true
    }
    if p?.val != q?.val {
        return false
    }
    if !isSameTree(p?.left, q?.left) {
        return false
    }
    if !isSameTree(p?.right, q?.right) {
        return false
    }
    return true
}

//let treeNode6: TreeNode = TreeNode(6, nil, nil)
//let treeNode2: TreeNode = TreeNode(2, nil, nil)
//let treeNode7: TreeNode = TreeNode(7, treeNode6, nil)
//let treeNode9: TreeNode = TreeNode(9, nil, treeNode2)
//let treeNode8: TreeNode = TreeNode(8, nil, nil)
//let treeNode12: TreeNode = TreeNode(12, nil, nil)
let treeNode3: TreeNode = TreeNode(0, nil, nil)
let treeNode4: TreeNode = TreeNode(0, nil, nil)
let treeNode2: TreeNode = TreeNode(0, treeNode3, treeNode4)
let treeNode1: TreeNode = TreeNode(0, treeNode2, nil)

//isSameTree(treeNode1, treeNode4)

//func isBalanced(_ root: TreeNode?) -> Bool {
//    return maxDepth(root?.left) - maxDepth(root?.left) <= 1
//}
//
//func maxDepth(_ root: TreeNode?) -> Int {
//    guard let root = root else {
//        return 0
//    }
//
//    let left = maxDepth(root.left)
//    let right = maxDepth(root.right)
//
//    return max(left, right) + 1
//}
//
//isSameTree(treeNode1, treeNode4)

func bfs(_ root: TreeNode?) {
    guard let root = root else {
        return
    }
    var result: [Int] = []
    var queue = [TreeNode]()
    if queue.isEmpty {
        queue.append(root)
    }
    while !queue.isEmpty {
        let removedEl =  queue.removeFirst()
        result.append(removedEl.val)

        if let left = removedEl.left { queue.append(left) }
        if let right = removedEl.right { queue.append(right) }
    }
}

//bfs(treeNode6)

func dfs(_ root: TreeNode?) {
    guard let root = root else {
        return
    }
    var result: [Int] = []
    var stack = [TreeNode]()
    if stack.isEmpty {
        stack.append(root)
    }
    while !stack.isEmpty {
        let removedEl =  stack.removeLast()
        result.append(removedEl.val)

        if let right = removedEl.right { stack.append(right) }
        if let left = removedEl.left { stack.append(left) }
    }
}

//dfs(treeNode6)

func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
    guard nums.count > 0 else { return nil }
    return makeTree(nums, 0, nums.count - 1)
}

func makeTree(_ nums: [Int], _ left: Int, _ right: Int) -> TreeNode? {
    if left == right {
        return TreeNode(nums[left])
    } else if left > right {
        return nil
    }
    var i = left, peak = 0, index = i
    while i <= right {
        if nums[i] > peak {
            peak = nums[i]
            index = i
        }
        i += 1
    }
    let root = TreeNode(nums[index])
    root.left = makeTree(nums, left, index - 1)
    root.right = makeTree(nums, index + 1, right)
    return root
}

//constructMaximumBinaryTree([3,2,1,6,0,5])

func constructMaximumBinaryTree2(_ nums: [Int]) -> TreeNode? {
    guard nums.count > 0 else { return nil }

    var stack = [TreeNode]()
    for i in 0..<nums.count {
        let cur = TreeNode(nums[i])
        while let last = stack.last, last.val < nums[i] {
            cur.left = last
            stack.popLast()
        }
        if (!stack.isEmpty) {
            stack.last?.right = cur
        }
        stack.append(cur)
    }
    return stack.first
}

//constructMaximumBinaryTree2([3,2,1,6,0,5])

func isEvenOddTree(_ root: TreeNode?) -> Bool {
    guard root != nil else { return false }
    var queue = [root!]
    var isEvenLevel = true
    var prevChildCount = 0, i = 0

    while !queue.isEmpty {
        var childCount = queue.count - prevChildCount
        print(childCount)
        prevChildCount = queue.count
        print(prevChildCount)
        let firstNode =  queue.removeFirst()
        print(firstNode.val)

//        if isOdd && (firstNode.val >= prevChild || firstNode.val % 2 != 0) { return false }
//        if !isOdd && (firstNode.val <= prevChild || firstNode.val % 2 == 0) { return false }

        if let left = firstNode.left { queue.append(left) }
        if let right = firstNode.right { queue.append(right) }



//        prevChild = firstNode.val

//        var childCount = queue.count - prevChildCount
//        prevChildCount = queue.count
//        var prevChild = isOdd ? 1 : 0
//
//        for _ in 0..<childCount {
//            let n = queue[i], val = n.val
//            i += 1
//
//            if isOdd && (val >= prevChild || val % 2 != 0) { return false }
//            if !isOdd && (val <= prevChild || val % 2 == 0) { return false }
//
//            if let left = n.left { queue.append(left) }
//            if let right = n.right { queue.append(right) }
//
//            prevChild = val
//        }
//        isOdd = !isOdd
    }
    return true
}

//isEvenOddTree(treeNode1)


//class Solution {
//    enum CoverStatus {
//        case covered
//        case hasCamere
//        case notCovered
//    }
//
//    var cameraCount = 0
//
//    func minCameraCover(_ root: TreeNode?) -> Int {
//        let rootCoverStatus = covered(root)
//        if rootCoverStatus == .notCovered {
//            cameraCount += 1
//        }
//        return cameraCount
//    }
//
//    func covered(_ root: TreeNode?) -> CoverStatus {
//        guard let root = root else {
//            return .covered
//        }
//        let leftCoverStatus = covered(root.left)
//        let rightCoverStatus = covered(root.right)
//
//        if leftCoverStatus == .notCovered || rightCoverStatus == .notCovered {
//            cameraCount += 1
//            return .hasCamere
//        }
//
//        if leftCoverStatus == .hasCamere || rightCoverStatus == .hasCamere {
//            return .covered
//        }
//
//        return .notCovered
//    }
//}
//
//Solution().minCameraCover(treeNode1)

func prisonAfterNDays(_ cells: [Int], _ n: Int) -> [Int] {
    var cellsTmp = cells
    var cur = [Int](repeating: 0, count: 8)
    for day in 0..<n {
        for i in 1..<7 {
            cur[i] = (cellsTmp[i-1] == cellsTmp[i+1]) ? 1 : 0
        }
        cellsTmp = cur
        print("day: \(day+1)")
        print(cellsTmp)
    }
    return cellsTmp
}

//prisonAfterNDays([0,1,0,1,1,0,0,1], 15)

func mincostTickets(_ days: [Int], _ costs: [Int]) -> Int {
    guard let lastday = days.last else{
        return 0
    }
    var cost = Array(repeating: 0, count: lastday + 1)
    for i in 1...lastday {
        if !days.contains(i) {
            cost[i] = cost[i-1]
        } else {
            let ticket1 = costs[0] + cost[i-1]
            let ticket7 = costs[1] + (i>=7 ? cost[i-7] : 0)
            let ticket30 = costs[2] + (i>=30 ? cost[i-30] : 0)
            cost[i] = min(ticket1, min(ticket7, ticket30))
        }
    }
    return cost.last ?? 0
//    guard let lastday = days.last else{
//        return 0
//    }
//    var dp = Array(repeating: 0, count: lastday+1)
//    var trip = Array(repeating: false, count: lastday+1)
//    for day in days{
//        trip[day] = true
//    }
//    for i in 1...lastday{
//        if !trip[i] {
//            dp[i] = dp[i-1]
//        }else{
//            let ticket1 = costs[0] + dp[i-1]
//            let ticket7 = costs[1] + (i>=7 ? dp[i-7] : 0)
//            let ticket30 = costs[2] + (i>=30 ? dp[i-30] : 0)
//            dp[i] = min(ticket1, min(ticket7, ticket30))
//        }
//    }
//    return dp[lastday]
}

//mincostTickets([1,4,6,7,8,20], [2,7,15])


//func stoneGame(_ piles: [Int]) -> Bool {
////    let sum = piles.reduce(0, +)
////    let scoreAlex = stoneNums(piles, 0)
////    let scoreLee = sum - scoreAlex
////    return scoreAlex - scoreLee > 0 ? true : false
//
//    let n = piles.count
//    let sub = Array(repeating: 0, count: n + 1)
//    var dp: [[Int]] = Array(repeating: sub, count: n + 1)
//    for i in 1...n {
//        // [0, 0, 0, 0, 0]
//        // [3, 2, 7, 3, 0]
//        // [1, 5, 4, 0, 0]
//        // [6, -2, 0, 0, 0]
//        // [5, 0, 0, 0, 0]
//        for j in 0...n-i {
//            dp[i][j] = max(piles[j] - dp[i - 1][j + 1], piles[j + i - 1] - dp[i - 1][j])
//        }
//    }
//    print(dp)
//    return dp[n][0] > 0
//}
//
////stoneGame([3,2,7,3])
//
//func stoneNums(_ piles: [Int], _ player: Int) -> Int {
//    let first = 0
//    let last = piles.count - 1
//    if first > last { return 0 }
//    if piles[first] > piles[last] {
//        print("first")
//        print(player)
//        if player == 0 {
//            print(piles)
//            return piles[first] + stoneNums(Array(piles.dropFirst()), 1)
//        } else {
//            print(piles)
//            return 0 + stoneNums(piles.dropLast(), 0)
//        }
//    } else {
//        print("last")
//        print(player)
//        if player == 0 {
//            print(piles)
//            return piles[last] + stoneNums(piles.dropLast(), 1)
//        } else {
//            print(piles)
//            return 0 + stoneNums(Array(piles.dropFirst()), 0)
//        }
//    }
//}
//
////stoneGame([3,2,7,3])
//
//
//func rotate(_ matrix: [[Int]]) -> [[Int]] {
//    var m = matrix
//    if m.count < 2 {
//        return m
//    }
//    let n = m.count
//    for i in 0..<n / 2 {
//        for j in i..<n-1-i {
//            (m[i][j], m[n-1-j][i], m[n-1-i][n-1-j], m[j][n-1-i]) = (m[n-1-j][i], m[n-1-i][n-1-j], m[j][n-1-i], m[i][j])
//        }
//    }
//
//
////    // [1,2,3]  [7,8,9]  [7,4,1]
////    // [4,5,6]  [4,5,6]  [8,5,2]
////    // [7,8,9]  [1,2,3]  [9,6,3]
//
////    // [1,2,3]  [1,4,7]  [7,4,1]
////    // [4,5,6]  [2,5,8]  [8,5,2]
////    // [7,8,9]  [3,6,9]  [9,6,3]
////    for i in 0..<m.count {
////        for j in i+1..<m[i].count {
////            (m[i][j], m[j][i]) = (m[j][i], m[i][j])
////        }
////        m[i].reverse()
////    }
//
////    var dict : [[Int] : Int] = [:]
////    var count = m.count-1
////    for i in 0..<m.count{
////        for j in 0..<m[i].count{
////            dict[[j, count-i]] = m[i][j]
////        }
////    }
////    for i in 0..<m.count{
////        for j in 0..<m[i].count{
////            m[i][j] = dict[[i,j]]!
////        }
////    }
//
//    return m
//}
//
////[1,2,3]  [3,1]
////[4,5,6]  [4,2]
////[7,8,9]  [9,6,3]
//var arr = [[1,2,3],[4,5,6],[7,8,9]]
////rotate(arr)
//
//
//func spiralOrder(_ matrix: [[Int]]) -> [Int] {
//    var result: [Int] = []
//    // i 0->0->0->1->2->2->2->1->1
//    // j 0->1->2->2->2->1->0->0->1
//    // 0,0 0,1 0,2
//    // 1,2 2,2
//    // 2,1 2,0
//    // 1,0 1,1
//    var i = 0
//    var j = 0
//    for k in 0..<matrix.count {
//        for l in 0..<matrix[k].count {
//            if j == matrix[k].count {
//                i += 1
//                j = matrix[k].count - 1
////                print("i: \(i), j: \(j)")
//            } else if i == matrix.count - 1 {
//                i = matrix.count - 1
//                j -= 1
//                print("i: \(i), j: \(j)")
//            }
////            print("i: \(i), j: \(j)")
//
////            print("i: \(i), j: \(j)")
//
////            if i == matrix.count {
////                i = matrix.count - 1
////                j -= 1
////            }
//            if i < matrix.count - 1 {
//                j += 1
//            }
//
//
//
//
//        }
//    }
//    return result
//}

//spiralOrder([[1,2,3],[4,5,6],[7,8,9]])

func longestPalindrome(_ s: String) -> String {
    if s.count < 2 {
        return s
    }
    let word = Array(s)
    var t = "$#"
    s.forEach {
        t += String($0)
        t += "#"
    }
    print(t)
    let words = Array(t)
    var id = 0, mx = 0, resId = 0, resMx = 0
    var p = Array(repeating: 0, count: words.count)
    for i in 1..<words.count {
        p[i] = mx > i ? min(p[2 * id - i], mx - i) : 1
        while i - p[i] > 0, i + p[i] < words.count, words[i + p[i]] == words[i - p[i]] {
            p[i]+=1
        }
        if (mx < i + p[i]) {
            mx = i + p[i]
            id = i
        }
        if (resMx < p[i]) {
            resMx = p[i]
            resId = i
        }
    }
    let startIndex = (resId - resMx) / 2
    let limit = resMx - 1
    return String(word[startIndex..<startIndex + limit])
//    for (int i = 1; i < t.size(); ++i) {
//        p[i] = mx > i ? min(p[2 * id - i], mx - i) : 1;
//        while (t[i + p[i]] == t[i - p[i]]) ++p[i];
//        if (mx < i + p[i]) {
//            mx = i + p[i];
//            id = i;
//        }
//        if (resMx < p[i]) {
//            resMx = p[i];
//            resId = i;
//        }
//    }
//    return s.substr((resId - resMx) / 2, resMx - 1);
//    var low = 0
//    var maxL = 0
//    for i in 0..<words.count - 1 {
//        print("start: \(words)")
//        checkSubString(i, i, words, &low, &maxL)
//        checkSubString(i, i+1, words, &low, &maxL)
//        print("end")
//    }
//    return String(words[low..<low + maxL])
}

//func longestPalindrome2(_ s: String) -> String {
//    if s.count < 2 {
//        return s
//    }
//
//    var low = 0
//    var maxL = 0
//    let word = Array(s)
//    for i in 0..<word.count - 1 {
//        print("start: \(word)")
//        checkSubString(i, i, word, &low, &maxL)
//        checkSubString(i, i+1, word, &low, &maxL)
//        print("end")
//    }
//    return String(word[low..<low + maxL])
//}
//
//func checkSubString(_ i: Int, _ j: Int, _ s: [Character], _ low: inout Int, _ maxL: inout Int) {
//    var x = i
//    var y = j
//    while (x >= 0 && y < s.count && s[x] == s[y] ) {
//        x -= 1
//        y += 1
//
//        if x >= 0 { print("x: \(s[x])") }
//        if y >= 0, y < s.count { print("y: \(s[y])") }
//    }
//
//    if (maxL < y - x - 1) {
//        low = x + 1
//        maxL = y - x - 1
//    }
//    print("low: \(low)")
//    print("maxL: \(maxL)")
//}

//longestPalindrome("cbbd")

func validPalindrome(_ s: String) -> Bool {
    if s.isEmpty {
        return true
    }
    let word = Array(s)
    var t = "$#"
    s.forEach {
        t += String($0)
        t += "#"
    }
    let words = Array(t)
    var id = 0, mx = 0, resId = 0, resMx = 0
    var p = Array(repeating: 0, count: words.count)
    for i in 1..<words.count {
        p[i] = mx > i ? min(p[2 * id - i], mx - i) : 1
        while i - p[i] > 0, i + p[i] < words.count, words[i + p[i]] == words[i - p[i]] {
            p[i]+=1
        }
        if (mx < i + p[i]) {
            mx = i + p[i]
            id = i
        }
        if (resMx < p[i]) {
            resMx = p[i]
            resId = i
        }
    }
    let startIndex = (resId - resMx) / 2
    let limit = resMx - 1
    let tmp = String(word[startIndex..<startIndex + limit])
    return tmp == s
}

//validPalindrome("abca")


func change(_ amount: Int, _ coins: [Int]) -> Int {
    guard amount > 0 else {
        return 1
    }
    var table = Array(repeating:0,count:amount+1)
    table[0] = 1
    for coin in coins  {
        print("coin:\(coin)")
        for i in 1...amount {
            print("i:\(i)")
            if i >= coin {
                table[i] += table[i - coin]
            }
        }
        print("=====")
    }
    print(table)
    return table[amount]
}

//change(5, [1,2,5])

//func validPalindrome(_ s: String) -> Bool {
//    if s.isEmpty {
//        return true
//    }
//    var sArray = Array(s)
//    return isPalindrome(sArray, 0, sArray.count - 1, 0)
//}
//
//func isPalindrome(_ sArray: [Character], _ i: Int, _ j: Int, _ c: Int) -> Bool {
//    var right = i
//    var left = j
//    var count = c
//    if count > 1 || left > right {
//        return false
//    }
//    while left < right {
//        if sArray[left] != sArray[right] {
//            return isPalindrome(sArray, left, right-1, count+1) || isPalindrome(sArray, left+1, right, count+1);
//        }
//        left+=1
//        right-=1
//    }
//    return true
//}


func numIslands(_ grid: [[Character]]) -> Int {

    guard grid.count > 0 else { return 0 }
    guard grid[0].count > 0 else { return 0 }

    var matrix = grid
    var numberOfIslands = 0

    for i in 0..<matrix.count {
        for j in 0..<matrix[i].count {
            if matrix[i][j] == "1" {
                numberOfIslands += 1
                changeElement(&matrix, i, j)
            }
        }
    }
    return numberOfIslands
}

private func changeElement(_ matrix: inout [[Character]], _ i: Int, _ j: Int) {
    guard i >= 0, i < matrix.count, j >= 0, j < matrix[0].count, matrix[i][j] == "1" else { return }
    matrix[i][j] = "0"
    changeElement(&matrix, i + 1, j)
    changeElement(&matrix, i - 1, j)
    changeElement(&matrix, i, j + 1)
    changeElement(&matrix, i, j - 1)
}

//numIslands([
//    ["1","1","0","0","0"],
//    ["1","1","0","0","0"],
//    ["0","0","1","0","0"],
//    ["0","0","0","1","1"]
//])


func combine1(_ n: Int, _ k: Int) -> [[Int]] {
    guard n > 1 else {
        return [[n]]
    }
    var result: [[Int]] = []
    if k > 1 {
        for i in 1...n {
            var j = i + 1
            while j <= n {
                var tmp: [Int] = []
                tmp.append(i)
                while tmp.count < k {
                    tmp.append(j)
                    j += 1
                    if j > n { break }
                }
                if tmp.count == k { result.append(tmp) }
            }
        }
    } else {
        // 2,1的情況走這段
        for i in 1...n {
            var tmp: [Int] = []
            tmp.append(i)
            result.append(tmp)
        }
    }
    return result
}

func combine2(_ n: Int, _ k: Int) -> [[Int]] {
    var result = [[Int]]()
    var candidate = [Int]()

    backtracking(&result, &candidate, 1, n, k)

    return result
}

private func backtracking(_ result: inout [[Int]], _ candidate: inout [Int], _ start: Int, _ n: Int, _ k: Int) {
    if k == 0 {
        result.append(candidate)
        return
    }
    if start > n {
        return
    }

    for i in start...n {
        candidate.append(i)
        backtracking(&result, &candidate, i + 1, n, k - 1)
        candidate.removeLast()
    }
}

func combine3(_ n: Int, _ k: Int) -> [[Int]] {
    var res = [[Int]]()
    var data = [Int](repeating: 0, count: k)
    var i = 0
    while data[0] <= (n - k + 1) {
        data[i] += 1
        if data[i] > n {
            i -= 1
        } else if i == (k - 1) {
            res.append(data)
        } else {
            i += 1
            data[i] = data[i - 1]
        }
    }
    return res
}

//func combine(_ n: Int, _ k: Int) -> [[Int]] {
//    var result = [[Int]]()
//    var array: [Int] = []
//    for i in 1...n {
//        array.append(i)
//    }
//    var start = 0
//    var end = array.count - 1
//    var tmp: [Int] = []
//    tmp.append(array[start])
//
//
////    var data = [Int](repeating: 0, count: k)
////    var i = 0
////    while data[0] <= (n - k + 1) {
////        data[i] += 1
////        if data[i] > n {
////            i -= 1
////        } else if i == (k - 1) {
////            res.append(data)
////        } else {
////            i += 1
////            data[i] = data[i - 1]
////        }
////    }
////    return res
//}

//combine(4, 3)


func carFleet(_ target: Int, _ position: [Int], _ speed: [Int]) -> Int {
    let cars = zip(position, speed).sorted(by: < )
    guard cars.count > 1 else {
        return cars.count
    }
    print(cars)
    var duration: [Set<Int>] = []
    for i in 0..<cars.count {
        var set = Set<Int>()
        var currentCarFleet = cars[i].0 + cars[i].1
        set.insert(currentCarFleet)
        while currentCarFleet < target {
            currentCarFleet += cars[i].1
            set.insert(currentCarFleet)
        }
        duration.append(set)
    }
    print(duration)
    var answer = Set<Int>()
    var tmp = Set<Int>()
    for i in 0..<duration.count {
        if tmp.count == 0 {
            tmp = duration[i]
        }
        if i + 1 < duration.count {
            tmp = tmp.intersection(duration[i + 1])
            print(tmp)
            if let first = tmp.first {
                answer.insert(first)
            }
        }
    }
//    print(answer)
    return answer.count > 0 ? answer.count : duration.count
}

//carFleet(10, [0,4,2], [2,1,3])
//carFleet(12, [10,8,0,5,3], [2,4,1,1,3])
//carFleet(10, [6,8], [3,2])
//carFleet(10, [3], [3])
//carFleet(10, [4,6], [3,2])
//carFleet(10, [0,2], [1,1])

//--- case 1 start ---//
//numCourses = 9
//prerequisites = [
//    [3,9],
//    [4,9],
//    [8,9],
//    [4,8],
//    [7,8],
//    [5,8],
//    [6,7],
//    [1,6],
//    [1,5],
//    [2,4],
//    [2,3],
//]
//
// solution 1
//dict = [
//    8: [],
//    7: [8],
//    6: [7],
//    5: [6],
//    4: [7],
//    3: [7,8],
//    2: [8],
//    1: [2,3],
//    0: [4,5]
//]
//
//visited = []
//dfs(dict, 0, visited)
//visited = [0]
//dfs(dict, 4, visited)
//visited = [0,4]
//dfs(dict, 7, visited)
//visited = [0,4,7]
//dfs(dict, 8, visited)
//visited = [0,4,7,8]
//visited = [0,4,7]
//visited = [0,4]
//visited = [0]
//dfs(dict, 5, visited)
//visited = [0,5]
//dfs(dict, 6, visited)
//visited = [0,5,6]
//dfs(dict, 7, visited)
//visited = [0,5,6,7]
//visited = [0,5,6]
//visited = [0,5]
//visited = [0]
//visited = []
//
// solution 2
//dict = [
//    9: [3,4,8],
//    8: [4,5,7],
//    7: [6],
//    6: [1],
//    5: [1],
//    4: [2],
//    3: [2],
//    2: [],
//    1: []
//]
//
//indegree = [9:0, 8:1, 7:1, 6:1, 5:1, 4:2, 3:1, 2:2, 1:2]
//queue = [9] count = 1
//indegree = [9:0, 8:0, 7:1, 6:1, 5:1, 4:1, 3:0, 2:2, 1:2]
//queue = [3,8] count = 3
//indegree = [9:0, 8:0, 7:0, 6:1, 5:0, 4:0, 3:0, 2:1, 1:2]
//queue = [4,5,7] count = 6
//indegree = [9:0, 8:0, 7:0, 6:0, 5:0, 4:0, 3:0, 2:0, 1:1]
//queue = [2,6] count = 8
//indegree = [9:0, 8:0, 7:0, 6:0, 5:0, 4:0, 3:0, 2:0, 1:0]
//queue = [1] count = 9
//--- case 1 end ---//
//
////--- case 2 start ---//
//numCourses = 9
//prerequisites = [
//    [3,9],
//    [4,9],
//    [8,9],
//    [4,8],
//    [7,8],
//    [5,8],
//    [6,7],
//    [1,6],
//    [1,5],
//    [2,4],
//    [2,3],
//    [9,2],
//]
//
//// solution 1
//dict = [
//    8: [1],
//    7: [8],
//    6: [7],
//    5: [6],
//    4: [7],
//    3: [7,8],
//    2: [8],
//    1: [2,3],
//    0: [4,5]
//]
//
//visited = []
//dfs(dict, 0, visited)
//visited = [0]
//dfs(dict, 4, visited)
//visited = [1,4]
//dfs(dict, 7, visited)
//visited = [0,4,7]
//dfs(dict, 8, visited)
//visited = [0,4,7,8]
//dfs(dict, 1, visited)
//visited = [0,4,7,8,1]
//dfs(dict, 2, visited)
//visited = [0,4,7,8,1,2]
//dfs(dict, 8, visited)
//
//visited.contains(8)
//
//// solution 2
//dict = [
//    9: [3,4,8],
//    8: [4,5,7],
//    7: [6],
//    6: [1],
//    5: [1],
//    4: [2],
//    3: [2],
//    2: [9],
//    1: []
//]
//
//indegree = [9:1, 8:1, 7:1, 6:1, 5:1, 4:2, 3:1, 2:2, 1:2]
//queue = [] count = 0
//
////--- case 2 end ---//


//func findOrder(_ numCourses: Int, _ prerequisites: [[Int]]) -> [Int] {
//    var result: [Int] = []
//    var dict = [Int: Set<Int>]()
//    for course in 0..<numCourses {
//        dict[course] = []
//    }
//    for item in prerequisites {
//        dict[item[0], default: []].insert(item[1])
//    }
//    var visited = Set<Int>()
//    for course in dict.keys {
//        if dfs(dict, course, &visited, &result) == false {
//            return result
//        }
//    }
//    return result
//}
//
//private func dfs(_ graph: [Int: Set<Int>], _ curr: Int, _ visited: inout Set<Int>, _ result: inout [Int]) -> Bool {
//    if visited.contains(curr) {
//        return false
//    }
//
//    for next in graph[curr] ?? [] {
//        visited.insert(curr)
//        let nextVisit = dfs(graph, next, &visited, &result)
//        visited.remove(curr)
//
//        if nextVisit == false {
//            return false
//        }
//    }
//    if !result.contains(curr) { result.append(curr) }
//    return true
//}

//func shortestPathBinaryMatrix(_ grid: [[Int]]) -> Int {
//    let startPoint = (0, 0)
//    let endPoint = (grid.count-1, grid.count-1)
//    guard grid[startPoint.0][startPoint.1] == 0 else {
//        return -1
//    }
//    guard grid[endPoint.0][endPoint.1] == 0 else {
//        return -1
//    }
//    print("start")
//    print("x:\(startPoint.0)")
//    print("y:\(startPoint.1)")
//    var pathCount = 2
//    var i = 0
//    var j = 0
//    while i + 1 < grid.count, j + 1 < grid.count {
//        if grid[i+1][j+1] == 0 {
//            pathCount += 1
//            i+=1
//            j+=1
//            print("bottom-right")
//            print("x:\(i)")
//            print("y:\(j)")
//        } else if grid[i][j+1] == 0 {
//            pathCount += 1
//            j+=1
//            print("right")
//            print("x:\(i)")
//            print("y:\(j)")
//        } else if grid[i+1][j] == 0 {
//            pathCount += 1
//            i+=1
//            print("bottom")
//            print("x:\(i)")
//            print("y:\(j)")
//        } else {
//            return -1
//        }
//    }
//    print("end")
//    print("x:\(endPoint.0)")
//    print("y:\(endPoint.1)")
//    return pathCount
//}

//shortestPathBinaryMatrix([[0,0,0],[1,1,0],[1,1,0]])
//shortestPathBinaryMatrix([[0,1],[1,0]])
//shortestPathBinaryMatrix([[0,0,0],[0,1,0],[0,0,0]])

// [0,0,0]
// [0,1,0]
// [0,0,0]


func minIncrementForUnique(_ nums: [Int]) -> Int {
    var total = 0
    var dic: [Int: Int] = [:]
//    var u: [Int] = []
//    var dic: [Int: Int] = [:]
//    for num in nums {
//        if dic[num] == nil {
//            dic[num] = 1
//        } else {
//            var tmp = num + 1
//            while dic[tmp] == nil {
//                tmp += 1
//            }
//            total += tmp - num
//            dic[num] = 1
//        }
//    }
    for num in nums {
        if dic[num] != nil {
            dic[num]! += 1
        } else {
            dic[num] = 1
        }
    }
    for (key, value) in dic {
        var tmp = key
        guard let count = dic[tmp], count > 1 else {
            continue
        }
        for i in 0..<count {
            tmp += 1
            if dic[tmp] != nil {
                dic[tmp]! += 1
            } else {
                dic[tmp] = 1
            }
        }
    }
    print(dic)
    return total
}

//minIncrementForUnique(
//    [3,2,1,2,1,7]
//)

//[22268,18793,35885,37643,39320,21173,11650,3777,851,11059,1581,28703,19120,32792,33349,18906,19273,21206,26203,19038,38394,11022,1524,38878,3506,7521,10955,33639,12646,26236,33851,21732,9122,20535,915,14645,7206,16086,2404,26803,27572,32269,23836,4933,5823,39369,27832,26498,19496,12949,34004,37588,9988,13752,12734,39403,23037,29697,13341,13067,29795,32612,5718,35017,26069,12155,7818,37871,20871,17567,12231,26412,356,36454,24648,24,2466,23999,9622,13257,34942,31463,20617,35072,23268,11209,39041,2372,2758,35843,22034,35049,31736,29304,38242,13783,25030,36245,9839,243,21826,17111,15899,15387,27041,21066,17674,27153,14359,19613,13387,21106,36242,4045,24976,7183,36932,32845,16203,38120,2300,24382,14162,31617,39794,11630,24632,26105,12509,11937,4048,37839,19763,28057,31460,10714,7780,14920,24394,21151,4619,39316,39567,33927,6810,16769,32246,39532,24661,7120,36171,11836,32606,26419,13783,24288,15033,24041,31314,28727,23274,28776,32141,15105,8206,27645,8340,26328,29469,13491,9124,29932,39005]


//func wiggleSort(_ nums: inout [Int]) {
//    for i in 0..<nums.count-2 {
//        print("start")
//        print(nums[i])
//        var index = i+1
//        while nums[i] >= nums[index] {
//            index += 1
//        }
//        print(nums[index])
//        print("end")
//        (nums[index], nums[index+1]) = (nums[index+1], nums[index])
//    }
//    print(nums)
//}
//
//var nums = [1,5,1,1,6,4]
//wiggleSort(&nums)

//func countBits(_ n: Int) -> [Int] {
    // var result = [Int]()
    // for i in 0...n {
    //     let str = String(i, radix: 2).replacingOccurrences(of: "0", with: "")
    //     result.append(str.count)
    // }
    // return result

    // 從1開始
    // 偶數的規則：陣列[無條件捨去(偶數/2)]
    // 奇數的規則：陣列[無條件捨去(奇數/2)] + 1
    // EX:
    // result[0, 1, 1, 2, 1, 2, 2]
    // i = 5, result[Int(5/2)] + 1 = 2
    // i = 6, result[Int(6/2)] = 2
//    var result = [0]
//    guard n > 0 else { return result }
//    for i in 1...n {
//        if i % 2 != 0 {
//            result.append(result[Int(i / 2)] + 1)
//        } else {
//            result.append(result[Int(i / 2)])
//        }
//    }
//    return result


//    i    binary '1'  i&(i-1)
//    0    0000    0
//    -----------------------
//    1    0001    1    0000
//    -----------------------
//    2    0010    1    0000
//    3    0011    2    0010
//    -----------------------
//    4    0100    1    0000
//    5    0101    2    0100
//    6    0110    2    0100
//    7    0111    3    0110
//    -----------------------
//    8    1000    1    0000
//    9    1001    2    1000
//    10   1010    2    1000
//    11   1011    3    1010
//    12   1100    2    1000
//    13   1101    3    1100
//    14   1110    3    1100
//    15   1111    4    1110
//    var result = [Int](repeating: 0, count: n + 1)
//    for i in 1...n {
//        result[i] = result[i & (i - 1)] + 1
//    }
//    return result


//    if n == 0 {
//        return [0]
//    }
//    var result = [0, 1]
//    var k = 2, i = 2
//    while i <= n {
//        for j in pow(2, k - 1)...pow(2, k) {
//            if j > n { break }
//            var t = (pow(2, k) - pow(2, k - 1)) / 2
//            if j < pow(2, k - 1) + t {
//                result.append(result[j - t])
//            } else {
//                result.append(result[j - t] + 1)
//            }
//        }
//        k += 1
//    }
//    return result
//}

func firstMissingPositive(_ nums: [Int]) -> Int {
    if nums.isEmpty {
        return 1

    }
    for i in 1...nums.count {
        if !nums.contains(i) {
            return i
        }
    }
    return nums.count + 1

//    var tmp = [Int].init(repeating: 0, count: nums.count)
//    nums.forEach { (num) in
//        if num > 0 && num <= nums.count {
//            tmp[num-1] = num
//        }
//    }
//    for i in 0..<tmp.count {
//        if tmp[i] == 0 {
//            return i+1
//        }
//    }
//    return tmp.count+1
}


//func countBitUtil(_ num:Int) ->Int {
//    var count = 0
//    var input = num
//    while input != 0 {
//        input = input & (input - 1)
//        count += 1
//    }
//    return count
//}

//countBits(15)


//func minPartitions(_ n: String) -> Int {
//    return Int(n.max()!.asciiValue!) - 48
//}
//
//minPartitions("27346209830709182346")


func numIdenticalPairs(_ nums: [Int]) -> Int {
    var res = 0
    for i in 0..<nums.count - 1 {
        for j in i + 1..<nums.count {
            if nums[i] == nums[j] {
                res += 1
            }
        }
    }
    return res
//    var res = 0, map = [Int:Int]()
//    nums.forEach {
//        res += map[$0] ?? 0
//        map[$0, default: 0] += 1
//        print(map)
//    }
//    return res
}

//numIdenticalPairs([1,1,1,1])

enum Brackets {
    case small
    case medium
    case big
}

func isValid(_ s: String) -> Bool {
    let pairs = [["(",")"],["[","]"],["{","}"]]
    var dic: [Brackets: Int] = [.small: 0, .medium: 0, .big: 0]
    for ch in s {
        if pairs[0].contains(String(ch)) {
            dic[.small]! += 1
            if dic[.small] == 2, (dic[.medium] == 1 || dic[.big] == 1) {
                return false
            }
        } else if pairs[1].contains(String(ch)) {
            dic[.medium]! += 1
            if dic[.medium] == 2, (dic[.small] == 1 || dic[.big] == 1) {
                return false
            }
        } else if pairs[2].contains(String(ch)) {
            dic[.big]! += 1
            if dic[.big] == 2, (dic[.small] == 1 || dic[.medium] == 1) {
                return false
            }
        }
    }
    return true
}

//isValid("([)]")

enum Operation: Character {
    case plus = "+"
    case minus = "-"
    case multiply = "*"
    case divided = "/"
    case mod = "%"
}

func finalValueAfterOperations(_ operations: [String]) -> Int {
    var result = 0
    for operation in operations {
        let op = operation.lowercased().replacingOccurrences(of: "x", with: "")
        let secondIndex = op.index(after: op.startIndex)
        let numString = String(op[secondIndex...])
        var n = 1
        if let num = Int(numString), num > 0 {
            n = num
        }
        switch op.first {
        case Operation.plus.rawValue:
            result = result + n
        case Operation.minus.rawValue:
            result = result - n
        case Operation.multiply.rawValue:
            result = result * n
        case Operation.divided.rawValue:
            result = result / n
        case Operation.mod.rawValue:
            result = result % n
        default:
            break
        }
    }
    return result
}



finalValueAfterOperations(["--X","X++","X++","X+10","X/10"])


