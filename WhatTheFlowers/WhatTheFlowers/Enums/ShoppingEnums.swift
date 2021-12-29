//
//  ShoppingEnums.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/9.
//

enum GoodsType: String, CaseIterable {
    case preservedFlower = "不凋花"
    case driedFlower = "乾燥花"
    case package = "包材"
    case accessory = "配件/裝飾"
    case other = "其他"

    var subTypes: [String] {
        switch self {
        case .preservedFlower:
            return PreservedFlowerType.allCases.map { $0.rawValue }
        case .driedFlower:
            return DriedFlowerType.allCases.map { $0.rawValue }
        case .package:
            return PackageType.allCases.map { $0.rawValue }
        case .other:
            return OtherType.allCases.map { $0.rawValue }
        default:
            return []
        }
    }

    static var subMenuItems: [[String]] {
        var subMenuItems: [[String]] = []
        GoodsType.allCases.forEach {
            subMenuItems.append($0.subTypes)
        }
        return subMenuItems
    }
}

enum PreservedFlowerType: String, CaseIterable {
    case mainFlower = "主花"
    case material = "花材"
    case leaf  = "葉材"
}

enum DriedFlowerType: String, CaseIterable {
    case sola = "索拉花"
    case handMade = "手工花"
    case material = "花材"
    case leaf = "葉材"
    case fruit = "果實"
}

enum PackageType: String, CaseIterable {
    case paper  = "包裝紙"
    case ribbon = "緞帶"
    case bag = "袋子"
    case box = "盒子"
    case carton = "箱子"
}

enum OtherType: String, CaseIterable {
    case porcelain  = "瓷器類"
    case glass = "玻璃類"
    case wood = "木製類"
    case plasticContainer = "塑膠容器"
    case candleContainer = "蠟燭容器"
    case tool = "工具類"
    case ironWire = "鐵絲"
    case other = "其他"
}
