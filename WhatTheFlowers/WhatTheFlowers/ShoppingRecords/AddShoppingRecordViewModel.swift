//
//  AddShoppingRecordViewModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/9.
//

import Foundation
import Firebase

protocol AddShoppingRecordViewModelInput {
    func loadData()

    func updateText(_ indexPath: IndexPath, text: String)
    func updateMultiSelect(_ indexPath: IndexPath, values: [String])
    func updateDate(_ indexPath: IndexPath, value: Date)
    func updatePhoto(_ indexPath: IndexPath, photoName: String)
    func deletePhoto(_ indexPath: IndexPath)
    func uploading(_ indexPath: IndexPath)
    func uploadSuccess(_ indexPath: IndexPath)

    func saveRecord()
}

protocol AddShoppingRecordViewModelOutput {
    var title: String { get }
    var sections: [AddShoppingRecordSection] { get }

    var closeVC: (() -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var changeSaveButtonStatus: ((Bool) -> Void)? { get set }

    var startLoading: (() -> Void)? { get set }
    var stopLoading: (() -> Void)? { get set }
}

class AddShoppingRecordViewModel: AddShoppingRecordViewModelInput, AddShoppingRecordViewModelOutput {
    var input: AddShoppingRecordViewModelInput { return self }
    var output: AddShoppingRecordViewModelOutput { return self }

    var reloadData: (() -> Void)?
    var closeVC: (() -> Void)?
    var changeSaveButtonStatus: ((Bool) -> Void)?
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?

    private let recordID: String
    private var model: ShoppingRecordModel = ShoppingRecordModel()
    private(set) var title: String
    private(set) var sections: [AddShoppingRecordSection]

    init(recordID: String) {
        self.recordID = recordID
        title = recordID.isEmpty ? "新增紀錄" : "編輯紀錄"
        sections = AddShoppingRecordSection.makeSections(model: model)
    }

    func loadData() {
        guard !recordID.isEmpty else {
            return
        }
        startLoading?()
        let db = Firestore.firestore()
        db.collection("shopping_records").document(recordID).getDocument{ (document, err) in
            self.stopLoading?()
            if let err = err {
                print("Error get document: \(err)")
            } else if let document = document, document.exists {
                let model = ShoppingRecordModel(dictionary: document.data() ?? [:])
                self.model = model
                self.sections = AddShoppingRecordSection.makeSections(model: model)
            }
            self.reloadData?()
            self.checkSaveButtonStatus()
        }
    }

    private func jieba(string: NSString) -> [String] {
        var keywords: [String] = []
        var keyword = ""
        var range: CFRange = CFRange()
        let ref = CFStringTokenizerCreate(nil, string, CFRangeMake(0, string.length), kCFStringTokenizerUnitWordBoundary, nil)
        CFStringTokenizerAdvanceToNextToken(ref)
        range = CFStringTokenizerGetCurrentTokenRange(ref)
        while (range.length>0) {
            keyword = string.substring(with: NSMakeRange(range.location, range.length))
            keywords.append(keyword)
            CFStringTokenizerAdvanceToNextToken(ref)
            range = CFStringTokenizerGetCurrentTokenRange(ref)
        }
        return keywords
    }

    func saveRecord() {
        let jieba1 = jieba(string: model.name as NSString)
        let jieba2 = jieba(string: model.color as NSString)
        let keywords = jieba1 + jieba2
        model.keywords = keywords
        guard let data = model.convertToDict() else {
            return
        }
        startLoading?()
        let db = Firestore.firestore()
        let ref = recordID.isEmpty ? db.collection("shopping_records").document() : db.collection("shopping_records").document(recordID)
        ref.setData(data, merge: true) { err in
            self.stopLoading?()
            if let err = err {
                print("Error set document: \(err)")
            } else {
                self.searchStock()
                NotificationCenter.default.post(ShoppingRecordsUserInfo(isSuccess: true))
                self.closeVC?()
            }
        }
    }

