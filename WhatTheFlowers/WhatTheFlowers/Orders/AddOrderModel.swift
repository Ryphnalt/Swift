//
//  AddOrderModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/28.
//

import Foundation

enum AddOrderSection {
    case basic([Basic])

    enum Basic {
        case photo(UploadPhotoTableViewCellModel)
        case source(DropMenuTableViewCellModel)
        case name(TextFieldTableViewCellModel)
        case price(TextFieldTableViewCellModel)
        case content(TextViewTableViewCellModel)
        case sendType(DropMenuTableViewCellModel)
        case deadline(DatePickerTableViewCellModel)
        case status(DropMenuTableViewCellModel)

        static func makeRows(model: OrderModel?) -> [Self] {
            let photo: Basic = .photo(
                UploadPhotoTableViewCellModel(
                    photoName: model?.photoName ?? ""
                ))

            let source: Basic = .source(
                DropMenuTableViewCellModel(
                    title: "訂單來源",
                    text: OrderSource(rawValue: model?.source ?? "1")?.text ?? "",
                    value: model?.source ?? "1",
                    placeholder: "",
                    menuItems: OrderSource.allCases.map { $0.text }
                ))

            let name: Basic = .name(
                TextFieldTableViewCellModel(
                    title: "訂購人",
                    text: model?.name ?? "",
                    value: model?.name ?? "",
                    placeholder: "",
                    keyboardType: .default
                ))

            let priceInteger = model?.price ?? 0
            let price: Basic = .price(
                TextFieldTableViewCellModel(
                    title: "訂單金額",
                    text: priceInteger > 0 ? String(priceInteger) : "",
                    value: priceInteger > 0 ? String(priceInteger) : "",
                    placeholder: "",
                    keyboardType: .numberPad
                ))

            let content: Basic = .content(
                TextViewTableViewCellModel(
                    title: "訂單內容",
                    text: model?.content ?? "",
                    value: model?.content ?? "",
                    placeholder: ""
                ))

            let sendTypeText = OrderSendType(rawValue: model?.sendType ?? "1")?.text ?? ""
            let sendType: Basic = .sendType(
                DropMenuTableViewCellModel(
                    title: "寄送方式",
                    text: sendTypeText,
                    value: model?.status ?? "1",
                    placeholder: "",
                    menuItems: OrderSendType.allCases.map { $0.text }
                ))

            let deadline: Basic = .deadline(
                DatePickerTableViewCellModel(
                    title: sendTypeText.isEmpty ? "訂單期限" : "\(sendTypeText)日期",
                    text: Date(timeIntervalSince1970: model?.deadline ?? 0),
                    value: Date(timeIntervalSince1970: model?.deadline ?? 0),
                    placeholder: ""
                ))

            let status: Basic = .status(
                DropMenuTableViewCellModel(
                    title: "訂單狀態",
                    text: OrderStatus(rawValue: model?.status ?? "1")?.text ?? "",
                    value: model?.status ?? "1",
                    placeholder: "",
                    menuItems: OrderStatus.allCases.map { $0.text }
                ))

            return [
                photo,
                source,
                name,
                price,
                content,
                sendType,
                deadline,
                status
            ]
        }

        mutating func updateValue(value: String)  {
            switch self {
            case .photo(var cellModel):
                cellModel.photoName = value
                self = .photo(cellModel)
            case .source(var cellModel):
                cellModel.text = OrderSource(rawValue: value)?.text ?? ""
                cellModel.value = value
                self = .source(cellModel)
            case .name(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .name(cellModel)
            case .price(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .price(cellModel)
            case .content(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .content(cellModel)
            case .sendType(var cellModel):
                cellModel.text = OrderSendType(rawValue: value)?.text ?? ""
                cellModel.value = value
                self = .sendType(cellModel)
            case .status(var cellModel):
                cellModel.text = OrderStatus(rawValue: value)?.text ?? ""
                cellModel.value = value
                self = .status(cellModel)

            default:
                break
            }
        }

        mutating func updateDate(value: Date) {
            switch self {
            case .deadline(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .deadline(cellModel)
            default:
                break
            }
        }

        mutating func updateTitle(value: String) {
            switch self {
            case .deadline(var cellModel):
                let sendTypeText = OrderSendType(rawValue: value)?.text ?? ""
                cellModel.title = sendTypeText.isEmpty ? "訂單期限" : "\(sendTypeText)日期"
                self = .deadline(cellModel)
            default:
                break
            }
        }
    }

    static func makeSections(model: OrderModel? = nil) -> [AddOrderSection] {
        var result: [AddOrderSection] = []

        let basic: AddOrderSection = .basic(Basic.makeRows(model: model))

        result.append(basic)

        return result
    }

    mutating func updateValue(row: Int, value: String) {
        switch self {
        case .basic(var rows):
            rows[row].updateValue(value: value)
            switch rows[row] {
            case .sendType(let cellModel):
                // 選寄送方式會改變日期標題
                rows[row + 1].updateTitle(value: cellModel.value)
            default:
                break
            }
            self = .basic(rows)
        }
    }

    mutating func updateDate(row: Int, date: Date) {
        switch self {
        case .basic(var rows):
            rows[row].updateDate(value: date)
            self = .basic(rows)
        }
    }

}
