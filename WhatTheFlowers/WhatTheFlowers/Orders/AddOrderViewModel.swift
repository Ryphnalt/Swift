//
//  AddOrderViewModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/4/27.
//

import Foundation
import Firebase

protocol AddOrderViewModelInput {
    func loadData()

    func updateText(_ indexPath: IndexPath, text: String)
    func updateSelect(_ indexPath: IndexPath, rowIndex: Int)
    func updateDate(_ indexPath: IndexPath, value: Date)
    func updatePhoto(_ indexPath: IndexPath, photoName: String)
    func deletePhoto(_ indexPath: IndexPath)
    func uploading(_ indexPath: IndexPath)
    func uploadSuccess(_ indexPath: IndexPath)

    func saveOrder()
}

protocol AddOrderViewModelOutput {
    var title: String { get }
    var sections: [AddOrderSection] { get }

    var closeVC: (() -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var changeSaveButtonStatus: ((Bool) -> Void)? { get set }

    var startLoading: (() -> Void)? { get set }
    var stopLoading: (() -> Void)? { get set }
}

class AddOrderViewModel: AddOrderViewModelInput, AddOrderViewModelOutput {
    var input: AddOrderViewModelInput { return self }
    var output: AddOrderViewModelOutput { return self }

    var reloadData: (() -> Void)?
    var closeVC: (() -> Void)?
    var changeSaveButtonStatus: ((Bool) -> Void)?
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?

    private let orderID: String
    private var model: OrderModel = OrderModel()
    private(set) var title: String
    private(set) var sections: [AddOrderSection]

    init(orderID: String) {
        self.orderID = orderID
        title = orderID.isEmpty ? "新增訂單" : "編輯訂單"
        sections = AddOrderSection.makeSections(model: model)
    }

    func loadData() {
        guard !orderID.isEmpty else {
            return
        }
        startLoading?()
        let db = Firestore.firestore()
        db.collection("orders").document(orderID).getDocument{ (document, err) in
            self.stopLoading?()
            if let err = err {
                print("Error get document: \(err)")
            } else if let document = document, document.exists {
                let model = OrderModel(dictionary: document.data() ?? [:])
                self.model = model
                self.sections = AddOrderSection.makeSections(model: model)
            }
            self.reloadData?()
            self.checkSaveButtonStatus()
        }
    }

    func saveOrder() {
        guard let data = model.convertToDict() else {
            return
        }
        startLoading?()
        let db = Firestore.firestore()
        let ref = orderID.isEmpty ? db.collection("orders").document() : db.collection("orders").document(orderID)
        ref.setData(data, merge: true) { err in
            self.stopLoading?()
            if let err = err {
                print("Error set document: \(err)")
            } else {
                NotificationCenter.default.post(OrdersUserInfo(isSuccess: true))
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

            case .price:
                model.price = Int(text) ?? 0
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

    func updateSelect(_ indexPath: IndexPath, rowIndex: Int) {
        switch sections[indexPath.section] {
        case .basic(let rows):
            switch rows[indexPath.row] {
            case .source:
                let value = String(rowIndex + 1)
                model.source = value
                sections[indexPath.section].updateValue(row: indexPath.row, value: value)

            case .sendType:
                let value = String(rowIndex + 1)
                model.sendType = value
                sections[indexPath.section].updateValue(row: indexPath.row, value: value)

            case .status:
                let value = String(rowIndex + 1)
                model.status = value
                sections[indexPath.section].updateValue(row: indexPath.row, value: value)

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
            case .deadline:
                model.deadline = value.timeIntervalSince1970
                sections[indexPath.section].updateDate(row: indexPath.row, date: value)

            default:
                break
            }
        }
        reloadData?()
        checkSaveButtonStatus()
    }

    private func checkSaveButtonStatus() {
        let isEnabled: Bool = !model.source.isEmpty && !model.name.isEmpty && !model.content.isEmpty && !model.status.isEmpty
        changeSaveButtonStatus?(isEnabled)
    }

}
