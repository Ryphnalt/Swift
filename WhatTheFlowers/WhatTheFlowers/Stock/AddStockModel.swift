//
//  AddStockModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/15.
//

import Foundation

enum AddStockSection {
    case basic([Basic])

    enum Basic {
        case photo(UploadPhotoTableViewCellModel)
        case name(TextFieldTableViewCellModel)
        case goodsType(DoubleDropMenuTableViewCellModel)
        case color(TextFieldTableViewCellModel)
        case length(TextFieldTableViewCellModel)
        case width(TextFieldTableViewCellModel)
        case height(TextFieldTableViewCellModel)
        case price(TextFieldTableViewCellModel)
        case quantity(TextFieldTableViewCellModel)
        case unit(TextFieldTableViewCellModel)

        static func makeRows(model: StockModel?) -> [Self] {
            let photo: Basic = .photo(
                UploadPhotoTableViewCellModel(
                    photoName: model?.photoName ?? ""
                ))

            let name: Basic = .name(
                TextFieldTableViewCellModel(
                    title: "品名",
                    text: model?.name ?? "",
                    value: model?.name ?? "",
                    placeholder: "",
                    keyboardType: .default
                ))

            let goodsType: Basic = .goodsType(
                DoubleDropMenuTableViewCellModel(
                    title: "產品類型",
                    mainText: model?.mainType ?? "",
                    subText: model?.subType ?? "",
                    mainValue: model?.mainType ?? "",
                    subValue: model?.subType ?? "",
                    mainPlaceholder: "",
                    subPlaceholder: "",
                    mainMenuItems: GoodsType.allCases.map { $0.rawValue },
                    subMenuItems: GoodsType.subMenuItems
                ))

            let color: Basic = .color(
                TextFieldTableViewCellModel(
                    title: "顏色",
                    text: model?.color ?? "",
                    value: model?.color ?? "",
                    placeholder: "",
                    keyboardType: .default
                ))

            let length: Basic = .length(
                TextFieldTableViewCellModel(
                    title: "長(公分)",
                    text: "\(model?.length ?? 0.0)",
                    value: "\(model?.length ?? 0.0)",
                    placeholder: "",
                    keyboardType: .decimalPad
                ))

            let width: Basic = .width(
                TextFieldTableViewCellModel(
                    title: "寬(公分)",
                    text: "\(model?.width ?? 0.0)",
                    value: "\(model?.width ?? 0.0)",
                    placeholder: "",
                    keyboardType: .decimalPad
                ))

            let height: Basic = .height(
                TextFieldTableViewCellModel(
                    title: "高(公分)",
                    text: "\(model?.height ?? 0.0)",
                    value: "\(model?.height ?? 0.0)",
                    placeholder: "",
                    keyboardType: .decimalPad
                ))

            let priceInteger = model?.price ?? 0
            let price: Basic = .price(
                TextFieldTableViewCellModel(
                    title: "單價",
                    text: priceInteger > 0 ? String(priceInteger) : "",
                    value: priceInteger > 0 ? String(priceInteger) : "",
                    placeholder: "",
                    keyboardType: .decimalPad
                ))

            let quantityInteger = model?.quantity ?? 0
            let quantity: Basic = .quantity(
                TextFieldTableViewCellModel(
                    title: "數量",
                    text: quantityInteger > 0 ? String(quantityInteger) : "",
                    value: quantityInteger > 0 ? String(quantityInteger) : "",
                    placeholder: "",
                    keyboardType: .numberPad
                ))

            let unit: Basic = .unit(
                TextFieldTableViewCellModel(
                    title: "單位",
                    text: model?.unit ?? "",
                    value: model?.unit ?? "",
                    placeholder: "",
                    keyboardType: .default
                ))

            return [
                photo,
                name,
                goodsType,
                color,
                length,
                width,
                height,
                price,
                quantity,
                unit
            ]
        }

        mutating func updateValue(value: String) {
            switch self {
            case .photo(var cellModel):
                cellModel.photoName = value
                self = .photo(cellModel)
            case .name(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .name(cellModel)
            case .color(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .color(cellModel)
            case .length(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .length(cellModel)
            case .width(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .width(cellModel)
            case .height(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .height(cellModel)
            case .price(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .price(cellModel)
            case .quantity(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .quantity(cellModel)
            case .unit(var cellModel):
                cellModel.text = value
                cellModel.value = value
                self = .unit(cellModel)
            default:
                break
            }
        }

        mutating func updateMultiValue(value: [String]) {
            switch self {
            case .goodsType(var cellModel):
                cellModel.mainText = value[safe: 0] ?? ""
                cellModel.subText = value[safe: 1] ?? ""
                cellModel.mainValue = value[safe: 0] ?? ""
                cellModel.subValue = value[safe: 1] ?? ""
                self = .goodsType(cellModel)
            default:
                break
            }
        }
    }

    static func makeSections(model: StockModel? = nil) -> [AddStockSection] {
        var result: [AddStockSection] = []

        let basic: AddStockSection = .basic(Basic.makeRows(model: model))

        result.append(basic)

        return result
    }

    mutating func updateValue(row: Int, value: String) {
        switch self {
        case .basic(var rows):
            rows[row].updateValue(value: value)
            self = .basic(rows)
        }
    }

    mutating func updateMultiValue(row: Int, value: [String]) {
        switch self {
        case .basic(var rows):
            rows[row].updateMultiValue(value: value)
            self = .basic(rows)
        }
    }

}
