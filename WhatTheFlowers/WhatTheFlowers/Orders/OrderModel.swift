//
//  OrderModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/30.
//

import Foundation

struct OrderModel: Codable {
    var photoName: String = ""
    var content: String = ""
    var deadline: TimeInterval = Date().timeIntervalSince1970
    var name: String = ""
    var price: Int = 0
    var sendType: String = "1"
    var source: String = "1"
    var status: String = "1"

    enum CodingKeys: String, CodingKey {
        case source
        case name
        case price
        case content
        case deadline
        case status
        case sendType = "send_type"
        case photoName = "photo_name"
    }

    init(dictionary: [String: Any] = [:]) {
        do {
            self = try JSONDecoder().decode(OrderModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch {
            print(error)
        }
    }

    func transformCellModel(orderID: String) -> OrderTableViewCellModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY / MM / dd"
        return OrderTableViewCellModel(
            id: orderID,
            source: OrderSource(rawValue: source) ?? .shopee,
            name: name,
            price: price > 0 ? "$\(price)" : "$未確認",
            content: content,
            deadline: dateFormatter.string(from: Date(timeIntervalSince1970: deadline)),
            status: OrderStatus(rawValue: status) ?? .normal,
            sendType: OrderSendType(rawValue: sendType) ?? .mailing,
            photoName: photoName
        )
    }
}
