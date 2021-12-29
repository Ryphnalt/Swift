class Solution {
    func search(_ nums: [Int], _ target: Int) -> Int {
//        // 1. 直覺解：使用內建函式
//        return nums.index(of: target) ?? -1
//        // 2. 暴力解：使用內建函式
//        for i in nums.indices {
//            if nums[i] == target {
//                return i
//            }
//        }
//        return -1
        // 3. O(Log n)解法
        var startIndex = 0
        var endIndex = nums.count - 1
        while startIndex <= endIndex {
            let key = Int((startIndex + endIndex) / 2)
            if nums[key] == target {
                return key
            } else if nums[key] > target {
                endIndex -= 1
            } else if nums[key] < target {
                startIndex += 1
            }
        }
        return -1
    }
}
