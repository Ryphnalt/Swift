//
//  ShoppingRecordsViewModel.swift
//  WhatTheFlowers
//
//  Created by Mars Lee on 2021/5/13.
//

import Foundation
import Firebase

protocol ShoppingRecordsViewModelInput {
    func loadData()
    func loadData(with keyword: String)
    func didTapCell(indexPath: IndexPath)
    func didTapDelete(indexPath: IndexPath)
    func didTapEdit(indexPath: IndexPath)
    func nextPage(indexPath: IndexPath)
}

protocol ShoppingRecordsViewModelOutput {
    var list: [ShoppingRecordTableViewCellModel] { get }
    var startLoading: (() -> Void)? { get set }
    var stopLoading: (() -> Void)? { get set }
    var reloadData: (() -> Void)? { get set }
    var popActionSheet: ((IndexPath) -> Void)? { get set }
    var presentEditRecordVC: ((String) -> Void)? { get set }
    var didDeleteSuccess: ((IndexPath) -> Void)? { get set }
}

class ShoppingRecordsViewModel: ShoppingRecordsViewModelInput, ShoppingRecordsViewModelOutput {
    var input: ShoppingRecordsViewModelInput { return self }
    var output: ShoppingRecordsViewModelOutput { return self }

    var reloadData: (() -> Void)?
    var startLoading: (() -> Void)?
    var stopLoading: (() -> Void)?
    var popActionSheet: ((IndexPath) -> Void)?
    var presentEditRecordVC: ((String) -> Void)?
    var didDeleteSuccess: ((IndexPath) -> Void)?

    private(set) var list: [ShoppingRecordTableViewCellModel] = []
    private var lastQuery: Query? = nil
    private let perPage: Int = 30

    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.shoppingRecordsNotification(notification:)), name: .shoppingRecordsChanged, object: nil)
    }

    func loadData() {
        startLoading?()
        let db = Firestore.firestore()
        var query = db.collection("shopping_records").order(by: "date", descending: true).end(at: [0]).limit(to: perPage)
        if let lastQuery = lastQuery {
            query = lastQuery
        }
        query.addSnapshotListener { (snapshot, error) in
            self.stopLoading?()
            guard let snapshot = snapshot else {
                print("Error retreving cities: \(error.debugDescription)")
                return
            }
            guard let lastSnapshot = snapshot.documents.last else {
                // The collection is empty.
                return
            }
            var documents = snapshot.documents
            documents.sort { a, b in
                let dateA: TimeInterval = a.data()["date"] as? TimeInterval ?? TimeInterval()
                let dateB: TimeInterval = b.data()["date"] as? TimeInterval ?? TimeInterval()
                return dateA >= dateB
            }
            for document in snapshot.documents {
                let model = ShoppingRecordModel(dictionary: document.data())
                self.list.append(model.transformCellModel(recordID: document.documentID))
            }
            self.reloadData?()

            self.lastQuery = db.collection("stock").order(by: "name").end(beforeDocument: lastSnapshot).limit(to: self.perPage)
        }
    }

    func loadData(with keyword: String) {
        let keywords = keyword.split(separator: " ")
        initData()
        reloadData?()
        startLoading?()
        let db = Firestore.firestore()
        let ref = db.collection("shopping_records")
        let query = ref.whereField("keywords", arrayContainsAny: keywords)
        query.order(by: "date", descending: true)
            .end(at: [0])
            .limit(to: 50)
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    guard var documents = querySnapshot?.documents else {
                        return
                    }
                    documents.sort { a, b in
                        let dateA: TimeInterval = a.data()["date"] as? TimeInterval ?? TimeInterval()
                        let dateB: TimeInterval = b.data()["date"] as? TimeInterval ?? TimeInterval()
                        return dateA >= dateB
                    }
                    for document in documents {
                        let model = ShoppingRecordModel(dictionary: document.data())
                        self.list.append(model.transformCellModel(recordID: document.documentID))
                    }
                    self.reloadData?()
                    self.stopLoading?()
                }
        }
    }

    func didTapCell(indexPath: IndexPath) {
        popActionSheet?(indexPath)
    }

    func didTapDelete(indexPath: IndexPath) {
        startLoading?()
        let db = Firestore.firestore()
        db.collection("shopping_records").document(list[indexPath.row].id).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                self.list.remove(at: indexPath.row)
                self.didDeleteSuccess?(indexPath)
                self.stopLoading?()
            }
        }
    }

    func didTapEdit(indexPath: IndexPath) {
        presentEditRecordVC?(list[indexPath.row].id)
    }

    @objc func shoppingRecordsNotification(notification: Notification) {
        guard let _ = ShoppingRecordsUserInfo(notification: notification) else {
            return
        }
        refreshData()
    }

    private func initData() {
        list = []
    }

    private func refreshData() {
        initData()
        loadData()
    }

    func nextPage(indexPath: IndexPath) {
        if indexPath.row == list.count - 5 {
            loadData()
        }
    }
}
