class Solution {
    func arrayPairSum(_ nums: [Int]) -> Int {
//        // 1. 直覺解
//        let sorted = nums.sorted(by: <)
//        var total = 0
//        for i in 0..<sorted.count {
//            if i % 2 == 0 {
//                total += sorted[i]
//            }
//        }
//        return total
        // 2. 內建函式一行解
        let sorted = nums.sorted(by: <)
        return sorted.indices.reduce(0, { (sum, index) in
            if index % 2 == 0 {
                return sum + sorted[index]
            }
            return sum
        })
    }
}
