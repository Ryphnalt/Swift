//: Playground - noun: a place where people can play

func arrayMedian (arr1: [Int], arr2: [Int]) -> Double {
    var arr = arr1 + arr2
    arr.sort(by: <)
    var answer:Double = 0.0
    if arr.count%2==1 {
        let index = arr.count/2
        answer = Double(arr[index])
    } else {
        var first = arr.count/2
        var second = (arr.count/2)+1
        answer = Double((first+second))/2.0
    }
    return answer
}

let arr1:[Int] = [1,2,4,6]
let arr2:[Int] = [3,5,7,8,10,20]
arrayMedian(arr1: arr1, arr2: arr2)


// t = O(log(min(M, N))), s = O(1)
/*
func arrayMedianNoFunc(a: [Int], b: [Int]) -> Double {
    let m = a.count
    let n = b.count
    
    if m > n {
        return arrayMedianNoFunc(a: b, b: a)
    }
    
    var tmpMin = 0
    var tmpMax = m
    while tmpMin <= tmpMax {
        let i = (tmpMin + tmpMax) / 2
        let j = ((m + n + 1) / 2) - i
        if j > 0 && i < m && b[j-1] > a[i] {
            tmpMin = i + 1
        } else if i > 0 && j < n && a[i-1] > b[j] {
            tmpMax = i - 1
        } else {
            var first: Int
            if i == 0 {
                first = b[j-1]
            }
            else if j == 0 {
                first = a[i-1]
            }
            else {
                first = max(a[i-1], b[j-1])
            }
            
            // if (m + n) is odd
            if (m+n) & 1 != 0 {
                return Double(first)
            }
            
            var second: Int
            if i == m {
                second = b[j]
            } else if j == n {
                second = a[i]
            } else {
                second = min(a[i], b[j])
            }
            
            return Double((first + second))/2.0
        }
    }
    return 0.0
}

let a:[Int] = [1,2,4,6]
let b:[Int] = [3,5,7,8,10,20]
arrayMedianNoFunc(a: a, b: b)
*/