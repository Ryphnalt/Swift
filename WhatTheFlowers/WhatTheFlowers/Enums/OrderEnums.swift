//
//  OrderEnums.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/28.
//

enum OrderStatus: String, CaseIterable {
    case normal = "1"
    case notFaceToFace = "2"
    case notMailing = "3"
    case finished = "4"

    var text: String {
        switch self {
        case .normal:
            return "未製作"
        case .notFaceToFace:
            return "待面交"
        case .notMailing:
            return "待出貨"
        case .finished:
            return "已完成"
        }
    }
}

enum OrderSource: String, CaseIterable {
    case shopee = "1"
    case facebook = "2"
    case instgram = "3"
    case friends = "4"
    case other = "5"

    var text: String {
        switch self {
        case .shopee:
            return "蝦皮購物"
        case .facebook:
            return "Facebook"
        case .instgram:
            return "Instgram"
        case .friends:
            return "朋友訂購"
        case .other:
            return "其他"
        }
    }
}

enum OrderSendType: String, CaseIterable {
    case mailing = "1"
    case faceToFace = "2"

    var text: String {
        switch self {
        case .mailing:
            return "寄送"
        case .faceToFace:
            return "面交"
        }
    }
}
