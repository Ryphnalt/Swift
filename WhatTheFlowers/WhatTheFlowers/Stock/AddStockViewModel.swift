//
//  AddStockViewModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/15.
//

import Foundation
import Firebase

protocol AddStockViewModelInput {
    func loadData()

    func updateText(_ indexPath: IndexPath, text: String)
    func updateMultiSelect(_ indexPath: IndexPath, values: [String])
    func updatePhoto(_ indexPath: IndexPath, photoName: String)
    func deletePhoto(_ indexPath: IndexPath)
    func uploading(_ indexPath: IndexPath)
    func uploadSuccess(_ indexPath: IndexPath)

    func saveStock()
}

protocol AddStockViewModelOutput {
    var title: String { get }
    var sections: [AddStockSection] { get }

    var closeVC: (() -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var changeSaveButtonStatus: ((Bool) -> Void)? { get set }

    var startLoading: (() -> Void)? { get set }
    var stopLoading: (() -> Void)? { get set }
}

class AddStockViewModel: AddStockViewModelInput, AddStockViewModelOutput {
    var input: AddStockViewModelInput { return self }
    var output: AddStockViewModelOutput { return self }

    var reloadData: (() -> Void)?
    var closeVC: (() -> Void)?
    var changeSaveButtonStatus: ((Bool) -> Void)?
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?

    private let stockID: String
    private var model: StockModel = StockModel()
    private(set) var title: String
    private(set) var sections: [AddStockSection]

    init(stockID: String) {
        self.stockID = stockID
        title = stockID.isEmpty ? "新增庫存" : "編輯庫存"
        sections = AddStockSection.makeSections(model: model)
    }

    func loadData() {
        guard !stockID.isEmpty else {
            return
        }
        startLoading?()
        let db = Firestore.firestore()
        db.collection("stock").document(stockID).getDocument{ (document, err) in
            self.stopLoading?()
            if let err = err {
                print("Error get document: \(err)")
            } else if let document = document, document.exists {
                let model = StockModel(dictionary: document.data() ?? [:])
                self.model = model
                self.sections = AddStockSection.makeSections(model: model)
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

    func saveStock() {
        let jieba1 = jieba(string: model.name as NSString)
        let jieba2 = jieba(string: model.color as NSString)
        let keywords = jieba1 + jieba2
        model.keywords = keywords
        guard let data = model.convertToDict() else {
            return
        }
        startLoading?()
        let db = Firestore.firestore()
        let ref = stockID.isEmpty ? db.collection("stock").document() : db.collection("stock").document(stockID)
        ref.setData(data, merge: true) { err in
            self.stopLoading?()
            if let err = err {
                print("Error set document: \(err)")
            } else {
                NotificationCenter.default.post(StockUserInfo(isSuccess: true))
                self.closeVC?()
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

            case .length:
                model.length = Float(text) ?? 0.0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .width:
                model.width = Float(text) ?? 0.0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .height:
                model.height = Float(text) ?? 0.0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .quantity:
                model.quantity = Int(text) ?? 0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .price:
                model.price = Float(text) ?? 0
                sections[indexPath.section].updateValue(row: indexPath.row, value: text)

            case .unit:
                model.unit = text
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

    private func checkSaveButtonStatus() {
        let isEnabled: Bool = !model.name.isEmpty && !model.mainType.isEmpty && model.quantity != 0
        changeSaveButtonStatus?(isEnabled)
    }
}
