class Solution {
    func peakIndexInMountainArray(_ arr: [Int]) -> Int {
//        // 1. 暴力解：遍歷找開始下坡處
//        for (index, number) in arr.enumerated() {
//            if arr[index] > arr[index+1] {
//                return index
//            }
//        }
//        return -1
        // 2. O(Log n)解法：雙指針找開始下坡處
        var startIndex = 0
        var endIndex = arr.count - 1
        while startIndex < endIndex {
            let key = Int((startIndex + endIndex) / 2)
            if arr[key] < arr[key + 1] {
                startIndex += 1
            } else {
                endIndex = key
            }
        }
        return startIndex
    }
}