    func searchStock() {
        let price = Float(model.price / model.quantity)
        var stockID = ""
        var stockModel = StockModel()
        stockModel.photoName = model.photoName
        stockModel.name = model.name
        stockModel.mainType = model.mainType
        stockModel.subType = model.subType
        stockModel.color = model.color
        stockModel.length = model.length
        stockModel.width = model.width
        stockModel.height = model.height
        stockModel.price = price
        stockModel.unit = model.unit
        stockModel.quantity = model.quantity
        stockModel.keywords = model.keywords
        let db = Firestore.firestore()
        db.collection("stock")
            .whereField("name", isEqualTo: model.name)
            .whereField("color", isEqualTo: model.color)
            .whereField("price", isEqualTo: price)
            .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    return
                }
                for document in documents {
                    let model = StockModel(dictionary: document.data())
                    stockModel.quantity = model.quantity + self.model.quantity
                    stockID = document.documentID
                    break
                }
            }
        }
        saveStock(stockID: stockID, stockModel: stockModel)
    }

    func saveStock(stockID: String, stockModel: StockModel) {
        guard let data = stockModel.convertToDict() else {
            return
        }
        let db = Firestore.firestore()
        let ref = stockID.isEmpty ? db.collection("stock").document() : db.collection("stock").document(stockID)
        ref.setData(data, merge: true) { err in
            if let err = err {
                print("Error set document: \(err)")
            } else {
                print("Set document success")
                NotificationCenter.default.post(StockUserInfo(isSuccess: true))
            }
        }
    }

    func updatePhoto(_ indexPath: IndexPath, photoName: String) {
        switch sections[indexPath.section] {
        case .basic(let rows):
            switch rows[indexPath.row] {
            case .photo:
                model.photoName = photoName
                sections[indexPath.section].updateValue(row: indexPath.row, value: photoName)

            default:
                break
            }
        }
    }

    func deletePhoto(_ indexPath: IndexPath) {
        if !model.photoName.isEmpty {
            let storageRef = Storage.storage().reference()
            let imagesRef = storageRef.child("photos/\(model.photoName)")

            imagesRef.delete { error in
                if let error = error {
                    print(error)
                } else {
                    self.updatePhoto(indexPath, photoName: "")
                }
            }
        }
    }

    func uploading(_ indexPath: IndexPath) {
        changeSaveButtonStatus?(false)
    }

    func uploadSuccess(_ indexPath: IndexPath) {
        checkSaveButtonStatus()
    }

    func updateText(_ indexPath: IndexPath, text: String) {
        switch sections[indexPath.section] {
        case .basic(let rows):
            switch rows[indexPath.row] {
            case .name:
                model.name = text
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .color:
                model.color = text
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .place:
                model.place = text
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .length:
                model.length = Float(text) ?? 0.0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .width:
                model.width = Float(text) ?? 0.0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .height:
                model.height = Float(text) ?? 0.0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .price:
                model.price = Int(text) ?? 0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .quantity:
                model.quantity = Int(text) ?? 0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .unit:
                model.unit = text
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .content:
                model.content = text
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            default:
                break
            }
        }
        checkSaveButtonStatus()
    }

    func updateMultiSelect(_ indexPath: IndexPath, values: [String]) {
        switch sections[indexPath.section] {
        case .basic(let rows):
            switch rows[indexPath.row] {
            case .goodsType:
                model.mainType = values[safe: 0] ?? ""
                model.subType = values[safe: 1] ?? ""
                sections[indexPath.section].updateMultiValue(row: indexPath.row, value: values)

            default:
                break
            }
        }
        reloadData?()
        checkSaveButtonStatus()
    }

    func updateDate(_ indexPath: IndexPath, value: Date) {
        switch sections[indexPath.section] {
        case .basic(let rows):
            switch rows[indexPath.row] {
            case .date:
                model.date = value.timeIntervalSince1970
                sections[indexPath.section].updateDate(row: indexPath.row, date: value)

            default:
                break
            }
        }
        reloadData?()
        checkSaveButtonStatus()
    }

    private func checkSaveButtonStatus() {
        let isEnabled: Bool = !model.name.isEmpty && !model.mainType.isEmpty && !model.place.isEmpty && model.price != 0 &&  model.quantity != 0
        changeSaveButtonStatus?(isEnabled)
    }

}
