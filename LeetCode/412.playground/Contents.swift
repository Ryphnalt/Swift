class Solution {
    func fizzBuzz(_ n: Int) -> [String] {
//        // 1. 直覺解
//        var result: [String] = []
//        for i in 1...n {
//            var str = ""
//            if i % 3 == 0 {
//                str += "Fizz"
//            }
//            if i % 5 == 0 {
//                str += "Buzz"
//            }
//            if str == "" {
//                str = "\(i)"
//            }
//            result.append(str)
//        }
//        return result
        // 2. 可擴充性的解法
        let mapping = [3:"Fizz", 5:"Buzz"].sorted(by: <)
        var result: [String] = []
        for index in 1...n {
            var str = ""
            for (key, value) in mapping {
                if index % key == 0 {
                    str += value
                }
            }
            if str == "" {
                str = "\(index)"
            }
            result.append(str)
        }
        return result
    }
}
