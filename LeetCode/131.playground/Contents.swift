
func partition(_ s: String) -> [[String]] {
    var result = [[String]]()
    var candidate = [String]()

    backtracking(&result, &candidate, Array(s), 0)

    return result
}

private func backtracking(_ result: inout [[String]], _ candidate: inout [String], _ characters: [Character], _ start: Int) {
    if start == characters.count {
        result.append(candidate)
    } else {
        for i in start..<characters.count {
            if isPalindrome(characters, start, i) {
                let character = String(characters[start...i])
                candidate.append(character)
                backtracking(&result, &candidate, characters, i + 1)
                candidate.removeLast()
            }
        }
    }
}

private func isPalindrome(_ characters: [Character], _ start: Int, _ end: Int) -> Bool {
    var start = start
    var end = end

    while start < end {
        if characters[start] != characters[end] {
            return false
        }
        start += 1
        end -= 1
    }

    return true
}

partition("cdd")
