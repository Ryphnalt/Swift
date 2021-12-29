//
//  ShoppingRecordModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/9.
//

import Foundation

struct ShoppingRecordModel: Codable {
    var photoName: String = ""
    var name: String = ""
    var mainType: String = ""
    var subType: String = ""
    var color: String = ""
    var place: String = ""
    var date: TimeInterval = Date().timeIntervalSince1970
    var length: Float = 0.0
    var width: Float = 0.0
    var height: Float = 0.0
    var price: Int = 0
    var quantity: Int = 0
    var content: String = ""
    var unit: String = ""
    var keywords: [String]? = nil

    enum CodingKeys: String, CodingKey {
        case photoName = "photo_name"
        case name
        case mainType = "main_type"
        case subType = "sub_type"
        case color
        case place
        case date
        case length
        case width
        case height
        case price
        case quantity
        case unit
        case content
        case keywords
    }

    init(dictionary: [String: Any] = [:]) {
        do {
            self = try JSONDecoder().decode(ShoppingRecordModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch {
            print(error)
        }
    }

    func transformCellModel(recordID: String) -> ShoppingRecordTableViewCellModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY / MM / dd"
        var size = "\(length)*\(width)*\(height)"
        if length == 0, width == 0, height == 0 {
            size = ""
        }
        return ShoppingRecordTableViewCellModel(
            id: recordID,
            name: name,
            type: "\(mainType)\(subType)",
            color: color,
            place: place,
            size: size,
            price: price > 0 ? "$\(price)" : "$未確認",
            quantity: "購買數量：\(quantity)\(unit)",
            content: content,
            date: dateFormatter.string(from: Date(timeIntervalSince1970: date)),
            photoName: photoName
        )
    }
}
