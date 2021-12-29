//
//  StockModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/15.
//

import Foundation

struct StockModel: Codable {
    var photoName: String = ""
    var name: String = ""
    var mainType: String = ""
    var subType: String = ""
    var color: String = ""
    var length: Float = 0.0
    var width: Float = 0.0
    var height: Float = 0.0
    var date: TimeInterval = Date().timeIntervalSince1970
    var price: Float = 0.0
    var quantity: Int = 0
    var unit: String = ""
    var keywords: [String]? = nil

    enum CodingKeys: String, CodingKey {
        case photoName = "photo_name"
        case name
        case mainType = "main_type"
        case subType = "sub_type"
        case color
        case length
        case date
        case width
        case height
        case price
        case quantity
        case unit
        case keywords
    }

    init(dictionary: [String: Any] = [:]) {
        do {
            self = try JSONDecoder().decode(StockModel.self, from: JSONSerialization.data(withJSONObject: dictionary))
        } catch {
            print(error)
        }
    }

    func transformCellModel(stockID: String) -> StockTableViewCellModel {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY / MM / dd"
        var size = "\(length)*\(width)*\(height)"
        if length == 0, width == 0, height == 0 {
            size = ""
        }
        return StockTableViewCellModel(
            id: stockID,
            name: name,
            color: color,
            size: size,
            price: price > 0 ? "$\(price)" : "$未確認",
            quantity: "庫存數量：\(quantity)\(unit)",
            date: dateFormatter.string(from: Date(timeIntervalSince1970: date)),
            photoName: photoName
        )
    }
}
